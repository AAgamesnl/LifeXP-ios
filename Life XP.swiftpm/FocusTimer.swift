import SwiftUI
import Foundation

// MARK: - Focus Timer System
// A Pomodoro-style focus timer with XP rewards and session tracking.

// MARK: - Focus Session Model

struct FocusSession: Identifiable, Codable {
    let id: String
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let type: SessionType
    let dimension: LifeDimension?
    let xpEarned: Int
    let wasCompleted: Bool
    let taskNote: String?
    
    enum SessionType: String, Codable {
        case focus
        case shortBreak
        case longBreak
    }
    
    init(
        startTime: Date,
        endTime: Date,
        duration: TimeInterval,
        type: SessionType,
        dimension: LifeDimension?,
        xpEarned: Int,
        wasCompleted: Bool,
        taskNote: String? = nil
    ) {
        self.id = UUID().uuidString
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.type = type
        self.dimension = dimension
        self.xpEarned = xpEarned
        self.wasCompleted = wasCompleted
        self.taskNote = taskNote
    }
}

/// Focus timer settings
struct FocusSettings: Codable {
    var focusDuration: Int = 25 // minutes
    var shortBreakDuration: Int = 5
    var longBreakDuration: Int = 15
    var sessionsUntilLongBreak: Int = 4
    var autoStartBreaks: Bool = false
    var autoStartFocus: Bool = false
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
}

// MARK: - Focus Timer State

enum FocusTimerState: Equatable {
    case idle
    case running(SessionType: FocusSession.SessionType)
    case paused(SessionType: FocusSession.SessionType)
    case completed(SessionType: FocusSession.SessionType)
    
    var isRunning: Bool {
        if case .running = self { return true }
        return false
    }
    
    var isPaused: Bool {
        if case .paused = self { return true }
        return false
    }
    
    var sessionType: FocusSession.SessionType? {
        switch self {
        case .idle: return nil
        case .running(let type), .paused(let type), .completed(let type):
            return type
        }
    }
}

// MARK: - Focus Timer Manager

@MainActor
final class FocusTimerManager: ObservableObject {
    @Published var state: FocusTimerState = .idle
    @Published var timeRemaining: TimeInterval = 0
    @Published var settings: FocusSettings = FocusSettings()
    @Published var sessions: [FocusSession] = []
    @Published var currentSessionCount: Int = 0
    @Published var selectedDimension: LifeDimension?
    @Published var taskNote: String = ""
    
    private var timer: Timer?
    private var sessionStartTime: Date?
    private let calendar = Calendar.current
    
    private let settingsKey = "lifeXP.focusSettings"
    private let sessionsKey = "lifeXP.focusSessions"
    
    init() {
        loadData()
    }
    
    // MARK: - Timer Control
    
    func startFocus() {
        sessionStartTime = Date()
        timeRemaining = TimeInterval(settings.focusDuration * 60)
        state = .running(SessionType: .focus)
        startTimer()
    }
    
    func startShortBreak() {
        sessionStartTime = Date()
        timeRemaining = TimeInterval(settings.shortBreakDuration * 60)
        state = .running(SessionType: .shortBreak)
        startTimer()
    }
    
    func startLongBreak() {
        sessionStartTime = Date()
        timeRemaining = TimeInterval(settings.longBreakDuration * 60)
        state = .running(SessionType: .longBreak)
        startTimer()
    }
    
    func pause() {
        guard case .running(let type) = state else { return }
        timer?.invalidate()
        timer = nil
        state = .paused(SessionType: type)
    }
    
    func resume() {
        guard case .paused(let type) = state else { return }
        state = .running(SessionType: type)
        startTimer()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        
        // Record incomplete session if it was a focus session
        if let startTime = sessionStartTime, case .running(let type) = state, type == .focus {
            let elapsed = Date().timeIntervalSince(startTime)
            if elapsed > 60 { // Only count if more than 1 minute
                let xp = calculateXP(duration: elapsed, wasCompleted: false)
                recordSession(type: type, duration: elapsed, wasCompleted: false, xpEarned: xp)
            }
        }
        
        state = .idle
        timeRemaining = 0
        sessionStartTime = nil
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        state = .idle
        timeRemaining = 0
        sessionStartTime = nil
        taskNote = ""
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }
    
    private func tick() {
        guard state.isRunning else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        timer?.invalidate()
        timer = nil
        
        guard let type = state.sessionType, let startTime = sessionStartTime else { return }
        
        let duration: TimeInterval
        switch type {
        case .focus:
            duration = TimeInterval(settings.focusDuration * 60)
            currentSessionCount += 1
            let xp = calculateXP(duration: duration, wasCompleted: true)
            recordSession(type: type, duration: duration, wasCompleted: true, xpEarned: xp)
        case .shortBreak:
            duration = TimeInterval(settings.shortBreakDuration * 60)
            recordSession(type: type, duration: duration, wasCompleted: true, xpEarned: 0)
        case .longBreak:
            duration = TimeInterval(settings.longBreakDuration * 60)
            currentSessionCount = 0
            recordSession(type: type, duration: duration, wasCompleted: true, xpEarned: 5)
        }
        
        state = .completed(SessionType: type)
        
        if settings.vibrationEnabled {
            HapticsEngine.success()
        }
        
        // Auto-start next session if enabled
        if type == .focus && settings.autoStartBreaks {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.startNextBreak()
            }
        }
    }
    
    private func startNextBreak() {
        if currentSessionCount >= settings.sessionsUntilLongBreak {
            startLongBreak()
        } else {
            startShortBreak()
        }
    }
    
    private func calculateXP(duration: TimeInterval, wasCompleted: Bool) -> Int {
        let minutes = Int(duration / 60)
        let baseXP = minutes / 5 * 5 // 5 XP per 5 minutes
        let completionBonus = wasCompleted ? 10 : 0
        return baseXP + completionBonus
    }
    
    private func recordSession(type: FocusSession.SessionType, duration: TimeInterval, wasCompleted: Bool, xpEarned: Int) {
        let session = FocusSession(
            startTime: sessionStartTime ?? Date(),
            endTime: Date(),
            duration: duration,
            type: type,
            dimension: selectedDimension,
            xpEarned: xpEarned,
            wasCompleted: wasCompleted,
            taskNote: taskNote.isEmpty ? nil : taskNote
        )
        sessions.insert(session, at: 0)
        saveSessions()
    }
    
    // MARK: - Statistics
    
    var todaysFocusTime: TimeInterval {
        let today = calendar.startOfDay(for: Date())
        return sessions
            .filter { $0.type == .focus && calendar.startOfDay(for: $0.startTime) == today }
            .reduce(0) { $0 + $1.duration }
    }
    
    var todaysXP: Int {
        let today = calendar.startOfDay(for: Date())
        return sessions
            .filter { calendar.startOfDay(for: $0.startTime) == today }
            .reduce(0) { $0 + $1.xpEarned }
    }
    
    var totalFocusTime: TimeInterval {
        sessions
            .filter { $0.type == .focus }
            .reduce(0) { $0 + $1.duration }
    }
    
    var totalXPEarned: Int {
        sessions.reduce(0) { $0 + $1.xpEarned }
    }
    
    var completedSessions: Int {
        sessions.filter { $0.wasCompleted && $0.type == .focus }.count
    }
    
    var thisWeekFocusTime: TimeInterval {
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return sessions
            .filter { $0.type == .focus && $0.startTime >= weekStart }
            .reduce(0) { $0 + $1.duration }
    }
    
    var averageSessionLength: TimeInterval {
        let focusSessions = sessions.filter { $0.type == .focus }
        guard !focusSessions.isEmpty else { return 0 }
        let total = focusSessions.reduce(0) { $0 + $1.duration }
        return total / Double(focusSessions.count)
    }
    
    // MARK: - Helpers
    
    var progress: Double {
        guard let type = state.sessionType else { return 0 }
        let total: TimeInterval
        switch type {
        case .focus:
            total = TimeInterval(settings.focusDuration * 60)
        case .shortBreak:
            total = TimeInterval(settings.shortBreakDuration * 60)
        case .longBreak:
            total = TimeInterval(settings.longBreakDuration * 60)
        }
        guard total > 0 else { return 0 }
        return 1 - (timeRemaining / total)
    }
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Persistence
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    private func saveSessions() {
        // Keep only last 100 sessions
        if sessions.count > 100 {
            sessions = Array(sessions.prefix(100))
        }
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func loadData() {
        if let settingsData = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(FocusSettings.self, from: settingsData) {
            settings = decoded
        }
        
        if let sessionsData = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([FocusSession].self, from: sessionsData) {
            sessions = decoded
        }
    }
}

// MARK: - Focus Timer Views

struct FocusTimerView: View {
    @StateObject private var manager = FocusTimerManager()
    @State private var showSettings = false
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()
                
                ScrollView {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        // Timer Display
                        FocusTimerDisplay(manager: manager)
                        
                        // Quick Stats
                        FocusQuickStats(manager: manager)
                        
                        // Task Note
                        FocusTaskInput(manager: manager)
                        
                        // Dimension Selector
                        FocusDimensionSelector(manager: manager)
                        
                        // Session Progress
                        SessionProgressIndicator(manager: manager)
                        
                        // Today's Sessions
                        TodaySessionsCard(manager: manager)
                        
                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
            }
            .navigationTitle("Focus Timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(BrandTheme.accent)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(BrandTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                FocusSettingsSheet(manager: manager)
            }
            .sheet(isPresented: $showHistory) {
                FocusHistorySheet(manager: manager)
            }
        }
    }
}

// MARK: - Timer Display

struct FocusTimerDisplay: View {
    @ObservedObject var manager: FocusTimerManager
    
    private var accentColor: Color {
        switch manager.state.sessionType {
        case .focus: return BrandTheme.error
        case .shortBreak, .longBreak: return BrandTheme.success
        case nil: return BrandTheme.accent
        }
    }
    
    private var statusText: String {
        switch manager.state {
        case .idle:
            return "Ready to focus"
        case .running(let type):
            switch type {
            case .focus: return "Focus time"
            case .shortBreak: return "Short break"
            case .longBreak: return "Long break"
            }
        case .paused:
            return "Paused"
        case .completed(let type):
            switch type {
            case .focus: return "Great work! 🎉"
            case .shortBreak, .longBreak: return "Break complete!"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xl) {
            // Timer Ring
            ZStack {
                // Background ring
                Circle()
                    .stroke(accentColor.opacity(0.2), lineWidth: 12)
                    .frame(width: 240, height: 240)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: manager.progress)
                    .stroke(
                        AngularGradient(
                            colors: [accentColor, accentColor.opacity(0.7)],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 240, height: 240)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: manager.progress)
                
                // Center content
                VStack(spacing: DesignSystem.spacing.sm) {
                    Text(manager.state == .idle ? "\(manager.settings.focusDuration):00" : manager.formattedTime)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(BrandTheme.textPrimary)
                        .contentTransition(.numericText())
                    
                    Text(statusText)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Control Buttons
            HStack(spacing: DesignSystem.spacing.lg) {
                switch manager.state {
                case .idle:
                    Button {
                        manager.startFocus()
                        HapticsEngine.lightImpact()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Focus")
                        }
                    }
                    .buttonStyle(GlowButtonStyle(color: BrandTheme.error, size: .large))
                    
                case .running:
                    Button {
                        manager.pause()
                    } label: {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(BrandTheme.warning))
                    }
                    
                    Button {
                        manager.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                            .foregroundColor(BrandTheme.error)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(BrandTheme.error.opacity(0.15)))
                    }
                    
                case .paused:
                    Button {
                        manager.resume()
                        HapticsEngine.lightImpact()
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(BrandTheme.success))
                    }
                    
                    Button {
                        manager.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                            .foregroundColor(BrandTheme.error)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(BrandTheme.error.opacity(0.15)))
                    }
                    
                case .completed(let type):
                    if type == .focus {
                        Button {
                            manager.startShortBreak()
                            HapticsEngine.lightImpact()
                        } label: {
                            HStack {
                                Image(systemName: "cup.and.saucer.fill")
                                Text("Take Break")
                            }
                        }
                        .buttonStyle(GlowButtonStyle(color: BrandTheme.success, size: .medium))
                    }
                    
                    Button {
                        manager.startFocus()
                        HapticsEngine.lightImpact()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text(type == .focus ? "Another" : "Focus")
                        }
                    }
                    .buttonStyle(GlowButtonStyle(color: BrandTheme.error, size: .medium))
                }
            }
        }
        .elevatedCard(accentColor: accentColor)
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Quick Stats

struct FocusQuickStats: View {
    @ObservedObject var manager: FocusTimerManager
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            FocusStatTile(
                icon: "clock.fill",
                value: formatDuration(manager.todaysFocusTime),
                label: "Today",
                color: BrandTheme.accent
            )
            
            FocusStatTile(
                icon: "star.fill",
                value: "\(manager.todaysXP)",
                label: "XP Today",
                color: BrandTheme.warning
            )
            
            FocusStatTile(
                icon: "checkmark.circle.fill",
                value: "\(manager.completedSessions)",
                label: "Sessions",
                color: BrandTheme.success
            )
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

struct FocusStatTile: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.text.labelLarge)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Task Input

struct FocusTaskInput: View {
    @ObservedObject var manager: FocusTimerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            Text("What are you working on?")
                .font(DesignSystem.text.labelMedium)
                .foregroundColor(BrandTheme.textSecondary)
            
            TextField("Optional task note...", text: $manager.taskNote)
                .textFieldStyle(.plain)
                .font(DesignSystem.text.bodyMedium)
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(BrandTheme.cardBackgroundElevated)
                )
                .disabled(manager.state.isRunning)
        }
        .brandCard()
    }
}

// MARK: - Dimension Selector

struct FocusDimensionSelector: View {
    @ObservedObject var manager: FocusTimerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            Text("Focus Dimension (optional)")
                .font(DesignSystem.text.labelMedium)
                .foregroundColor(BrandTheme.textSecondary)
            
            HStack(spacing: DesignSystem.spacing.sm) {
                ForEach(LifeDimension.allCases) { dim in
                    Button {
                        if manager.selectedDimension == dim {
                            manager.selectedDimension = nil
                        } else {
                            manager.selectedDimension = dim
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: dim.systemImage)
                                .font(.system(size: 16))
                            Text(dim.label)
                                .font(.caption2)
                        }
                        .foregroundColor(manager.selectedDimension == dim ? .white : BrandTheme.dimensionColor(dim))
                        .padding(.horizontal, DesignSystem.spacing.md)
                        .padding(.vertical, DesignSystem.spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                .fill(manager.selectedDimension == dim ? BrandTheme.dimensionColor(dim) : BrandTheme.dimensionColor(dim).opacity(0.1))
                        )
                    }
                    .disabled(manager.state.isRunning)
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Session Progress Indicator

struct SessionProgressIndicator: View {
    @ObservedObject var manager: FocusTimerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            HStack {
                Text("Session Progress")
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textSecondary)
                
                Spacer()
                
                Text("\(manager.currentSessionCount)/\(manager.settings.sessionsUntilLongBreak)")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            HStack(spacing: DesignSystem.spacing.sm) {
                ForEach(0..<manager.settings.sessionsUntilLongBreak, id: \.self) { index in
                    Circle()
                        .fill(index < manager.currentSessionCount ? BrandTheme.success : BrandTheme.borderSubtle)
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
                
                if manager.currentSessionCount >= manager.settings.sessionsUntilLongBreak {
                    ChipView(text: "Long break earned!", icon: "star.fill", color: BrandTheme.warning, size: .small)
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Today's Sessions Card

struct TodaySessionsCard: View {
    @ObservedObject var manager: FocusTimerManager
    
    private let calendar = Calendar.current
    
    private var todaySessions: [FocusSession] {
        let today = calendar.startOfDay(for: Date())
        return manager.sessions.filter { calendar.startOfDay(for: $0.startTime) == today }
    }
    
    var body: some View {
        if !todaySessions.isEmpty {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                HStack {
                    Text("Today's Sessions")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(todaySessions.count) sessions")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                ForEach(todaySessions.prefix(5)) { session in
                    SessionRow(session: session)
                }
            }
            .brandCard()
        }
    }
}

struct SessionRow: View {
    let session: FocusSession
    
    private var color: Color {
        switch session.type {
        case .focus: return BrandTheme.error
        case .shortBreak: return BrandTheme.success
        case .longBreak: return BrandTheme.info
        }
    }
    
    private var icon: String {
        switch session.type {
        case .focus: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "moon.fill"
        }
    }
    
    private var label: String {
        switch session.type {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(label)
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if !session.wasCompleted {
                        Text("(partial)")
                            .font(.caption2)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
                
                if let note = session.taskNote {
                    Text(note)
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatDuration(session.duration))
                    .font(.caption)
                    .foregroundColor(BrandTheme.textSecondary)
                
                if session.xpEarned > 0 {
                    Text("+\(session.xpEarned) XP")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.warning)
                }
            }
        }
        .padding(DesignSystem.spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                .fill(color.opacity(0.08))
        )
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

// MARK: - Settings Sheet

struct FocusSettingsSheet: View {
    @ObservedObject var manager: FocusTimerManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.xl) {
                    // Timer Durations
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                        Text("Timer Durations")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        DurationSetting(
                            title: "Focus Duration",
                            value: $manager.settings.focusDuration,
                            range: 5...60,
                            step: 5,
                            unit: "min",
                            color: BrandTheme.error
                        )
                        
                        DurationSetting(
                            title: "Short Break",
                            value: $manager.settings.shortBreakDuration,
                            range: 1...15,
                            step: 1,
                            unit: "min",
                            color: BrandTheme.success
                        )
                        
                        DurationSetting(
                            title: "Long Break",
                            value: $manager.settings.longBreakDuration,
                            range: 10...30,
                            step: 5,
                            unit: "min",
                            color: BrandTheme.info
                        )
                        
                        DurationSetting(
                            title: "Sessions until Long Break",
                            value: $manager.settings.sessionsUntilLongBreak,
                            range: 2...8,
                            step: 1,
                            unit: "",
                            color: BrandTheme.warning
                        )
                    }
                    .brandCard()
                    
                    // Behavior
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                        Text("Behavior")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Toggle(isOn: $manager.settings.autoStartBreaks) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Auto-start Breaks")
                                    .font(DesignSystem.text.labelMedium)
                                    .foregroundColor(BrandTheme.textPrimary)
                                Text("Automatically start break after focus")
                                    .font(.caption)
                                    .foregroundColor(BrandTheme.mutedText)
                            }
                        }
                        .tint(BrandTheme.accent)
                        
                        Toggle(isOn: $manager.settings.soundEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sound Effects")
                                    .font(DesignSystem.text.labelMedium)
                                    .foregroundColor(BrandTheme.textPrimary)
                                Text("Play sound when timer ends")
                                    .font(.caption)
                                    .foregroundColor(BrandTheme.mutedText)
                            }
                        }
                        .tint(BrandTheme.accent)
                        
                        Toggle(isOn: $manager.settings.vibrationEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Haptic Feedback")
                                    .font(DesignSystem.text.labelMedium)
                                    .foregroundColor(BrandTheme.textPrimary)
                                Text("Vibrate when timer ends")
                                    .font(.caption)
                                    .foregroundColor(BrandTheme.mutedText)
                            }
                        }
                        .tint(BrandTheme.accent)
                    }
                    .brandCard()
                }
                .padding(DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Timer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        manager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DurationSetting: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            HStack {
                Text(title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("\(value)\(unit.isEmpty ? "" : " \(unit)")")
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(color)
            }
            
            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { value = Int($0) }
                ),
                in: Double(range.lowerBound)...Double(range.upperBound),
                step: Double(step)
            )
            .tint(color)
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.08))
        )
    }
}

// MARK: - History Sheet

struct FocusHistorySheet: View {
    @ObservedObject var manager: FocusTimerManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Lifetime Stats
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                        Text("Lifetime Stats")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.spacing.md) {
                            HistoryStatTile(title: "Total Focus Time", value: formatDuration(manager.totalFocusTime), icon: "clock.fill", color: BrandTheme.accent)
                            HistoryStatTile(title: "Total XP Earned", value: "\(manager.totalXPEarned)", icon: "star.fill", color: BrandTheme.warning)
                            HistoryStatTile(title: "Sessions Completed", value: "\(manager.completedSessions)", icon: "checkmark.circle.fill", color: BrandTheme.success)
                            HistoryStatTile(title: "Avg Session", value: formatDuration(manager.averageSessionLength), icon: "chart.bar.fill", color: BrandTheme.info)
                        }
                    }
                    .brandCard()
                    
                    // Recent Sessions
                    if !manager.sessions.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                            Text("Recent Sessions")
                                .font(DesignSystem.text.headlineMedium)
                                .foregroundColor(BrandTheme.textPrimary)
                            
                            ForEach(manager.sessions.prefix(20)) { session in
                                SessionRow(session: session)
                            }
                        }
                        .brandCard()
                    }
                }
                .padding(DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Focus History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

struct HistoryStatTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}
