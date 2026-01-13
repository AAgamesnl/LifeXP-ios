import SwiftUI
import Foundation

// MARK: - Daily Journal System with Mood Correlation
// A comprehensive journaling feature that tracks mood, provides prompts,
// and correlates emotional states with life activities and dimensions.

// MARK: - Models

/// Represents a mood state with intensity
struct MoodEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let mood: MoodType
    let intensity: Double // 0.0 to 1.0
    let timestamp: Date
    let note: String?
    let triggers: [MoodTrigger]
    let activities: [String] // IDs of completed items around this time
    
    init(id: UUID = UUID(), mood: MoodType, intensity: Double = 0.5, timestamp: Date = Date(), note: String? = nil, triggers: [MoodTrigger] = [], activities: [String] = []) {
        self.id = id
        self.mood = mood
        self.intensity = min(1.0, max(0.0, intensity))
        self.timestamp = timestamp
        self.note = note
        self.triggers = triggers
        self.activities = activities
    }
}

/// Available mood types
enum MoodType: String, Codable, CaseIterable, Identifiable {
    case joyful = "joyful"
    case happy = "happy"
    case content = "content"
    case neutral = "neutral"
    case anxious = "anxious"
    case sad = "sad"
    case frustrated = "frustrated"
    case energized = "energized"
    case tired = "tired"
    case grateful = "grateful"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .joyful: return "Joyful"
        case .happy: return "Happy"
        case .content: return "Content"
        case .neutral: return "Neutral"
        case .anxious: return "Anxious"
        case .sad: return "Sad"
        case .frustrated: return "Frustrated"
        case .energized: return "Energized"
        case .tired: return "Tired"
        case .grateful: return "Grateful"
        }
    }
    
    var emoji: String {
        switch self {
        case .joyful: return "😄"
        case .happy: return "😊"
        case .content: return "🙂"
        case .neutral: return "😐"
        case .anxious: return "😰"
        case .sad: return "😢"
        case .frustrated: return "😤"
        case .energized: return "⚡️"
        case .tired: return "😴"
        case .grateful: return "🙏"
        }
    }
    
    var iconSystemName: String {
        switch self {
        case .joyful: return "sun.max.fill"
        case .happy: return "face.smiling.fill"
        case .content: return "leaf.fill"
        case .neutral: return "circle.fill"
        case .anxious: return "bolt.fill"
        case .sad: return "cloud.rain.fill"
        case .frustrated: return "flame.fill"
        case .energized: return "battery.100.bolt"
        case .tired: return "moon.zzz.fill"
        case .grateful: return "heart.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .joyful: return .yellow
        case .happy: return .orange
        case .content: return .green
        case .neutral: return .gray
        case .anxious: return .purple
        case .sad: return .blue
        case .frustrated: return .red
        case .energized: return .mint
        case .tired: return .indigo
        case .grateful: return .pink
        }
    }
    
    var positivity: Double {
        switch self {
        case .joyful: return 1.0
        case .happy: return 0.8
        case .content: return 0.7
        case .neutral: return 0.5
        case .anxious: return 0.3
        case .sad: return 0.2
        case .frustrated: return 0.25
        case .energized: return 0.85
        case .tired: return 0.35
        case .grateful: return 0.9
        }
    }
    
    static var positive: [MoodType] {
        [.joyful, .happy, .content, .energized, .grateful]
    }
    
    static var negative: [MoodType] {
        [.anxious, .sad, .frustrated, .tired]
    }
}

/// Triggers that may affect mood
enum MoodTrigger: String, Codable, CaseIterable, Identifiable {
    case work = "work"
    case relationships = "relationships"
    case health = "health"
    case finance = "finance"
    case sleep = "sleep"
    case exercise = "exercise"
    case social = "social"
    case alone = "alone"
    case weather = "weather"
    case achievement = "achievement"
    case failure = "failure"
    case news = "news"
    case family = "family"
    case creative = "creative"
    case nature = "nature"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .work: return "Work"
        case .relationships: return "Relationships"
        case .health: return "Health"
        case .finance: return "Finance"
        case .sleep: return "Sleep"
        case .exercise: return "Exercise"
        case .social: return "Social"
        case .alone: return "Alone Time"
        case .weather: return "Weather"
        case .achievement: return "Achievement"
        case .failure: return "Setback"
        case .news: return "News"
        case .family: return "Family"
        case .creative: return "Creativity"
        case .nature: return "Nature"
        }
    }
    
    var iconSystemName: String {
        switch self {
        case .work: return "briefcase.fill"
        case .relationships: return "heart.fill"
        case .health: return "heart.text.square.fill"
        case .finance: return "dollarsign.circle.fill"
        case .sleep: return "bed.double.fill"
        case .exercise: return "figure.run"
        case .social: return "person.3.fill"
        case .alone: return "person.fill"
        case .weather: return "cloud.sun.fill"
        case .achievement: return "trophy.fill"
        case .failure: return "exclamationmark.triangle.fill"
        case .news: return "newspaper.fill"
        case .family: return "house.fill"
        case .creative: return "paintbrush.fill"
        case .nature: return "leaf.fill"
        }
    }
    
    var dimension: LifeDimension? {
        switch self {
        case .relationships, .social, .family: return .love
        case .finance, .work: return .money
        case .health, .sleep, .exercise, .creative: return .mind
        case .achievement, .failure, .nature: return .adventure
        default: return nil
        }
    }
}

/// A journal entry with mood and reflections
struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var moodEntry: MoodEntry
    var gratitudeItems: [String]
    var highlights: [String]
    var challenges: [String]
    var freeformText: String
    var tags: [String]
    var linkedDimensions: [LifeDimension]
    var xpEarned: Int
    var wordCount: Int
    var promptUsed: String?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        moodEntry: MoodEntry,
        gratitudeItems: [String] = [],
        highlights: [String] = [],
        challenges: [String] = [],
        freeformText: String = "",
        tags: [String] = [],
        linkedDimensions: [LifeDimension] = [],
        xpEarned: Int = 0,
        promptUsed: String? = nil
    ) {
        self.id = id
        self.date = date
        self.moodEntry = moodEntry
        self.gratitudeItems = gratitudeItems
        self.highlights = highlights
        self.challenges = challenges
        self.freeformText = freeformText
        self.tags = tags
        self.linkedDimensions = linkedDimensions
        self.xpEarned = xpEarned
        self.wordCount = freeformText.split(separator: " ").count + 
                        gratitudeItems.joined(separator: " ").split(separator: " ").count +
                        highlights.joined(separator: " ").split(separator: " ").count +
                        challenges.joined(separator: " ").split(separator: " ").count
        self.promptUsed = promptUsed
    }
}

/// Statistics for journal analysis
struct JournalStats: Codable {
    var totalEntries: Int
    var currentStreak: Int
    var longestStreak: Int
    var averageMoodScore: Double
    var mostCommonMood: MoodType
    var mostCommonTriggers: [MoodTrigger]
    var totalWordsWritten: Int
    var totalXPEarned: Int
    var moodByDimension: [LifeDimension: Double]
    var moodTrend: MoodTrend
    
    enum MoodTrend: String, Codable {
        case improving, declining, stable, insufficient
    }
}

/// Daily reflection prompt
struct ReflectionPrompt: Identifiable {
    let id: String
    let category: PromptCategory
    let text: String
    let followUp: String?
    let suggestedDuration: Int // minutes
    
    enum PromptCategory: String, CaseIterable {
        case gratitude
        case growth
        case challenge
        case relationship
        case dream
        case mindfulness
        case values
        case achievement
    }
}

// MARK: - Journal Manager

/// Manages journal entries, mood tracking, and analysis
@MainActor
final class JournalManager: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var moodHistory: [MoodEntry] = []
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var todaysEntry: JournalEntry?
    @Published var selectedPrompt: ReflectionPrompt?
    @Published var moodInsights: [MoodInsight] = []
    
    private let entriesKey = "lifeXP.journalEntries"
    private let moodKey = "lifeXP.moodHistory"
    private let streakKey = "lifeXP.journalStreak"
    private let longestStreakKey = "lifeXP.journalLongestStreak"
    private let lastEntryDateKey = "lifeXP.lastJournalDate"
    
    private let calendar = Calendar.current
    
    init() {
        loadData()
        checkStreak()
        generateInsights()
    }
    
    // MARK: - CRUD Operations
    
    func saveEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: entry.date) }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        
        // Update mood history
        if !moodHistory.contains(where: { $0.id == entry.moodEntry.id }) {
            moodHistory.append(entry.moodEntry)
        }
        
        // Update streak
        updateStreak(for: entry.date)
        
        // Refresh today's entry
        updateTodaysEntry()
        
        // Save to persistence
        persistData()
        
        // Regenerate insights
        generateInsights()
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        moodHistory.removeAll { $0.id == entry.moodEntry.id }
        updateTodaysEntry()
        persistData()
        generateInsights()
    }
    
    func logQuickMood(_ mood: MoodType, intensity: Double, note: String? = nil, triggers: [MoodTrigger] = []) {
        let moodEntry = MoodEntry(
            mood: mood,
            intensity: intensity,
            note: note,
            triggers: triggers
        )
        moodHistory.append(moodEntry)
        persistData()
        generateInsights()
    }
    
    // MARK: - Analysis
    
    func moodAverageForPeriod(days: Int) -> Double {
        let cutoff = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let relevantMoods = moodHistory.filter { $0.timestamp >= cutoff }
        
        guard !relevantMoods.isEmpty else { return 0.5 }
        
        let total = relevantMoods.reduce(0.0) { $0 + ($1.mood.positivity * $1.intensity) }
        return total / Double(relevantMoods.count)
    }
    
    func moodCountByType(days: Int) -> [MoodType: Int] {
        let cutoff = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let relevantMoods = moodHistory.filter { $0.timestamp >= cutoff }
        
        var counts: [MoodType: Int] = [:]
        for mood in relevantMoods {
            counts[mood.mood, default: 0] += 1
        }
        return counts
    }
    
    func triggerCorrelation() -> [(MoodTrigger, Double)] {
        var triggerPositivity: [MoodTrigger: (total: Double, count: Int)] = [:]
        
        for mood in moodHistory {
            let positivity = mood.mood.positivity * mood.intensity
            for trigger in mood.triggers {
                let current = triggerPositivity[trigger] ?? (0, 0)
                triggerPositivity[trigger] = (current.total + positivity, current.count + 1)
            }
        }
        
        return triggerPositivity.map { trigger, data in
            (trigger, data.total / Double(max(1, data.count)))
        }.sorted { $0.1 > $1.1 }
    }
    
    func moodByDimension() -> [LifeDimension: Double] {
        var dimensionMoods: [LifeDimension: (total: Double, count: Int)] = [:]
        
        for entry in entries {
            let positivity = entry.moodEntry.mood.positivity * entry.moodEntry.intensity
            for dimension in entry.linkedDimensions {
                let current = dimensionMoods[dimension] ?? (0, 0)
                dimensionMoods[dimension] = (current.total + positivity, current.count + 1)
            }
        }
        
        var result: [LifeDimension: Double] = [:]
        for (dimension, data) in dimensionMoods {
            result[dimension] = data.total / Double(max(1, data.count))
        }
        return result
    }
    
    func wordCountTrend(days: Int) -> [Date: Int] {
        let cutoff = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        var trend: [Date: Int] = [:]
        
        for entry in entries where entry.date >= cutoff {
            let day = calendar.startOfDay(for: entry.date)
            trend[day] = entry.wordCount
        }
        
        return trend
    }
    
    func getMoodTrend(days: Int = 14) -> JournalStats.MoodTrend {
        guard moodHistory.count >= 5 else { return .insufficient }
        
        let halfPoint = max(1, days / 2)
        
        // Get moods from recent half and older half
        let now = Date()
        let recentCutoff = calendar.date(byAdding: .day, value: -halfPoint, to: now) ?? now
        let olderCutoff = calendar.date(byAdding: .day, value: -days, to: now) ?? now
        
        let recentMoods = moodHistory.filter { $0.timestamp >= recentCutoff }
        let olderMoods = moodHistory.filter { $0.timestamp >= olderCutoff && $0.timestamp < recentCutoff }
        
        guard !recentMoods.isEmpty && !olderMoods.isEmpty else { return .insufficient }
        
        let recentAvg = recentMoods.reduce(0.0) { $0 + ($1.mood.positivity * $1.intensity) } / Double(recentMoods.count)
        let olderAvg = olderMoods.reduce(0.0) { $0 + ($1.mood.positivity * $1.intensity) } / Double(olderMoods.count)
        
        let diff = recentAvg - olderAvg
        if diff > 0.1 { return .improving }
        if diff < -0.1 { return .declining }
        return .stable
    }
    
    // MARK: - Prompts
    
    func getPromptOfTheDay() -> ReflectionPrompt {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let prompts = Self.allPrompts
        return prompts[dayOfYear % prompts.count]
    }
    
    func getPromptsForMood(_ mood: MoodType) -> [ReflectionPrompt] {
        switch mood {
        case .sad, .frustrated, .anxious:
            return Self.allPrompts.filter { $0.category == .mindfulness || $0.category == .gratitude }
        case .joyful, .happy, .energized:
            return Self.allPrompts.filter { $0.category == .achievement || $0.category == .dream }
        case .tired:
            return Self.allPrompts.filter { $0.category == .gratitude || $0.category == .values }
        default:
            return Self.allPrompts.filter { $0.category == .growth || $0.category == .relationship }
        }
    }
    
    static let allPrompts: [ReflectionPrompt] = [
        // Gratitude
        ReflectionPrompt(id: "g1", category: .gratitude, text: "What are three things you're grateful for today, and why?", followUp: "How did these things make you feel?", suggestedDuration: 5),
        ReflectionPrompt(id: "g2", category: .gratitude, text: "Who made a positive impact on your day?", followUp: "Have you thanked them?", suggestedDuration: 5),
        ReflectionPrompt(id: "g3", category: .gratitude, text: "What small comfort did you enjoy today?", followUp: nil, suggestedDuration: 3),
        ReflectionPrompt(id: "g4", category: .gratitude, text: "What ability or skill are you thankful to have?", followUp: "How did you use it today?", suggestedDuration: 5),
        
        // Growth
        ReflectionPrompt(id: "gr1", category: .growth, text: "What did you learn today that surprised you?", followUp: "How will you apply this learning?", suggestedDuration: 7),
        ReflectionPrompt(id: "gr2", category: .growth, text: "What's one thing you did today that was outside your comfort zone?", followUp: nil, suggestedDuration: 5),
        ReflectionPrompt(id: "gr3", category: .growth, text: "What skill are you actively working to improve?", followUp: "What's your next step?", suggestedDuration: 7),
        ReflectionPrompt(id: "gr4", category: .growth, text: "If you could give advice to yourself from last year, what would it be?", followUp: nil, suggestedDuration: 10),
        
        // Challenge
        ReflectionPrompt(id: "c1", category: .challenge, text: "What challenge did you face today and how did you handle it?", followUp: "What would you do differently?", suggestedDuration: 10),
        ReflectionPrompt(id: "c2", category: .challenge, text: "What obstacle is currently in your way?", followUp: "What's one small step you can take tomorrow?", suggestedDuration: 8),
        ReflectionPrompt(id: "c3", category: .challenge, text: "When did you feel most stressed today?", followUp: "What coping strategies helped?", suggestedDuration: 7),
        
        // Relationship
        ReflectionPrompt(id: "r1", category: .relationship, text: "Describe a meaningful conversation you had recently.", followUp: "What made it meaningful?", suggestedDuration: 8),
        ReflectionPrompt(id: "r2", category: .relationship, text: "Who do you want to connect with more?", followUp: "How can you reach out?", suggestedDuration: 5),
        ReflectionPrompt(id: "r3", category: .relationship, text: "How did you show kindness to someone today?", followUp: nil, suggestedDuration: 5),
        
        // Dream
        ReflectionPrompt(id: "d1", category: .dream, text: "If you knew you couldn't fail, what would you attempt?", followUp: "What's stopping you now?", suggestedDuration: 10),
        ReflectionPrompt(id: "d2", category: .dream, text: "Where do you see yourself in 5 years?", followUp: "What needs to happen to get there?", suggestedDuration: 15),
        ReflectionPrompt(id: "d3", category: .dream, text: "What's a dream you've put on hold?", followUp: "Is now the time to revisit it?", suggestedDuration: 8),
        
        // Mindfulness
        ReflectionPrompt(id: "m1", category: .mindfulness, text: "What sensations did you notice in your body today?", followUp: "What were they telling you?", suggestedDuration: 5),
        ReflectionPrompt(id: "m2", category: .mindfulness, text: "Describe a moment when you felt fully present today.", followUp: nil, suggestedDuration: 5),
        ReflectionPrompt(id: "m3", category: .mindfulness, text: "What thoughts kept recurring today?", followUp: "Are they serving you?", suggestedDuration: 7),
        
        // Values
        ReflectionPrompt(id: "v1", category: .values, text: "What matters most to you right now?", followUp: "Are your actions aligned with this?", suggestedDuration: 10),
        ReflectionPrompt(id: "v2", category: .values, text: "What would you stand up for, no matter what?", followUp: nil, suggestedDuration: 8),
        ReflectionPrompt(id: "v3", category: .values, text: "When did you feel most authentic today?", followUp: "What allowed that?", suggestedDuration: 7),
        
        // Achievement
        ReflectionPrompt(id: "a1", category: .achievement, text: "What accomplishment, big or small, are you proud of today?", followUp: "How did you make it happen?", suggestedDuration: 5),
        ReflectionPrompt(id: "a2", category: .achievement, text: "What progress did you make toward a goal?", followUp: "What's the next milestone?", suggestedDuration: 7),
        ReflectionPrompt(id: "a3", category: .achievement, text: "What did you complete today that you've been putting off?", followUp: nil, suggestedDuration: 5)
    ]
    
    // MARK: - Insights
    
    struct MoodInsight: Identifiable {
        let id = UUID()
        let type: InsightType
        let title: String
        let description: String
        let iconSystemName: String
        let color: Color
        let actionSuggestion: String?
        
        enum InsightType {
            case pattern, correlation, streak, suggestion, warning
        }
    }
    
    func generateInsights() {
        var insights: [MoodInsight] = []
        
        // Streak insight
        if currentStreak >= 3 {
            insights.append(MoodInsight(
                type: .streak,
                title: "Journaling Streak! 🔥",
                description: "You've journaled \(currentStreak) days in a row. Keep it up!",
                iconSystemName: "flame.fill",
                color: .orange,
                actionSuggestion: nil
            ))
        }
        
        // Mood trend insight
        let trend = getMoodTrend()
        switch trend {
        case .improving:
            insights.append(MoodInsight(
                type: .pattern,
                title: "Mood Improving 📈",
                description: "Your overall mood has been trending upward. Great progress!",
                iconSystemName: "chart.line.uptrend.xyaxis",
                color: .green,
                actionSuggestion: "Keep doing what's working!"
            ))
        case .declining:
            insights.append(MoodInsight(
                type: .warning,
                title: "Mood Check-in 💙",
                description: "Your mood has dipped recently. That's okay - let's explore why.",
                iconSystemName: "heart.fill",
                color: .blue,
                actionSuggestion: "Try some self-care activities today"
            ))
        case .stable, .insufficient:
            break
        }
        
        // Trigger correlations
        let correlations = triggerCorrelation()
        if let bestTrigger = correlations.first, bestTrigger.1 > 0.6 {
            insights.append(MoodInsight(
                type: .correlation,
                title: "\(bestTrigger.0.label) Boosts Your Mood",
                description: "Activities related to \(bestTrigger.0.label.lowercased()) are associated with your happiest moments.",
                iconSystemName: bestTrigger.0.iconSystemName,
                color: .green,
                actionSuggestion: "Try to incorporate more \(bestTrigger.0.label.lowercased()) into your routine"
            ))
        }
        
        if let worstTrigger = correlations.last, worstTrigger.1 < 0.4, correlations.count > 3 {
            insights.append(MoodInsight(
                type: .warning,
                title: "\(worstTrigger.0.label) May Be Draining",
                description: "Your mood tends to be lower when \(worstTrigger.0.label.lowercased()) is a factor.",
                iconSystemName: worstTrigger.0.iconSystemName,
                color: .orange,
                actionSuggestion: "Consider setting boundaries around \(worstTrigger.0.label.lowercased())"
            ))
        }
        
        // Most common mood
        let moodCounts = moodCountByType(days: 14)
        if let mostCommon = moodCounts.max(by: { $0.value < $1.value }), mostCommon.value >= 3 {
            insights.append(MoodInsight(
                type: .pattern,
                title: "Common Mood: \(mostCommon.key.label)",
                description: "You've felt \(mostCommon.key.label.lowercased()) \(mostCommon.value) times in the past 2 weeks.",
                iconSystemName: mostCommon.key.iconSystemName,
                color: mostCommon.key.color,
                actionSuggestion: nil
            ))
        }
        
        // Dimension correlation
        let dimMoods = moodByDimension()
        if let bestDim = dimMoods.max(by: { $0.value < $1.value }), bestDim.value > 0.6 {
            insights.append(MoodInsight(
                type: .correlation,
                title: "\(bestDim.key.label) Brings Joy",
                description: "Working on \(bestDim.key.label.lowercased()) activities correlates with positive moods.",
                iconSystemName: bestDim.key.iconSystemName,
                color: Color(hex: bestDim.key.accentColorHex),
                actionSuggestion: "Consider focusing more on \(bestDim.key.label.lowercased()) goals"
            ))
        }
        
        moodInsights = insights
    }
    
    // MARK: - Streaks
    
    private func checkStreak() {
        let today = calendar.startOfDay(for: Date())
        
        guard let lastDateData = UserDefaults.standard.data(forKey: lastEntryDateKey),
              let lastDate = try? JSONDecoder().decode(Date.self, from: lastDateData) else {
            currentStreak = 0
            return
        }
        
        let lastDay = calendar.startOfDay(for: lastDate)
        let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        if daysDiff > 1 {
            currentStreak = 0
        }
        
        // Load persisted streak
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        longestStreak = UserDefaults.standard.integer(forKey: longestStreakKey)
    }
    
    private func updateStreak(for date: Date) {
        let today = calendar.startOfDay(for: date)
        
        if let lastDateData = UserDefaults.standard.data(forKey: lastEntryDateKey),
           let lastDate = try? JSONDecoder().decode(Date.self, from: lastDateData) {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysDiff == 1 || daysDiff == 0 {
                if daysDiff == 1 {
                    currentStreak += 1
                }
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        
        // Save
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        UserDefaults.standard.set(longestStreak, forKey: longestStreakKey)
        if let data = try? JSONEncoder().encode(today) {
            UserDefaults.standard.set(data, forKey: lastEntryDateKey)
        }
    }
    
    private func updateTodaysEntry() {
        let today = Date()
        todaysEntry = entries.first { calendar.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - XP Calculation
    
    func calculateXPForEntry(_ entry: JournalEntry) -> Int {
        var xp = 10 // Base XP
        
        // Words written bonus
        xp += min(entry.wordCount / 10, 20)
        
        // Gratitude bonus
        xp += entry.gratitudeItems.count * 3
        
        // Mood tracking bonus
        if !entry.moodEntry.triggers.isEmpty {
            xp += 5
        }
        
        // Streak bonus
        xp += min(currentStreak * 2, 20)
        
        // Dimension linking bonus
        xp += entry.linkedDimensions.count * 2
        
        return xp
    }
    
    // MARK: - Persistence
    
    private func loadData() {
        // Load entries
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            entries = decoded
        }
        
        // Load mood history
        if let data = UserDefaults.standard.data(forKey: moodKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            moodHistory = decoded
        }
        
        updateTodaysEntry()
    }
    
    private func persistData() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
        if let data = try? JSONEncoder().encode(moodHistory) {
            UserDefaults.standard.set(data, forKey: moodKey)
        }
    }
    
    // MARK: - Statistics
    
    func getStats() -> JournalStats {
        let moodCounts = moodCountByType(days: 30)
        let mostCommon = moodCounts.max(by: { $0.value < $1.value })?.key ?? .neutral
        
        let correlations = triggerCorrelation()
        let topTriggers = Array(correlations.prefix(3).map { $0.0 })
        
        return JournalStats(
            totalEntries: entries.count,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            averageMoodScore: moodAverageForPeriod(days: 30),
            mostCommonMood: mostCommon,
            mostCommonTriggers: topTriggers,
            totalWordsWritten: entries.reduce(0) { $0 + $1.wordCount },
            totalXPEarned: entries.reduce(0) { $0 + $1.xpEarned },
            moodByDimension: moodByDimension(),
            moodTrend: getMoodTrend()
        )
    }
}

// MARK: - Views

/// Main Journal View
struct JournalView: View {
    @Environment(AppModel.self) private var model
    @ObservedObject var manager: JournalManager
    
    @State private var showingNewEntry = false
    @State private var showingQuickMood = false
    @State private var showingHistory = false
    @State private var showingStats = false
    @State private var selectedEntry: JournalEntry?

    init(manager: JournalManager) {
        _manager = ObservedObject(wrappedValue: manager)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    ReflectionModeHeader()

                    // Header with streak
                    JournalHeaderCard(manager: manager)

                    ReflectionRitualCard(ritual: model.ritualOfTheDay, energyCheckIn: model.energyCheckIn)

                    ReflectionAchievementsCard(
                        level: model.level,
                        totalXP: model.totalXP,
                        streak: model.currentStreak,
                        badges: model.unlockedBadges.count
                    )
                    
                    // Today's mood quick capture
                    TodayMoodCard(manager: manager, showingQuickMood: $showingQuickMood)
                    
                    // Prompt of the day
                    PromptCard(manager: manager, showingNewEntry: $showingNewEntry)
                    
                    // Today's entry or CTA
                    if let entry = manager.todaysEntry {
                        TodaysEntryCard(entry: entry, onEdit: {
                            selectedEntry = entry
                            showingNewEntry = true
                        })
                    } else {
                        StartJournalingCard(showingNewEntry: $showingNewEntry)
                    }
                    
                    // Mood insights
                    if !manager.moodInsights.isEmpty {
                        MoodInsightsCard(insights: manager.moodInsights)
                    }
                    
                    // Mood trend visualization
                    MoodTrendCard(manager: manager)
                    
                    // Recent entries
                    RecentEntriesCard(
                        entries: Array(manager.entries.suffix(5).reversed()),
                        onSelectEntry: { entry in
                            selectedEntry = entry
                            showingNewEntry = true
                        }
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.bottom, 100)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle(L10n.reflectionModeTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            showingStats = true
                        } label: {
                            Image(systemName: "chart.bar.fill")
                        }
                        
                        Button {
                            showingHistory = true
                        } label: {
                            Image(systemName: "clock.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                JournalEntrySheet(
                    manager: manager,
                    existingEntry: selectedEntry,
                    onSave: { entry in
                        manager.saveEntry(entry)
                        selectedEntry = nil
                    }
                )
            }
            .sheet(isPresented: $showingQuickMood) {
                QuickMoodSheet(manager: manager)
            }
            .sheet(isPresented: $showingHistory) {
                JournalHistorySheet(manager: manager, onSelectEntry: { entry in
                    selectedEntry = entry
                    showingHistory = false
                    showingNewEntry = true
                })
            }
            .sheet(isPresented: $showingStats) {
                JournalStatsSheet(manager: manager)
            }
        }
    }
}

// MARK: - Reflection Mode Header

struct ReflectionModeHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(L10n.reflectionModeTitle)
                .font(.largeTitle.bold())
                .foregroundStyle(BrandTheme.textPrimary)

            Text(L10n.reflectionModeSubtitle)
                .font(.subheadline)
                .foregroundStyle(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Reflection Ritual Card

struct ReflectionRitualCard: View {
    let ritual: String
    let energyCheckIn: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                IconContainer(systemName: "sun.max.fill", color: BrandTheme.accent, size: .small, style: .gradient)

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.reflectionRitualTitle)
                        .font(.headline)
                        .foregroundStyle(BrandTheme.textPrimary)

                    Text(L10n.reflectionRitualSubtitle)
                        .font(.caption)
                        .foregroundStyle(BrandTheme.mutedText)
                }

                Spacer()
            }

            Text(ritual)
                .font(.body)
                .foregroundStyle(BrandTheme.textPrimary)

            Text(energyCheckIn)
                .font(.subheadline)
                .foregroundStyle(BrandTheme.textSecondary)
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Reflection Achievements Card

struct ReflectionAchievementsCard: View {
    let level: Int
    let totalXP: Int
    let streak: Int
    let badges: Int

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                IconContainer(systemName: "trophy.fill", color: BrandTheme.warning, size: .small, style: .gradient)

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.reflectionAchievementsTitle)
                        .font(.headline)
                        .foregroundStyle(BrandTheme.textPrimary)

                    Text(L10n.reflectionAchievementsSubtitle)
                        .font(.caption)
                        .foregroundStyle(BrandTheme.mutedText)
                }

                Spacer()
            }

            HStack(spacing: DesignSystem.Spacing.sm) {
                ReflectionAchievementPill(
                    title: String(format: String(localized: "reflection.achievement.level", bundle: .module), level),
                    subtitle: String(format: String(localized: "reflection.achievement.xp", bundle: .module), totalXP),
                    icon: "star.fill",
                    color: BrandTheme.accent
                )

                ReflectionAchievementPill(
                    title: String(format: String(localized: "reflection.achievement.streak", bundle: .module), streak),
                    subtitle: String(localized: "reflection.achievement.momentum", bundle: .module),
                    icon: "flame.fill",
                    color: BrandTheme.success
                )

                ReflectionAchievementPill(
                    title: String(format: String(localized: "reflection.achievement.badges", bundle: .module), badges),
                    subtitle: String(localized: "reflection.achievement.unlocked", bundle: .module),
                    icon: "rosette",
                    color: BrandTheme.warning
                )
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

struct ReflectionAchievementPill: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(BrandTheme.textPrimary)
            }

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Journal Header Card

struct JournalHeaderCard: View {
    @ObservedObject var manager: JournalManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Journal")
                    .font(.title2.bold())
                
                Text(Date(), style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Streak badge
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("\(manager.currentStreak)")
                    .font(.headline.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.orange.opacity(0.15))
            .clipShape(Capsule())
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Today Mood Card

struct TodayMoodCard: View {
    @ObservedObject var manager: JournalManager
    @Binding var showingQuickMood: Bool
    
    var todaysMoods: [MoodEntry] {
        let calendar = Calendar.current
        return manager.moodHistory.filter { calendar.isDateInToday($0.timestamp) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("How are you feeling?")
                    .font(.headline)
                
                Spacer()
                
                if !todaysMoods.isEmpty {
                    Text("\(todaysMoods.count) check-ins today")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Quick mood selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MoodType.allCases) { mood in
                        QuickMoodButton(mood: mood) {
                            manager.logQuickMood(mood, intensity: 0.7)
                            HapticsEngine.lightImpact()
                        }
                    }
                }
            }
            
            // Recent mood indicators
            if !todaysMoods.isEmpty {
                Divider()
                
                HStack(spacing: 8) {
                    Text("Today:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ForEach(todaysMoods.suffix(5)) { entry in
                        Text(entry.mood.emoji)
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    Button("Details") {
                        showingQuickMood = true
                    }
                    .font(.caption.bold())
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

struct QuickMoodButton: View {
    let mood: MoodType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.title)
                Text(mood.label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 60)
            .padding(.vertical, 8)
            .background(mood.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Prompt Card

struct PromptCard: View {
    @ObservedObject var manager: JournalManager
    @Binding var showingNewEntry: Bool
    
    var prompt: ReflectionPrompt {
        manager.getPromptOfTheDay()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Today's Prompt")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("~\(prompt.suggestedDuration) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(prompt.text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            if let followUp = prompt.followUp {
                Text(followUp)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }
            
            Button {
                manager.selectedPrompt = prompt
                showingNewEntry = true
            } label: {
                HStack {
                    Image(systemName: "pencil.line")
                    Text("Write About This")
                }
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(BrandTheme.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Today's Entry Card

struct TodaysEntryCard: View {
    let entry: JournalEntry
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Today's Entry")
                    .font(.headline)
                
                Spacer()
                
                Text(entry.moodEntry.mood.emoji)
                    .font(.title2)
                
                Button("Edit", action: onEdit)
                    .font(.subheadline.bold())
            }
            
            if !entry.freeformText.isEmpty {
                Text(entry.freeformText)
                    .font(.body)
                    .lineLimit(3)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                Label("\(entry.wordCount) words", systemImage: "text.alignleft")
                Label("\(entry.gratitudeItems.count) gratitudes", systemImage: "heart.fill")
                Label("+\(entry.xpEarned) XP", systemImage: "star.fill")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Start Journaling Card

struct StartJournalingCard: View {
    @Binding var showingNewEntry: Bool
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 48))
                .foregroundStyle(BrandTheme.accent)
            
            Text("Start Today's Entry")
                .font(.headline)
            
            Text("Take a moment to reflect on your day and capture your thoughts.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingNewEntry = true
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("Begin Writing")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(BrandTheme.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Mood Insights Card

struct MoodInsightsCard: View {
    let insights: [JournalManager.MoodInsight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Insights")
                .font(.headline)
            
            ForEach(insights.prefix(3)) { insight in
                HStack(spacing: 12) {
                    Image(systemName: insight.iconSystemName)
                        .font(.title2)
                        .foregroundStyle(insight.color)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(insight.title)
                            .font(.subheadline.bold())
                        Text(insight.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Mood Trend Card

struct MoodTrendCard: View {
    @ObservedObject var manager: JournalManager
    
    var recentMoods: [MoodEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return manager.moodHistory.filter { $0.timestamp >= cutoff }.suffix(14).reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Mood Trend")
                    .font(.headline)
                
                Spacer()
                
                let trend = manager.getMoodTrend()
                HStack(spacing: 4) {
                    Image(systemName: trend == .improving ? "arrow.up.right" : trend == .declining ? "arrow.down.right" : "arrow.right")
                    Text(trend == .improving ? "Improving" : trend == .declining ? "Declining" : "Stable")
                }
                .font(.caption.bold())
                .foregroundStyle(trend == .improving ? .green : trend == .declining ? .orange : .secondary)
            }
            
            if recentMoods.isEmpty {
                Text("Log some moods to see your trend")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                // Simple mood visualization
                HStack(spacing: 4) {
                    ForEach(Array(recentMoods.enumerated()), id: \.element.id) { index, mood in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(mood.mood.color)
                                .frame(width: 20, height: CGFloat(mood.mood.positivity * mood.intensity * 50 + 10))
                            
                            Text(mood.mood.emoji)
                                .font(.caption2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80, alignment: .bottom)
            }
            
            // Mood distribution
            let counts = manager.moodCountByType(days: 7)
            if !counts.isEmpty {
                Divider()
                
                HStack {
                    ForEach(Array(counts.sorted { $0.value > $1.value }.prefix(4)), id: \.key) { mood, count in
                        HStack(spacing: 4) {
                            Text(mood.emoji)
                            Text("\(count)")
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(mood.color.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Recent Entries Card

struct RecentEntriesCard: View {
    let entries: [JournalEntry]
    let onSelectEntry: (JournalEntry) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Recent Entries")
                .font(.headline)
            
            if entries.isEmpty {
                Text("Your journal entries will appear here")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(entries) { entry in
                    Button {
                        onSelectEntry(entry)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.date, style: .date)
                                    .font(.subheadline.bold())
                                
                                if !entry.freeformText.isEmpty {
                                    Text(entry.freeformText)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                            
                            Text(entry.moodEntry.mood.emoji)
                                .font(.title2)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    
                    if entry.id != entries.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Journal Entry Sheet

struct JournalEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: JournalManager
    let existingEntry: JournalEntry?
    let onSave: (JournalEntry) -> Void
    
    @State private var selectedMood: MoodType = .neutral
    @State private var moodIntensity: Double = 0.5
    @State private var selectedTriggers: Set<MoodTrigger> = []
    @State private var gratitudeItems: [String] = ["", "", ""]
    @State private var highlights: [String] = [""]
    @State private var challenges: [String] = [""]
    @State private var freeformText: String = ""
    @State private var selectedDimensions: Set<LifeDimension> = []
    @State private var currentSection = 0
    
    private let sections = ["Mood", "Gratitude", "Reflection", "Review"]
    
    init(manager: JournalManager, existingEntry: JournalEntry?, onSave: @escaping (JournalEntry) -> Void) {
        self.manager = manager
        self.existingEntry = existingEntry
        self.onSave = onSave
        
        if let entry = existingEntry {
            _selectedMood = State(initialValue: entry.moodEntry.mood)
            _moodIntensity = State(initialValue: entry.moodEntry.intensity)
            _selectedTriggers = State(initialValue: Set(entry.moodEntry.triggers))
            _gratitudeItems = State(initialValue: entry.gratitudeItems.isEmpty ? ["", "", ""] : entry.gratitudeItems + Array(repeating: "", count: max(0, 3 - entry.gratitudeItems.count)))
            _highlights = State(initialValue: entry.highlights.isEmpty ? [""] : entry.highlights)
            _challenges = State(initialValue: entry.challenges.isEmpty ? [""] : entry.challenges)
            _freeformText = State(initialValue: entry.freeformText)
            _selectedDimensions = State(initialValue: Set(entry.linkedDimensions))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Section tabs
                HStack(spacing: 0) {
                    ForEach(0..<sections.count, id: \.self) { index in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                currentSection = index
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text(sections[index])
                                    .font(.subheadline.bold())
                                    .foregroundStyle(currentSection == index ? BrandTheme.accent : .secondary)
                                
                                Rectangle()
                                    .fill(currentSection == index ? BrandTheme.accent : .clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                TabView(selection: $currentSection) {
                    // Section 1: Mood
                    MoodSelectionSection(
                        selectedMood: $selectedMood,
                        intensity: $moodIntensity,
                        triggers: $selectedTriggers
                    )
                    .tag(0)
                    
                    // Section 2: Gratitude
                    GratitudeSection(items: $gratitudeItems)
                        .tag(1)
                    
                    // Section 3: Reflection
                    ReflectionSection(
                        highlights: $highlights,
                        challenges: $challenges,
                        freeformText: $freeformText,
                        prompt: manager.selectedPrompt
                    )
                    .tag(2)
                    
                    // Section 4: Review
                    ReviewSection(
                        mood: selectedMood,
                        intensity: moodIntensity,
                        gratitudeItems: gratitudeItems.filter { !$0.isEmpty },
                        highlights: highlights.filter { !$0.isEmpty },
                        challenges: challenges.filter { !$0.isEmpty },
                        freeformText: freeformText,
                        dimensions: $selectedDimensions
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(BrandBackgroundStatic())
            .navigationTitle(existingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if currentSection == sections.count - 1 {
                        Button("Save") {
                            saveEntry()
                        }
                        .font(.headline)
                    } else {
                        Button("Next") {
                            withAnimation(.spring(response: 0.3)) {
                                currentSection += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveEntry() {
        let moodEntry = MoodEntry(
            id: existingEntry?.moodEntry.id ?? UUID(),
            mood: selectedMood,
            intensity: moodIntensity,
            timestamp: Date(),
            note: nil,
            triggers: Array(selectedTriggers)
        )
        
        var entry = JournalEntry(
            id: existingEntry?.id ?? UUID(),
            date: existingEntry?.date ?? Date(),
            moodEntry: moodEntry,
            gratitudeItems: gratitudeItems.filter { !$0.isEmpty },
            highlights: highlights.filter { !$0.isEmpty },
            challenges: challenges.filter { !$0.isEmpty },
            freeformText: freeformText,
            linkedDimensions: Array(selectedDimensions),
            promptUsed: manager.selectedPrompt?.text
        )
        
        entry = JournalEntry(
            id: entry.id,
            date: entry.date,
            moodEntry: entry.moodEntry,
            gratitudeItems: entry.gratitudeItems,
            highlights: entry.highlights,
            challenges: entry.challenges,
            freeformText: entry.freeformText,
            linkedDimensions: entry.linkedDimensions,
            xpEarned: manager.calculateXPForEntry(entry),
            promptUsed: entry.promptUsed
        )
        
        onSave(entry)
        HapticsEngine.success()
        dismiss()
    }
}

// MARK: - Entry Sections

struct MoodSelectionSection: View {
    @Binding var selectedMood: MoodType
    @Binding var intensity: Double
    @Binding var triggers: Set<MoodTrigger>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Mood selection
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("How are you feeling?")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                        ForEach(MoodType.allCases) { mood in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedMood = mood
                                }
                                HapticsEngine.lightImpact()
                            } label: {
                                VStack(spacing: 8) {
                                    Text(mood.emoji)
                                        .font(.system(size: 36))
                                    Text(mood.label)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedMood == mood ? mood.color.opacity(0.3) : Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.Radii.md)
                                        .stroke(selectedMood == mood ? mood.color : .clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Intensity slider
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    HStack {
                        Text("Intensity")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(intensity * 100))%")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $intensity, in: 0...1)
                        .tint(selectedMood.color)
                }
                
                Divider()
                
                // Triggers
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("What's influencing your mood?")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                        ForEach(MoodTrigger.allCases) { trigger in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    if triggers.contains(trigger) {
                                        triggers.remove(trigger)
                                    } else {
                                        triggers.insert(trigger)
                                    }
                                }
                                HapticsEngine.lightImpact()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: trigger.iconSystemName)
                                        .font(.caption)
                                    Text(trigger.label)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(triggers.contains(trigger) ? BrandTheme.accent.opacity(0.2) : Color.secondary.opacity(0.1))
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(triggers.contains(trigger) ? BrandTheme.accent : .clear, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct GratitudeSection: View {
    @Binding var items: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("What are you grateful for?")
                        .font(.headline)
                    
                    Text("Practicing gratitude can significantly improve your wellbeing")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                ForEach(0..<items.count, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1).")
                            .font(.headline)
                            .foregroundStyle(BrandTheme.accent)
                            .frame(width: 24)
                        
                        TextField("I'm grateful for...", text: $items[index], axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.sm))
                    }
                }
                
                Button {
                    items.append("")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Another")
                    }
                    .font(.subheadline)
                    .foregroundStyle(BrandTheme.accent)
                }
            }
            .padding()
        }
    }
}

struct ReflectionSection: View {
    @Binding var highlights: [String]
    @Binding var challenges: [String]
    @Binding var freeformText: String
    let prompt: ReflectionPrompt?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Prompt (if any)
                if let prompt = prompt {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                            Text("Today's Prompt")
                                .font(.subheadline.bold())
                        }
                        
                        Text(prompt.text)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(BrandTheme.accent.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    }
                }
                
                // Freeform writing
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("Free Writing")
                        .font(.headline)
                    
                    TextEditor(text: $freeformText)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    
                    Text("\(freeformText.split(separator: " ").count) words")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // Highlights
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("Today's Highlights")
                        .font(.headline)
                    
                    ForEach(0..<highlights.count, id: \.self) { index in
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                            
                            TextField("A win or positive moment...", text: $highlights[index])
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.sm))
                        }
                    }
                    
                    Button {
                        highlights.append("")
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Highlight")
                        }
                        .font(.caption)
                        .foregroundStyle(BrandTheme.accent)
                    }
                }
                
                Divider()
                
                // Challenges
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("Challenges Faced")
                        .font(.headline)
                    
                    ForEach(0..<challenges.count, id: \.self) { index in
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.caption)
                            
                            TextField("A difficulty or obstacle...", text: $challenges[index])
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.sm))
                        }
                    }
                    
                    Button {
                        challenges.append("")
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Challenge")
                        }
                        .font(.caption)
                        .foregroundStyle(BrandTheme.accent)
                    }
                }
            }
            .padding()
        }
    }
}

struct ReviewSection: View {
    let mood: MoodType
    let intensity: Double
    let gratitudeItems: [String]
    let highlights: [String]
    let challenges: [String]
    let freeformText: String
    @Binding var dimensions: Set<LifeDimension>
    
    var wordCount: Int {
        freeformText.split(separator: " ").count +
        gratitudeItems.joined(separator: " ").split(separator: " ").count +
        highlights.joined(separator: " ").split(separator: " ").count +
        challenges.joined(separator: " ").split(separator: " ").count
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Summary
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Entry Summary")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text(mood.emoji)
                                .font(.system(size: 48))
                            Text(mood.label)
                                .font(.caption)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "text.alignleft")
                                Text("\(wordCount) words")
                            }
                            HStack {
                                Image(systemName: "heart.fill")
                                Text("\(gratitudeItems.count) gratitudes")
                            }
                            HStack {
                                Image(systemName: "star.fill")
                                Text("\(highlights.count) highlights")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(mood.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                }
                
                Divider()
                
                // Link dimensions
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Link to Life Dimensions")
                        .font(.headline)
                    
                    Text("Connect this entry to areas of your life")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        ForEach(LifeDimension.allCases) { dimension in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    if dimensions.contains(dimension) {
                                        dimensions.remove(dimension)
                                    } else {
                                        dimensions.insert(dimension)
                                    }
                                }
                                HapticsEngine.lightImpact()
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: dimension.iconSystemName)
                                        .font(.title2)
                                    Text(dimension.label)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(dimensions.contains(dimension) ? Color(hex: dimension.accentColorHex).opacity(0.3) : Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.Radii.md)
                                        .stroke(dimensions.contains(dimension) ? Color(hex: dimension.accentColorHex) : .clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // XP preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("XP Earned")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("You'll earn approximately \(estimatedXP) XP for this entry")
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                }
            }
            .padding()
        }
    }
    
    var estimatedXP: Int {
        var xp = 10
        xp += min(wordCount / 10, 20)
        xp += gratitudeItems.count * 3
        xp += dimensions.count * 2
        return xp
    }
}

// MARK: - Quick Mood Sheet

struct QuickMoodSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: JournalManager
    
    @State private var selectedMood: MoodType = .neutral
    @State private var intensity: Double = 0.5
    @State private var note: String = ""
    @State private var selectedTriggers: Set<MoodTrigger> = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Mood selection
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                        ForEach(MoodType.allCases) { mood in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedMood = mood
                                }
                                HapticsEngine.lightImpact()
                            } label: {
                                VStack(spacing: 6) {
                                    Text(mood.emoji)
                                        .font(.system(size: 32))
                                    Text(mood.label)
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedMood == mood ? mood.color.opacity(0.3) : Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    // Intensity
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Intensity")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("\(Int(intensity * 100))%")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $intensity, in: 0...1)
                            .tint(selectedMood.color)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    
                    // Note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick Note (optional)")
                            .font(.subheadline.bold())
                        
                        TextField("What's on your mind?", text: $note, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    }
                    
                    // Triggers
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's influencing this?")
                            .font(.subheadline.bold())
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                            ForEach(MoodTrigger.allCases) { trigger in
                                Button {
                                    if selectedTriggers.contains(trigger) {
                                        selectedTriggers.remove(trigger)
                                    } else {
                                        selectedTriggers.insert(trigger)
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: trigger.iconSystemName)
                                        Text(trigger.label)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(selectedTriggers.contains(trigger) ? BrandTheme.accent.opacity(0.2) : Color.secondary.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Log Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        manager.logQuickMood(
                            selectedMood,
                            intensity: intensity,
                            note: note.isEmpty ? nil : note,
                            triggers: Array(selectedTriggers)
                        )
                        HapticsEngine.success()
                        dismiss()
                    }
                    .font(.headline)
                }
            }
        }
    }
}

// MARK: - Journal History Sheet

struct JournalHistorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: JournalManager
    let onSelectEntry: (JournalEntry) -> Void
    
    @State private var selectedMonth = Date()
    
    private let calendar = Calendar.current
    
    var entriesForMonth: [JournalEntry] {
        manager.entries.filter { entry in
            calendar.isDate(entry.date, equalTo: selectedMonth, toGranularity: .month)
        }.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month selector
                HStack {
                    Button {
                        selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Text(selectedMonth, format: .dateTime.month(.wide).year())
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                Divider()
                
                if entriesForMonth.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "book.closed")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No entries this month")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(entriesForMonth) { entry in
                            Button {
                                onSelectEntry(entry)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.date, format: .dateTime.weekday(.wide).day())
                                            .font(.subheadline.bold())
                                        
                                        if !entry.freeformText.isEmpty {
                                            Text(entry.freeformText)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Label("\(entry.wordCount)", systemImage: "text.alignleft")
                                            Label("\(entry.gratitudeItems.count)", systemImage: "heart.fill")
                                        }
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(entry.moodEntry.mood.emoji)
                                        .font(.title)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                manager.deleteEntry(entriesForMonth[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Journal Stats Sheet

struct JournalStatsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: JournalManager
    
    var stats: JournalStats {
        manager.getStats()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Overview
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        JournalStatTile(title: "Total Entries", value: "\(stats.totalEntries)", icon: "book.fill", color: .blue)
                        JournalStatTile(title: "Current Streak", value: "\(stats.currentStreak)", icon: "flame.fill", color: .orange)
                        JournalStatTile(title: "Longest Streak", value: "\(stats.longestStreak)", icon: "trophy.fill", color: .yellow)
                        JournalStatTile(title: "Words Written", value: "\(stats.totalWordsWritten)", icon: "text.alignleft", color: .purple)
                    }
                    
                    // Mood overview
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("Mood Overview")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text(stats.mostCommonMood.emoji)
                                    .font(.system(size: 48))
                                Text("Most Common")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(stats.mostCommonMood.label)
                                    .font(.subheadline.bold())
                            }
                            
                            Divider()
                                .frame(height: 80)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Average Mood")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(Int(stats.averageMoodScore * 100))%")
                                        .font(.subheadline.bold())
                                }
                                
                                ProgressView(value: stats.averageMoodScore)
                                    .tint(stats.averageMoodScore > 0.6 ? .green : stats.averageMoodScore > 0.4 ? .yellow : .orange)
                                
                                HStack {
                                    Text("Trend")
                                        .font(.subheadline)
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Image(systemName: stats.moodTrend == .improving ? "arrow.up.right" : stats.moodTrend == .declining ? "arrow.down.right" : "arrow.right")
                                        Text(stats.moodTrend.rawValue.capitalized)
                                    }
                                    .font(.subheadline.bold())
                                    .foregroundStyle(stats.moodTrend == .improving ? .green : stats.moodTrend == .declining ? .orange : .secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .modifier(BrandCardModifier())
                    
                    // Top triggers
                    if !stats.mostCommonTriggers.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Top Mood Influences")
                                .font(.headline)
                            
                            ForEach(stats.mostCommonTriggers, id: \.self) { trigger in
                                HStack {
                                    Image(systemName: trigger.iconSystemName)
                                        .frame(width: 30)
                                    Text(trigger.label)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .padding()
                        .modifier(BrandCardModifier())
                    }
                    
                    // Dimension mood correlation
                    if !stats.moodByDimension.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Mood by Life Area")
                                .font(.headline)
                            
                            ForEach(Array(stats.moodByDimension.sorted { $0.value > $1.value }), id: \.key) { dimension, score in
                                HStack {
                                    Image(systemName: dimension.iconSystemName)
                                        .foregroundStyle(Color(hex: dimension.accentColorHex))
                                        .frame(width: 30)
                                    Text(dimension.label)
                                    Spacer()
                                    
                                    ProgressView(value: score)
                                        .frame(width: 100)
                                        .tint(Color(hex: dimension.accentColorHex))
                                    
                                    Text("\(Int(score * 100))%")
                                        .font(.caption.bold())
                                        .frame(width: 40, alignment: .trailing)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .modifier(BrandCardModifier())
                    }
                    
                    // XP earned
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("XP from Journaling")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.title)
                                .foregroundStyle(.yellow)
                            
                            VStack(alignment: .leading) {
                                Text("\(stats.totalXPEarned) XP")
                                    .font(.title2.bold())
                                Text("earned from journal entries")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .modifier(BrandCardModifier())
                }
                .padding()
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Journal Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct JournalStatTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title.bold())
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Preview

#if DEBUG
struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(manager: JournalManager())
            .environment(AppModel())
    }
}
#endif
