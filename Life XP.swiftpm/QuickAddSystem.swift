import SwiftUI
import Foundation

// MARK: - Quick Add System
// Rapid task completion and item management for power users

// MARK: - Models

/// Quick action type
enum QuickActionType: String, CaseIterable, Identifiable {
    case completeItem
    case logMood
    case startFocus
    case addHabit
    case journal
    case checkIn
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .completeItem: return "Complete Item"
        case .logMood: return "Log Mood"
        case .startFocus: return "Start Focus"
        case .addHabit: return "Log Habit"
        case .journal: return "Quick Journal"
        case .checkIn: return "Daily Check-in"
        }
    }
    
    var iconSystemName: String {
        switch self {
        case .completeItem: return "checkmark.circle.fill"
        case .logMood: return "face.smiling.fill"
        case .startFocus: return "timer"
        case .addHabit: return "repeat.circle.fill"
        case .journal: return "book.fill"
        case .checkIn: return "hand.wave.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .completeItem: return .green
        case .logMood: return .yellow
        case .startFocus: return .blue
        case .addHabit: return .purple
        case .journal: return .orange
        case .checkIn: return .pink
        }
    }
}

/// Suggested item for quick completion
struct QuickSuggestion: Identifiable {
    let id: String
    let item: ChecklistItem
    let reason: SuggestionReason
    let priority: Int
    
    enum SuggestionReason: String {
        case streak = "Keep your streak!"
        case dimension = "Balance your dimensions"
        case lowXP = "Quick win"
        case almostComplete = "Almost there"
        case random = "Try something new"
        case overdue = "Overdue"
        case recentlyStarted = "Continue progress"
    }
}

// MARK: - Quick Add Manager

/// Manages quick add suggestions and actions
@MainActor
final class QuickAddManager: ObservableObject {
    @Published var suggestions: [QuickSuggestion] = []
    @Published var recentActions: [RecentAction] = []
    @Published var showingQuickAdd = false
    
    private let calendar = Calendar.current
    private let recentActionsKey = "lifeXP.recentActions"
    
    struct RecentAction: Identifiable, Codable {
        let id: UUID
        let actionType: String
        let itemID: String?
        let timestamp: Date
        let xpEarned: Int
    }
    
    init() {
        loadRecentActions()
    }
    
    func generateSuggestions(appModel: AppModel) {
        var newSuggestions: [QuickSuggestion] = []
        let completedIDs = appModel.completedItemIDs
        let allItems = appModel.allVisibleItems.filter { !completedIDs.contains($0.id) }
        
        // 1. Dimension balance suggestions
        let dimensionCounts = calculateDimensionProgress(appModel: appModel)
        if let weakestDimension = dimensionCounts.min(by: { $0.value < $1.value })?.key {
            let dimensionItems = allItems.filter { $0.dimensions.contains(weakestDimension) }
            if let item = dimensionItems.randomElement() {
                newSuggestions.append(QuickSuggestion(
                    id: item.id,
                    item: item,
                    reason: .dimension,
                    priority: 2
                ))
            }
        }
        
        // 2. Low XP quick wins
        let quickWins = allItems.filter { $0.xp <= 15 }.prefix(3)
        for item in quickWins {
            if !newSuggestions.contains(where: { $0.id == item.id }) {
                newSuggestions.append(QuickSuggestion(
                    id: item.id,
                    item: item,
                    reason: .lowXP,
                    priority: 3
                ))
            }
        }
        
        // 3. Random discovery
        if let randomItem = allItems.randomElement() {
            if !newSuggestions.contains(where: { $0.id == randomItem.id }) {
                newSuggestions.append(QuickSuggestion(
                    id: randomItem.id,
                    item: randomItem,
                    reason: .random,
                    priority: 5
                ))
            }
        }
        
        // 4. Streak maintenance
        if appModel.currentStreak > 0 && !appModel.hasDoneActivityToday {
            if let item = allItems.first {
                if !newSuggestions.contains(where: { $0.id == item.id }) {
                    newSuggestions.append(QuickSuggestion(
                        id: item.id,
                        item: item,
                        reason: .streak,
                        priority: 1
                    ))
                }
            }
        }
        
        // Sort by priority
        suggestions = newSuggestions.sorted { $0.priority < $1.priority }.prefix(5).map { $0 }
    }
    
    private func calculateDimensionProgress(appModel: AppModel) -> [LifeDimension: Double] {
        var progress: [LifeDimension: Double] = [:]
        
        for dimension in LifeDimension.allCases {
            let items = appModel.allVisibleItems.filter { $0.dimensions.contains(dimension) }
            let completed = items.filter { appModel.completedItemIDs.contains($0.id) }.count
            progress[dimension] = items.isEmpty ? 0 : Double(completed) / Double(items.count)
        }
        
        return progress
    }
    
    func recordAction(type: QuickActionType, itemID: String?, xp: Int) {
        let action = RecentAction(
            id: UUID(),
            actionType: type.rawValue,
            itemID: itemID,
            timestamp: Date(),
            xpEarned: xp
        )
        recentActions.insert(action, at: 0)
        recentActions = Array(recentActions.prefix(20))
        saveRecentActions()
    }
    
    private func loadRecentActions() {
        if let data = UserDefaults.standard.data(forKey: recentActionsKey),
           let decoded = try? JSONDecoder().decode([RecentAction].self, from: data) {
            recentActions = decoded
        }
    }
    
    private func saveRecentActions() {
        if let data = try? JSONEncoder().encode(recentActions) {
            UserDefaults.standard.set(data, forKey: recentActionsKey)
        }
    }
}

// MARK: - Views

/// Quick Add Floating Button
struct QuickAddButton: View {
    @Binding var showingQuickAdd: Bool
    
    @State private var isPressed = false
    @State private var rotation: Double = 0
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingQuickAdd = true
            }
            HapticsEngine.lightImpact()
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [BrandTheme.accent, BrandTheme.accent.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: BrandTheme.accent.opacity(0.4), radius: 10, y: 5)
                
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .buttonStyle(QuickAddButtonStyle())
        .scaleEffect(isPressed ? 0.9 : 1.0)
    }
}

struct QuickAddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

/// Quick Add Modal Sheet
struct QuickAddSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var appModel
    @StateObject private var manager = QuickAddManager()
    
    @State private var selectedAction: QuickActionType?
    @State private var searchText = ""
    @State private var showingItemPicker = false
    
    var filteredSuggestions: [QuickSuggestion] {
        if searchText.isEmpty {
            return manager.suggestions
        }
        return manager.suggestions.filter { 
            $0.item.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Quick actions grid
                    QuickActionsGrid(selectedAction: $selectedAction, onAction: handleQuickAction)
                    
                    Divider()
                    
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search items...", text: $searchText)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    
                    // Suggestions
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("Suggested for You")
                            .font(.headline)
                        
                        if filteredSuggestions.isEmpty {
                            Text("No suggestions available")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                        } else {
                            ForEach(filteredSuggestions) { suggestion in
                                QuickSuggestionRow(suggestion: suggestion) {
                                    completeItem(suggestion.item)
                                }
                            }
                        }
                    }
                    
                    // Recent activity
                    if !manager.recentActions.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Recent Activity")
                                .font(.headline)
                            
                            ForEach(manager.recentActions.prefix(5)) { action in
                                RecentActionRow(action: action)
                            }
                        }
                    }
                    
                    // Browse all
                    Button {
                        showingItemPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Browse All Items")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Quick Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingItemPicker) {
                ItemPickerSheet { item in
                    completeItem(item)
                    showingItemPicker = false
                }
            }
            .onAppear {
                manager.generateSuggestions(appModel: appModel)
            }
        }
    }
    
    private func handleQuickAction(_ action: QuickActionType) {
        selectedAction = action
        
        switch action {
        case .completeItem:
            showingItemPicker = true
        case .logMood:
            // Would navigate to mood logging
            manager.recordAction(type: action, itemID: nil, xp: 5)
            HapticsEngine.success()
        case .startFocus:
            // Would start focus timer
            manager.recordAction(type: action, itemID: nil, xp: 0)
            HapticsEngine.lightImpact()
        case .addHabit:
            // Would open habit logging
            manager.recordAction(type: action, itemID: nil, xp: 5)
            HapticsEngine.success()
        case .journal:
            // Would open quick journal
            manager.recordAction(type: action, itemID: nil, xp: 10)
            HapticsEngine.success()
        case .checkIn:
            // Daily check-in
            manager.recordAction(type: action, itemID: nil, xp: 5)
            HapticsEngine.success()
        }
    }
    
    private func completeItem(_ item: ChecklistItem) {
        appModel.toggleItem(item)
        manager.recordAction(type: .completeItem, itemID: item.id, xp: item.xp)
        manager.generateSuggestions(appModel: appModel)
        HapticsEngine.success()
    }
}

// MARK: - Quick Actions Grid

struct QuickActionsGrid: View {
    @Binding var selectedAction: QuickActionType?
    let onAction: (QuickActionType) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(QuickActionType.allCases) { action in
                QuickActionButton(action: action, isSelected: selectedAction == action) {
                    onAction(action)
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let action: QuickActionType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(action.color.opacity(isSelected ? 0.3 : 0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: action.iconSystemName)
                        .font(.title2)
                        .foregroundStyle(action.color)
                }
                
                Text(action.label)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? action.color.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Suggestion Row

struct QuickSuggestionRow: View {
    let suggestion: QuickSuggestion
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Dimension indicator
            if let dimension = suggestion.item.dimensions.first {
                Circle()
                    .fill(Color(hex: dimension.accentColorHex))
                    .frame(width: 8, height: 8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion.item.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(suggestion.reason.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.tertiary)
                    
                    Text("+\(suggestion.item.xp) XP")
                        .font(.caption.bold())
                        .foregroundStyle(.yellow)
                }
            }
            
            Spacer()
            
            Button(action: onComplete) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
    }
}

// MARK: - Recent Action Row

struct RecentActionRow: View {
    let action: QuickAddManager.RecentAction
    
    var actionType: QuickActionType? {
        QuickActionType(rawValue: action.actionType)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let type = actionType {
                Image(systemName: type.iconSystemName)
                    .foregroundStyle(type.color)
                    .frame(width: 24)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(actionType?.label ?? action.actionType)
                    .font(.subheadline)
                
                Text(action.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if action.xpEarned > 0 {
                Text("+\(action.xpEarned) XP")
                    .font(.caption.bold())
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Item Picker Sheet

struct ItemPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var appModel
    
    let onSelect: (ChecklistItem) -> Void
    
    @State private var searchText = ""
    @State private var selectedDimension: LifeDimension?
    
    var filteredItems: [ChecklistItem] {
        var items = appModel.allVisibleItems.filter { !appModel.completedItemIDs.contains($0.id) }
        
        if let dimension = selectedDimension {
            items = items.filter { $0.dimensions.contains(dimension) }
        }
        
        if !searchText.isEmpty {
            items = items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return items
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search items...", text: $searchText)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                .padding()
                
                // Dimension filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        DimensionFilterPill(dimension: nil, isSelected: selectedDimension == nil) {
                            selectedDimension = nil
                        }
                        
                        ForEach(LifeDimension.allCases) { dimension in
                            DimensionFilterPill(dimension: dimension, isSelected: selectedDimension == dimension) {
                                selectedDimension = dimension
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.top)
                
                // Items list
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("All items completed!")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            Button {
                                onSelect(item)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.subheadline)
                                        
                                        HStack(spacing: 4) {
                                            ForEach(item.dimensions) { dim in
                                                Circle()
                                                    .fill(Color(hex: dim.accentColorHex))
                                                    .frame(width: 6, height: 6)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text("+\(item.xp) XP")
                                        .font(.caption.bold())
                                        .foregroundStyle(.yellow)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Select Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DimensionFilterPill: View {
    let dimension: LifeDimension?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let dim = dimension {
                    Image(systemName: dim.iconSystemName)
                        .font(.caption)
                    Text(dim.label)
                } else {
                    Text("All")
                }
            }
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? (dimension.map { Color(hex: $0.accentColorHex) } ?? BrandTheme.accent).opacity(0.2) : Color.secondary.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Spotlight Search Style Input

struct SpotlightSearchView: View {
    @Environment(AppModel.self) private var appModel
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var selectedIndex = 0
    
    var results: [ChecklistItem] {
        guard !searchText.isEmpty else { return [] }
        return appModel.allVisibleItems
            .filter { !appModel.completedItemIDs.contains($0.id) }
            .filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            .prefix(10)
            .map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search input
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                TextField("Quick complete...", text: $searchText)
                    .font(.title3)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.lg))
            
            // Results
            if !results.isEmpty {
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(Array(results.enumerated()), id: \.element.id) { index, item in
                            SpotlightResultRow(
                                item: item,
                                isHighlighted: index == selectedIndex
                            ) {
                                appModel.toggleItem(item)
                                HapticsEngine.success()
                                isPresented = false
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .frame(maxHeight: 400)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.xl))
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        .padding(.horizontal, 20)
    }
}

struct SpotlightResultRow: View {
    let item: ChecklistItem
    let isHighlighted: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Dimension dots
                HStack(spacing: 2) {
                    ForEach(item.dimensions) { dim in
                        Circle()
                            .fill(Color(hex: dim.accentColorHex))
                            .frame(width: 6, height: 6)
                    }
                }
                .frame(width: 20)
                
                Text(item.title)
                    .font(.body)
                
                Spacer()
                
                Text("+\(item.xp) XP")
                    .font(.caption.bold())
                    .foregroundStyle(.yellow)
                
                Image(systemName: "return")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isHighlighted ? BrandTheme.accent.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.sm))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
struct QuickAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        QuickAddSheet()
            .environmentObject(AppModel())
    }
}
#endif
