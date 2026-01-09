import SwiftUI
import Foundation

// MARK: - Habit Tracking System
// A comprehensive habit tracking system with streaks, reminders, and insights.

// MARK: - Habit Model

/// Represents a trackable habit with customizable schedule and rewards
struct Habit: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var description: String
    var iconName: String
    var colorHex: String
    var dimension: LifeDimension
    var schedule: HabitSchedule
    var xpReward: Int
    var targetCount: Int // How many times per period
    var createdDate: Date
    var isArchived: Bool
    var reminderTime: Date?
    var reminderEnabled: Bool
    
    init(
        name: String,
        description: String = "",
        iconName: String = "checkmark.circle.fill",
        colorHex: String = "6366F1",
        dimension: LifeDimension = .mind,
        schedule: HabitSchedule = .daily,
        xpReward: Int = 10,
        targetCount: Int = 1,
        reminderTime: Date? = nil,
        reminderEnabled: Bool = false
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.iconName = iconName
        self.colorHex = colorHex
        self.dimension = dimension
        self.schedule = schedule
        self.xpReward = xpReward
        self.targetCount = targetCount
        self.createdDate = Date()
        self.isArchived = false
        self.reminderTime = reminderTime
        self.reminderEnabled = reminderEnabled
    }
    
    var color: Color {
        Color(hex: colorHex, default: BrandTheme.accent)
    }
}

/// Schedule frequency for habits
enum HabitSchedule: String, Codable, CaseIterable, Identifiable {
    case daily = "daily"
    case weekdays = "weekdays"
    case weekends = "weekends"
    case weekly = "weekly"
    case custom = "custom"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .daily: return "Every day"
        case .weekdays: return "Weekdays"
        case .weekends: return "Weekends"
        case .weekly: return "Weekly"
        case .custom: return "Custom"
        }
    }
    
    var icon: String {
        switch self {
        case .daily: return "calendar"
        case .weekdays: return "briefcase.fill"
        case .weekends: return "sun.max.fill"
        case .weekly: return "calendar.badge.clock"
        case .custom: return "gearshape.fill"
        }
    }
}

/// Record of habit completion
struct HabitCompletion: Identifiable, Codable, Equatable {
    let id: String
    let habitID: String
    let date: Date
    let count: Int
    let note: String?
    
    init(habitID: String, date: Date = Date(), count: Int = 1, note: String? = nil) {
        self.id = UUID().uuidString
        self.habitID = habitID
        self.date = date
        self.count = count
        self.note = note
    }
}

/// Statistics for a habit
struct HabitStats {
    let habit: Habit
    let currentStreak: Int
    let bestStreak: Int
    let totalCompletions: Int
    let completionRate: Double
    let totalXPEarned: Int
    let thisWeekCompletions: Int
    let lastCompletedDate: Date?
}

// MARK: - Habit Manager

@MainActor
final class HabitManager: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var completions: [HabitCompletion] = []
    
    private let habitsKey = "lifeXP.habits"
    private let completionsKey = "lifeXP.habitCompletions"
    private let calendar = Calendar.current
    
    init() {
        loadData()
    }
    
    // MARK: - Habit CRUD
    
    func addHabit(_ habit: Habit) {
        habits.insert(habit, at: 0)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        completions.removeAll { $0.habitID == habit.id }
        saveHabits()
        saveCompletions()
    }
    
    func archiveHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isArchived = true
            saveHabits()
        }
    }
    
    // MARK: - Completion Tracking
    
    func completeHabit(_ habit: Habit, count: Int = 1, note: String? = nil) {
        let completion = HabitCompletion(habitID: habit.id, count: count, note: note)
        completions.insert(completion, at: 0)
        saveCompletions()
    }
    
    func uncompleteHabit(_ habit: Habit, for date: Date = Date()) {
        let dayStart = calendar.startOfDay(for: date)
        completions.removeAll { completion in
            completion.habitID == habit.id &&
            calendar.startOfDay(for: completion.date) == dayStart
        }
        saveCompletions()
    }
    
    func isCompleted(_ habit: Habit, for date: Date = Date()) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        return completions.contains { completion in
            completion.habitID == habit.id &&
            calendar.startOfDay(for: completion.date) == dayStart
        }
    }
    
    func completionCount(_ habit: Habit, for date: Date = Date()) -> Int {
        let dayStart = calendar.startOfDay(for: date)
        return completions
            .filter { $0.habitID == habit.id && calendar.startOfDay(for: $0.date) == dayStart }
            .reduce(0) { $0 + $1.count }
    }
    
    // MARK: - Streaks
    
    func currentStreak(for habit: Habit) -> Int {
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        while true {
            if shouldTrackHabit(habit, on: checkDate) {
                if hasCompletion(habit, on: checkDate) {
                    streak += 1
                } else if calendar.isDateInToday(checkDate) {
                    // Today doesn't count against streak if not completed yet
                } else {
                    break
                }
            }
            
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDay
            
            // Limit to 365 days to prevent infinite loops
            if streak > 365 { break }
        }
        
        return streak
    }
    
    func bestStreak(for habit: Habit) -> Int {
        guard !completions.isEmpty else { return 0 }
        
        let habitCompletions = completions.filter { $0.habitID == habit.id }
        guard !habitCompletions.isEmpty else { return 0 }
        
        let sortedDates = habitCompletions
            .map { calendar.startOfDay(for: $0.date) }
            .sorted()
        
        var best = 0
        var current = 0
        var lastDate: Date?
        
        for date in sortedDates {
            if let last = lastDate {
                let diff = calendar.dateComponents([.day], from: last, to: date).day ?? 0
                if diff == 1 {
                    current += 1
                } else if diff > 1 {
                    best = max(best, current)
                    current = 1
                }
            } else {
                current = 1
            }
            lastDate = date
        }
        
        return max(best, current)
    }
    
    private func hasCompletion(_ habit: Habit, on date: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        return completions.contains { completion in
            completion.habitID == habit.id &&
            calendar.startOfDay(for: completion.date) == dayStart
        }
    }
    
    private func shouldTrackHabit(_ habit: Habit, on date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        let isWeekend = weekday == 1 || weekday == 7
        
        switch habit.schedule {
        case .daily:
            return true
        case .weekdays:
            return !isWeekend
        case .weekends:
            return isWeekend
        case .weekly:
            // Track on the same weekday as creation
            let creationWeekday = calendar.component(.weekday, from: habit.createdDate)
            return weekday == creationWeekday
        case .custom:
            return true // For custom, always count
        }
    }
    
    // MARK: - Statistics
    
    func stats(for habit: Habit) -> HabitStats {
        let habitCompletions = completions.filter { $0.habitID == habit.id }
        let total = habitCompletions.reduce(0) { $0 + $1.count }
        
        // Calculate completion rate (last 30 days)
        guard let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) else {
            return HabitStats(
                habit: habit,
                currentStreak: 0,
                bestStreak: 0,
                totalCompletions: total,
                completionRate: 0,
                totalXPEarned: total * habit.xpReward,
                thisWeekCompletions: 0,
                lastCompletedDate: nil
            )
        }
        
        var scheduledDays = 0
        var completedDays = 0
        var checkDate = thirtyDaysAgo
        
        while checkDate <= Date() {
            if shouldTrackHabit(habit, on: checkDate) {
                scheduledDays += 1
                if hasCompletion(habit, on: checkDate) {
                    completedDays += 1
                }
            }
            checkDate = calendar.date(byAdding: .day, value: 1, to: checkDate) ?? Date()
        }
        
        let rate = scheduledDays > 0 ? Double(completedDays) / Double(scheduledDays) : 0
        
        // This week
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        let thisWeek = habitCompletions.filter { $0.date >= weekStart }.count
        
        let lastCompleted = habitCompletions.sorted { $0.date > $1.date }.first?.date
        
        return HabitStats(
            habit: habit,
            currentStreak: currentStreak(for: habit),
            bestStreak: bestStreak(for: habit),
            totalCompletions: total,
            completionRate: rate,
            totalXPEarned: total * habit.xpReward,
            thisWeekCompletions: thisWeek,
            lastCompletedDate: lastCompleted
        )
    }
    
    // MARK: - Filters
    
    var activeHabits: [Habit] {
        habits.filter { !$0.isArchived }
    }
    
    var archivedHabits: [Habit] {
        habits.filter { $0.isArchived }
    }
    
    func habitsDue(for date: Date = Date()) -> [Habit] {
        activeHabits.filter { shouldTrackHabit($0, on: date) && !isCompleted($0, for: date) }
    }
    
    func habitsCompleted(for date: Date = Date()) -> [Habit] {
        activeHabits.filter { shouldTrackHabit($0, on: date) && isCompleted($0, for: date) }
    }
    
    var todayProgress: Double {
        let due = activeHabits.filter { shouldTrackHabit($0, on: Date()) }
        guard !due.isEmpty else { return 1.0 }
        let completed = due.filter { isCompleted($0) }.count
        return Double(completed) / Double(due.count)
    }
    
    // MARK: - Calendar Data
    
    func completionData(for month: Date) -> [Date: Int] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return [:]
        }
        
        var data: [Date: Int] = [:]
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                let dayStart = calendar.startOfDay(for: date)
                let count = completions.filter { calendar.startOfDay(for: $0.date) == dayStart }.count
                if count > 0 {
                    data[dayStart] = count
                }
            }
        }
        
        return data
    }
    
    // MARK: - Persistence
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
    }
    
    private func saveCompletions() {
        // Keep only last 90 days of completions to manage storage
        if let cutoff = calendar.date(byAdding: .day, value: -90, to: Date()) {
            completions = completions.filter { $0.date > cutoff }
        }
        
        if let encoded = try? JSONEncoder().encode(completions) {
            UserDefaults.standard.set(encoded, forKey: completionsKey)
        }
    }
    
    private func loadData() {
        if let habitsData = UserDefaults.standard.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: habitsData) {
            habits = decoded
        }
        
        if let completionsData = UserDefaults.standard.data(forKey: completionsKey),
           let decoded = try? JSONDecoder().decode([HabitCompletion].self, from: completionsData) {
            completions = decoded
        }
    }
}

// MARK: - Habit Views

struct HabitsView: View {
    @StateObject private var manager = HabitManager()
    @State private var showAddHabit = false
    @State private var selectedHabit: Habit?
    @State private var showArchived = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()
                
                ScrollView {
                    VStack(spacing: DesignSystem.spacing.lg) {
                        // Today's Progress
                        HabitProgressCard(manager: manager)
                        
                        // Due Today
                        if !manager.habitsDue().isEmpty {
                            HabitsDueSection(manager: manager, onSelect: { selectedHabit = $0 })
                        }
                        
                        // Completed Today
                        if !manager.habitsCompleted().isEmpty {
                            HabitsCompletedSection(manager: manager, onSelect: { selectedHabit = $0 })
                        }
                        
                        // All Habits
                        AllHabitsSection(manager: manager, onSelect: { selectedHabit = $0 })
                        
                        // Empty state
                        if manager.activeHabits.isEmpty {
                            HabitEmptyState(onAdd: { showAddHabit = true })
                        }
                        
                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddHabit = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(BrandTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitSheet(manager: manager)
            }
            .sheet(item: $selectedHabit) { habit in
                HabitDetailSheet(habit: habit, manager: manager)
            }
        }
    }
}

// MARK: - Habit Progress Card

struct HabitProgressCard: View {
    @ObservedObject var manager: HabitManager
    
    private var dueCount: Int { manager.habitsDue().count }
    private var completedCount: Int { manager.habitsCompleted().count }
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            HStack(spacing: DesignSystem.spacing.xl) {
                // Progress ring
                AnimatedProgressRing(
                    progress: manager.todayProgress,
                    lineWidth: 12,
                    showPercentage: true,
                    gradientColors: [BrandTheme.success, BrandTheme.success.opacity(0.7)]
                )
                .frame(width: 100, height: 100)
                
                // Stats
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    Text("Today's Habits")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    HStack(spacing: DesignSystem.spacing.lg) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(BrandTheme.success)
                            Text("\(completedCount)")
                                .font(DesignSystem.text.labelLarge)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "circle")
                                .foregroundColor(BrandTheme.warning)
                            Text("\(dueCount)")
                                .font(DesignSystem.text.labelLarge)
                        }
                    }
                    .foregroundColor(BrandTheme.textSecondary)
                    
                    if manager.todayProgress >= 1.0 && completedCount > 0 {
                        ChipView(text: "All done! 🎉", color: BrandTheme.success, size: .small)
                    }
                }
                
                Spacer()
            }
        }
        .elevatedCard(accentColor: BrandTheme.success)
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Habits Due Section

struct HabitsDueSection: View {
    @ObservedObject var manager: HabitManager
    let onSelect: (Habit) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Due Today")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("\(manager.habitsDue().count) remaining")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            ForEach(manager.habitsDue()) { habit in
                HabitRow(habit: habit, manager: manager, onTap: { onSelect(habit) })
            }
        }
        .brandCard()
    }
}

// MARK: - Habits Completed Section

struct HabitsCompletedSection: View {
    @ObservedObject var manager: HabitManager
    let onSelect: (Habit) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Completed")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                ChipView(text: "Done", icon: "checkmark", color: BrandTheme.success, size: .small)
            }
            
            ForEach(manager.habitsCompleted()) { habit in
                HabitRow(habit: habit, manager: manager, onTap: { onSelect(habit) })
            }
        }
        .brandCard()
    }
}

// MARK: - All Habits Section

struct AllHabitsSection: View {
    @ObservedObject var manager: HabitManager
    let onSelect: (Habit) -> Void
    @State private var isExpanded = false
    
    var body: some View {
        if !manager.activeHabits.isEmpty {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                Button {
                    withAnimation(DesignSystem.animation.smooth) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("All Habits")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(manager.activeHabits.count)")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(BrandTheme.mutedText)
                            .rotationEffect(.degrees(isExpanded ? -180 : 0))
                    }
                }
                .buttonStyle(.plain)
                
                if isExpanded {
                    ForEach(manager.activeHabits) { habit in
                        HabitRow(habit: habit, manager: manager, onTap: { onSelect(habit) })
                    }
                }
            }
            .brandCard()
        }
    }
}

// MARK: - Habit Row

struct HabitRow: View {
    let habit: Habit
    @ObservedObject var manager: HabitManager
    let onTap: () -> Void
    
    @State private var isAnimating = false
    
    private var isCompleted: Bool { manager.isCompleted(habit) }
    private var streak: Int { manager.currentStreak(for: habit) }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignSystem.spacing.md) {
                // Completion button
                Button {
                    toggleCompletion()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(isCompleted ? habit.color : BrandTheme.borderSubtle, lineWidth: 2)
                            .frame(width: 32, height: 32)
                        
                        if isCompleted {
                            Circle()
                                .fill(habit.color)
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .scaleEffect(isAnimating ? 1.2 : 1)
                }
                .buttonStyle(.plain)
                
                // Icon
                IconContainer(
                    systemName: habit.iconName,
                    color: habit.color,
                    size: .small,
                    style: isCompleted ? .gradient : .soft
                )
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(isCompleted ? BrandTheme.mutedText : BrandTheme.textPrimary)
                        .strikethrough(isCompleted)
                    
                    HStack(spacing: DesignSystem.spacing.sm) {
                        ChipView(text: habit.schedule.label, icon: habit.schedule.icon, color: BrandTheme.mutedText, size: .small)
                        
                        if streak > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(BrandTheme.error)
                                Text("\(streak)")
                            }
                            .font(.caption2)
                            .foregroundColor(BrandTheme.error)
                        }
                    }
                }
                
                Spacer()
                
                XPChip(xp: habit.xpReward, size: .small)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(BrandTheme.mutedText)
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(isCompleted ? habit.color.opacity(0.08) : BrandTheme.cardBackgroundElevated.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
    
    private func toggleCompletion() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
            isAnimating = true
        }
        
        if isCompleted {
            manager.uncompleteHabit(habit)
        } else {
            manager.completeHabit(habit)
            HapticsEngine.lightImpact()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.85)) {
                isAnimating = false
            }
        }
    }
}

// MARK: - Habit Empty State

struct HabitEmptyState: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            IconContainer(systemName: "repeat.circle", color: BrandTheme.mutedText, size: .hero, style: .soft)
            
            VStack(spacing: DesignSystem.spacing.sm) {
                Text("No habits yet")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text("Create your first habit to start building consistency")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAdd) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Habit")
                }
            }
            .buttonStyle(GlowButtonStyle(size: .medium))
        }
        .padding(DesignSystem.spacing.xxl)
    }
}

// MARK: - Add Habit Sheet

struct AddHabitSheet: View {
    @ObservedObject var manager: HabitManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedIcon = "checkmark.circle.fill"
    @State private var selectedColor = "6366F1"
    @State private var selectedDimension: LifeDimension = .mind
    @State private var selectedSchedule: HabitSchedule = .daily
    @State private var xpReward = 10
    
    let iconOptions = ["checkmark.circle.fill", "star.fill", "heart.fill", "brain.head.profile", "figure.walk", "book.fill", "drop.fill", "moon.fill", "sun.max.fill", "leaf.fill", "dumbbell.fill", "cup.and.saucer.fill"]
    let colorOptions = ["6366F1", "EC4899", "10B981", "F59E0B", "8B5CF6", "3B82F6", "EF4444", "14B8A6"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xl) {
                    // Name
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Habit Name")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        TextField("e.g., Drink 8 glasses of water", text: $name)
                            .textFieldStyle(.plain)
                            .font(DesignSystem.text.bodyLarge)
                            .padding(DesignSystem.spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                    .fill(BrandTheme.cardBackgroundElevated)
                            )
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Description (optional)")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        TextField("Why is this habit important?", text: $description, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(DesignSystem.text.bodyMedium)
                            .lineLimit(2...4)
                            .padding(DesignSystem.spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                    .fill(BrandTheme.cardBackgroundElevated)
                            )
                    }
                    
                    // Icon picker
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Icon")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: DesignSystem.spacing.sm) {
                            ForEach(iconOptions, id: \.self) { icon in
                                Button {
                                    selectedIcon = icon
                                } label: {
                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedIcon == icon ? .white : Color(hex: selectedColor, default: BrandTheme.accent))
                                        .frame(width: 44, height: 44)
                                        .background(
                                            Circle()
                                                .fill(selectedIcon == icon ? Color(hex: selectedColor, default: BrandTheme.accent) : Color(hex: selectedColor, default: BrandTheme.accent).opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                    
                    // Color picker
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Color")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        HStack(spacing: DesignSystem.spacing.md) {
                            ForEach(colorOptions, id: \.self) { color in
                                Button {
                                    selectedColor = color
                                } label: {
                                    Circle()
                                        .fill(Color(hex: color, default: .gray))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(.white, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                        .shadow(color: selectedColor == color ? Color(hex: color, default: .gray).opacity(0.5) : .clear, radius: 6)
                                }
                            }
                        }
                    }
                    
                    // Dimension
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Life Dimension")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        HStack(spacing: DesignSystem.spacing.sm) {
                            ForEach(LifeDimension.allCases) { dim in
                                Button {
                                    selectedDimension = dim
                                } label: {
                                    VStack(spacing: 4) {
                                        Image(systemName: dim.systemImage)
                                            .font(.system(size: 16))
                                        Text(dim.label)
                                            .font(.caption2)
                                    }
                                    .foregroundColor(selectedDimension == dim ? .white : BrandTheme.dimensionColor(dim))
                                    .padding(.horizontal, DesignSystem.spacing.md)
                                    .padding(.vertical, DesignSystem.spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                            .fill(selectedDimension == dim ? BrandTheme.dimensionColor(dim) : BrandTheme.dimensionColor(dim).opacity(0.1))
                                    )
                                }
                            }
                        }
                    }
                    
                    // Schedule
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Schedule")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        Picker("Schedule", selection: $selectedSchedule) {
                            ForEach(HabitSchedule.allCases) { schedule in
                                Text(schedule.label).tag(schedule)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // XP Reward
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        HStack {
                            Text("XP Reward")
                                .font(DesignSystem.text.labelMedium)
                                .foregroundColor(BrandTheme.textSecondary)
                            
                            Spacer()
                            
                            Text("\(xpReward) XP")
                                .font(DesignSystem.text.labelLarge)
                                .foregroundColor(BrandTheme.warning)
                        }
                        
                        Slider(value: Binding(
                            get: { Double(xpReward) },
                            set: { xpReward = Int($0) }
                        ), in: 5...50, step: 5)
                        .tint(BrandTheme.warning)
                    }
                }
                .padding(DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let habit = Habit(
                            name: name,
                            description: description,
                            iconName: selectedIcon,
                            colorHex: selectedColor,
                            dimension: selectedDimension,
                            schedule: selectedSchedule,
                            xpReward: xpReward
                        )
                        manager.addHabit(habit)
                        HapticsEngine.success()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Habit Detail Sheet

struct HabitDetailSheet: View {
    let habit: Habit
    @ObservedObject var manager: HabitManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showDeleteConfirm = false
    
    private var stats: HabitStats { manager.stats(for: habit) }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Header
                    VStack(spacing: DesignSystem.spacing.md) {
                        IconContainer(systemName: habit.iconName, color: habit.color, size: .hero, style: .gradient)
                        
                        Text(habit.name)
                            .font(DesignSystem.text.headlineLarge)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        if !habit.description.isEmpty {
                            Text(habit.description)
                                .font(DesignSystem.text.bodySmall)
                                .foregroundColor(BrandTheme.mutedText)
                                .multilineTextAlignment(.center)
                        }
                        
                        HStack(spacing: DesignSystem.spacing.md) {
                            ChipView(text: habit.schedule.label, icon: habit.schedule.icon, color: BrandTheme.mutedText, size: .medium)
                            ChipView(text: habit.dimension.label, icon: habit.dimension.systemImage, color: BrandTheme.dimensionColor(habit.dimension), size: .medium)
                        }
                    }
                    .padding(.top, DesignSystem.spacing.lg)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.spacing.md) {
                        HabitStatTile(title: "Current Streak", value: "\(stats.currentStreak)", icon: "flame.fill", color: BrandTheme.error)
                        HabitStatTile(title: "Best Streak", value: "\(stats.bestStreak)", icon: "trophy.fill", color: BrandTheme.warning)
                        HabitStatTile(title: "Total XP", value: "\(stats.totalXPEarned)", icon: "star.fill", color: BrandTheme.accent)
                        HabitStatTile(title: "Completion Rate", value: "\(Int(stats.completionRate * 100))%", icon: "chart.pie.fill", color: BrandTheme.success)
                    }
                    .brandCard()
                    
                    // This Week
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                        Text("This Week")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        HStack(spacing: DesignSystem.spacing.sm) {
                            ForEach(0..<7) { dayOffset in
                                WeekDayIndicator(
                                    habit: habit,
                                    manager: manager,
                                    dayOffset: dayOffset - 6
                                )
                            }
                        }
                    }
                    .brandCard()
                    
                    // Actions
                    VStack(spacing: DesignSystem.spacing.sm) {
                        Button {
                            manager.archiveHabit(habit)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "archivebox")
                                Text("Archive Habit")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SoftButtonStyle(color: BrandTheme.warning))
                        
                        Button {
                            showDeleteConfirm = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Habit")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SoftButtonStyle(color: BrandTheme.error))
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    
                    Color.clear.frame(height: DesignSystem.spacing.xxl)
                }
                .padding(.horizontal, DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog("Delete Habit?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    manager.deleteHabit(habit)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete this habit and all its history.")
            }
        }
    }
}

struct HabitStatTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}

struct WeekDayIndicator: View {
    let habit: Habit
    @ObservedObject var manager: HabitManager
    let dayOffset: Int
    
    private let calendar = Calendar.current
    
    private var date: Date {
        calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
    }
    
    private var isCompleted: Bool {
        manager.isCompleted(habit, for: date)
    }
    
    private var dayLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayLabel)
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
            
            ZStack {
                Circle()
                    .fill(isCompleted ? habit.color : BrandTheme.borderSubtle.opacity(0.5))
                    .frame(width: 32, height: 32)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .overlay(
                Circle()
                    .strokeBorder(isToday ? habit.color : Color.clear, lineWidth: 2)
            )
        }
        .frame(maxWidth: .infinity)
    }
}
