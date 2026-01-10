import SwiftUI
import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif

// MARK: - AAA Game Systems
// This file contains advanced gamification systems that elevate the app to AAA quality.

// MARK: - Daily Challenge System

/// Represents a daily challenge with bonus XP rewards
struct DailyChallenge: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconSystemName: String
    let targetCount: Int
    let bonusXP: Int
    let challengeType: ChallengeType
    let dimensions: [LifeDimension]
    var progress: Int
    var isCompleted: Bool
    var dateGenerated: Date
    var completedDimensions: Set<LifeDimension>
    
    enum ChallengeType: String, Codable {
        case completeItems      // Complete X items
        case completeDimension  // Complete X items in a dimension
        case completeQuests     // Complete X quests
        case maintainStreak     // Maintain streak
        case balanceDimensions  // Work on multiple dimensions
        case speedRun          // Complete items within time
        case perfectDay        // Complete all suggested items
    }
    
    var progressRatio: Double {
        guard targetCount > 0 else { return 0 }
        return min(1.0, Double(progress) / Double(targetCount))
    }

    init(
        id: String,
        title: String,
        description: String,
        iconSystemName: String,
        targetCount: Int,
        bonusXP: Int,
        challengeType: ChallengeType,
        dimensions: [LifeDimension],
        progress: Int,
        isCompleted: Bool,
        dateGenerated: Date,
        completedDimensions: Set<LifeDimension> = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconSystemName = iconSystemName
        self.targetCount = targetCount
        self.bonusXP = bonusXP
        self.challengeType = challengeType
        self.dimensions = dimensions
        self.progress = progress
        self.isCompleted = isCompleted
        self.dateGenerated = dateGenerated
        self.completedDimensions = completedDimensions
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case iconSystemName
        case targetCount
        case bonusXP
        case challengeType
        case dimensions
        case progress
        case isCompleted
        case dateGenerated
        case completedDimensions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        iconSystemName = try container.decode(String.self, forKey: .iconSystemName)
        targetCount = try container.decode(Int.self, forKey: .targetCount)
        bonusXP = try container.decode(Int.self, forKey: .bonusXP)
        challengeType = try container.decode(ChallengeType.self, forKey: .challengeType)
        dimensions = try container.decode([LifeDimension].self, forKey: .dimensions)
        progress = try container.decode(Int.self, forKey: .progress)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        dateGenerated = try container.decode(Date.self, forKey: .dateGenerated)
        completedDimensions = try container.decodeIfPresent(Set<LifeDimension>.self, forKey: .completedDimensions) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(iconSystemName, forKey: .iconSystemName)
        try container.encode(targetCount, forKey: .targetCount)
        try container.encode(bonusXP, forKey: .bonusXP)
        try container.encode(challengeType, forKey: .challengeType)
        try container.encode(dimensions, forKey: .dimensions)
        try container.encode(progress, forKey: .progress)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(dateGenerated, forKey: .dateGenerated)
        if !completedDimensions.isEmpty {
            try container.encode(completedDimensions, forKey: .completedDimensions)
        }
    }
}

/// Manages daily challenge generation and tracking
@MainActor
final class DailyChallengeManager: ObservableObject {
    @Published var todaysChallenges: [DailyChallenge] = []
    @Published var challengeStreak: Int = 0
    
    private let calendar = Calendar.current
    private let challengeKey = "lifeXP.dailyChallenges"
    private let streakKey = "lifeXP.challengeStreak"
    private let lastDateKey = "lifeXP.challengeLastDate"
    private let defaults = UserDefaults.standard
    
    init() {
        loadChallenges()
    }
    
    func generateChallengesIfNeeded(totalXP: Int, completedCount: Int) {
        let today = calendar.startOfDay(for: Date())
        
        // Check if we already have challenges for today
        if let firstChallenge = todaysChallenges.first {
            let challengeDate = calendar.startOfDay(for: firstChallenge.dateGenerated)
            if challengeDate == today { return }
        }
        
        refreshStreakIfNeeded(for: today)

        // Generate new challenges based on player level
        let level = max(1, totalXP / 120 + 1)
        todaysChallenges = generateChallenges(forLevel: level, completedCount: completedCount)
        saveChallenges()
    }
    
    private func generateChallenges(forLevel level: Int, completedCount: Int) -> [DailyChallenge] {
        let now = Date()
        var challenges: [DailyChallenge] = []
        
        // Primary challenge - Complete items
        let primaryTarget = min(3 + level / 3, 8)
        challenges.append(DailyChallenge(
            id: "daily_primary_\(now.timeIntervalSince1970)",
            title: "Daily Quest",
            description: "Complete \(primaryTarget) items today",
            iconSystemName: "checkmark.circle.fill",
            targetCount: primaryTarget,
            bonusXP: 25 + level * 5,
            challengeType: .completeItems,
            dimensions: [],
            progress: 0,
            isCompleted: false,
            dateGenerated: now
        ))
        
        // Dimension focus challenge
        let dimensions: [LifeDimension] = [.love, .money, .mind, .adventure]
        let focusDimension = dimensions[calendar.component(.day, from: now) % dimensions.count]
        challenges.append(DailyChallenge(
            id: "daily_dimension_\(now.timeIntervalSince1970)",
            title: "\(focusDimension.label) Focus",
            description: "Complete 2 \(focusDimension.label.lowercased()) items",
            iconSystemName: focusDimension.iconSystemName,
            targetCount: 2,
            bonusXP: 30,
            challengeType: .completeDimension,
            dimensions: [focusDimension],
            progress: 0,
            isCompleted: false,
            dateGenerated: now
        ))
        
        // Streak challenge (if player has history)
        if completedCount > 10 {
            challenges.append(DailyChallenge(
                id: "daily_streak_\(now.timeIntervalSince1970)",
                title: "Streak Guardian",
                description: "Complete at least 1 item to maintain your streak",
                iconSystemName: "flame.fill",
                targetCount: 1,
                bonusXP: 15,
                challengeType: .maintainStreak,
                dimensions: [],
                progress: 0,
                isCompleted: false,
                dateGenerated: now
            ))
        }
        
        // Balance challenge for advanced players
        if level >= 5 {
            challenges.append(DailyChallenge(
                id: "daily_balance_\(now.timeIntervalSince1970)",
                title: "Life Balance",
                description: "Complete items in 3 different dimensions",
                iconSystemName: "circle.grid.cross.fill",
                targetCount: 3,
                bonusXP: 40,
                challengeType: .balanceDimensions,
                dimensions: [],
                progress: 0,
                isCompleted: false,
                dateGenerated: now
            ))
        }
        
        return challenges
    }
    
    func updateProgress(for itemDimensions: [LifeDimension]) {
        for i in todaysChallenges.indices {
            guard !todaysChallenges[i].isCompleted else { continue }
            
            switch todaysChallenges[i].challengeType {
            case .completeItems, .maintainStreak:
                todaysChallenges[i].progress = min(todaysChallenges[i].progress + 1, todaysChallenges[i].targetCount)
            case .completeDimension:
                if !todaysChallenges[i].dimensions.isEmpty &&
                   itemDimensions.contains(where: { todaysChallenges[i].dimensions.contains($0) }) {
                    todaysChallenges[i].progress = min(todaysChallenges[i].progress + 1, todaysChallenges[i].targetCount)
                }
            case .balanceDimensions:
                let newDimensions = Set(itemDimensions)
                if !newDimensions.isEmpty {
                    todaysChallenges[i].completedDimensions.formUnion(newDimensions)
                    todaysChallenges[i].progress = min(todaysChallenges[i].completedDimensions.count, todaysChallenges[i].targetCount)
                }
            default:
                break
            }
            
            // Check if challenge is now complete
            if todaysChallenges[i].progress >= todaysChallenges[i].targetCount {
                todaysChallenges[i].isCompleted = true
            }
        }
        
        saveChallenges()
        updateStreakIfNeeded()
    }
    
    var totalBonusXPAvailable: Int {
        todaysChallenges.reduce(0) { $0 + $1.bonusXP }
    }
    
    var earnedBonusXP: Int {
        todaysChallenges.filter { $0.isCompleted }.reduce(0) { $0 + $1.bonusXP }
    }
    
    var allChallengesCompleted: Bool {
        !todaysChallenges.isEmpty && todaysChallenges.allSatisfy { $0.isCompleted }
    }
    
    private func saveChallenges() {
        if let encoded = try? JSONEncoder().encode(todaysChallenges) {
            defaults.set(encoded, forKey: challengeKey)
        }
    }
    
    private func loadChallenges() {
        if let data = defaults.data(forKey: challengeKey),
           let decoded = try? JSONDecoder().decode([DailyChallenge].self, from: data) {
            todaysChallenges = decoded
        }
        challengeStreak = defaults.integer(forKey: streakKey)
    }

    private func updateStreakIfNeeded() {
        guard allChallengesCompleted else { return }
        let today = calendar.startOfDay(for: Date())

        if let lastDate = defaults.object(forKey: lastDateKey) as? Date,
           calendar.isDate(lastDate, inSameDayAs: today) {
            return
        }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        if let lastDate = defaults.object(forKey: lastDateKey) as? Date,
           let yesterday = yesterday,
           calendar.isDate(lastDate, inSameDayAs: yesterday) {
            challengeStreak += 1
        } else {
            challengeStreak = 1
        }

        defaults.set(today, forKey: lastDateKey)
        defaults.set(challengeStreak, forKey: streakKey)
    }

    private func refreshStreakIfNeeded(for today: Date) {
        guard let lastDate = defaults.object(forKey: lastDateKey) as? Date else { return }
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else { return }
        if lastDate < yesterday {
            challengeStreak = 0
            defaults.set(0, forKey: streakKey)
        }
    }
}

// MARK: - Combo & Multiplier System

/// Tracks combo streaks for consecutive completions
struct ComboSystem {
    var currentCombo: Int = 0
    var maxCombo: Int = 0
    var lastCompletionTime: Date?
    var comboWindowSeconds: TimeInterval = 300 // 5 minutes
    
    mutating func registerCompletion() {
        let now = Date()
        
        if let lastTime = lastCompletionTime {
            let elapsed = now.timeIntervalSince(lastTime)
            if elapsed <= comboWindowSeconds {
                currentCombo += 1
                maxCombo = max(maxCombo, currentCombo)
            } else {
                currentCombo = 1
            }
        } else {
            currentCombo = 1
        }
        
        lastCompletionTime = now
    }
    
    mutating func resetCombo() {
        currentCombo = 0
    }
    
    var multiplier: Double {
        switch currentCombo {
        case 0...1: return 1.0
        case 2...3: return 1.25
        case 4...5: return 1.5
        case 6...9: return 1.75
        default: return 2.0
        }
    }
    
    var comboLabel: String {
        switch currentCombo {
        case 0...1: return ""
        case 2...3: return "Nice!"
        case 4...5: return "Great!"
        case 6...9: return "Amazing!"
        default: return "LEGENDARY!"
        }
    }
    
    var timeRemaining: TimeInterval {
        guard let lastTime = lastCompletionTime else { return 0 }
        let elapsed = Date().timeIntervalSince(lastTime)
        return max(0, comboWindowSeconds - elapsed)
    }
}

// MARK: - Mood Tracking System

/// User's current mood/energy state
enum MoodState: String, CaseIterable, Codable, Identifiable {
    case energized = "energized"
    case focused = "focused"
    case calm = "calm"
    case tired = "tired"
    case stressed = "stressed"
    case motivated = "motivated"
    
    var id: String { rawValue }
    
    var emoji: String {
        switch self {
        case .energized: return "⚡️"
        case .focused: return "🎯"
        case .calm: return "🧘"
        case .tired: return "😴"
        case .stressed: return "😤"
        case .motivated: return "🔥"
        }
    }
    
    var label: String {
        switch self {
        case .energized: return "Energized"
        case .focused: return "Focused"
        case .calm: return "Calm"
        case .tired: return "Tired"
        case .stressed: return "Stressed"
        case .motivated: return "Motivated"
        }
    }
    
    var color: Color {
        switch self {
        case .energized: return BrandTheme.warning
        case .focused: return BrandTheme.mind
        case .calm: return BrandTheme.info
        case .tired: return BrandTheme.textTertiary
        case .stressed: return BrandTheme.error
        case .motivated: return BrandTheme.success
        }
    }
    
    var suggestedTaskType: String {
        switch self {
        case .energized: return "Take on challenging tasks"
        case .focused: return "Deep work and complex items"
        case .calm: return "Mindful activities and reflection"
        case .tired: return "Light, quick wins only"
        case .stressed: return "Calming activities, avoid heavy tasks"
        case .motivated: return "Big goals and ambitious items"
        }
    }
}

/// Tracks mood history and patterns for the quick mood tracker
struct QuickMoodEntry: Identifiable, Codable {
    let id: String
    let mood: MoodState
    let timestamp: Date
    let note: String?
    
    init(mood: MoodState, note: String? = nil) {
        self.id = UUID().uuidString
        self.mood = mood
        self.timestamp = Date()
        self.note = note
    }
}

@MainActor
final class MoodTracker: ObservableObject {
    @Published var currentMood: MoodState?
    @Published var moodHistory: [QuickMoodEntry] = []
    @Published var lastCheckIn: Date?
    
    private let storageKey = "lifeXP.moodHistory"
    private let calendar = Calendar.current
    
    init() {
        loadHistory()
    }
    
    func logMood(_ mood: MoodState, note: String? = nil) {
        currentMood = mood
        lastCheckIn = Date()
        
        let entry = QuickMoodEntry(mood: mood, note: note)
        moodHistory.insert(entry, at: 0)
        
        // Keep last 30 days
        if let cutoff = calendar.date(byAdding: .day, value: -30, to: Date()) {
            moodHistory = moodHistory.filter { $0.timestamp > cutoff }
        }
        
        saveHistory()
    }
    
    var shouldPromptCheckIn: Bool {
        guard let last = lastCheckIn else { return true }
        let hours = calendar.dateComponents([.hour], from: last, to: Date()).hour ?? 0
        return hours >= 4
    }
    
    var todaysMoods: [QuickMoodEntry] {
        let today = calendar.startOfDay(for: Date())
        return moodHistory.filter { calendar.startOfDay(for: $0.timestamp) == today }
    }
    
    var dominantMoodToday: MoodState? {
        let moods = todaysMoods.map { $0.mood }
        guard !moods.isEmpty else { return nil }
        
        let counts = Dictionary(grouping: moods, by: { $0 }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    var moodInsight: String {
        guard let dominant = dominantMoodToday else {
            return "Log your mood to get personalized insights"
        }
        
        switch dominant {
        case .energized:
            return "Great energy today! Perfect time for challenging tasks."
        case .focused:
            return "You're in the zone. Maximize this focus time!"
        case .calm:
            return "Peaceful vibes. Great for mindful activities."
        case .tired:
            return "Take it easy. Focus on rest and small wins."
        case .stressed:
            return "High stress detected. Consider calming activities."
        case .motivated:
            return "Motivation is high! Channel it into big goals."
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(moodHistory) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([QuickMoodEntry].self, from: data) {
            moodHistory = decoded
            currentMood = decoded.first?.mood
            lastCheckIn = decoded.first?.timestamp
        }
    }
}

// MARK: - Personal Goals System

/// A custom goal created by the user
struct PersonalGoal: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var targetDate: Date?
    var xpReward: Int
    var dimensions: [LifeDimension]
    var milestones: [Milestone]
    var isCompleted: Bool
    var completedDate: Date?
    var createdDate: Date
    var iconName: String
    var color: String // Hex color
    
    struct Milestone: Identifiable, Codable {
        let id: String
        var title: String
        var isCompleted: Bool
    }
    
    init(title: String, description: String = "", targetDate: Date? = nil, dimensions: [LifeDimension] = [], iconName: String = "star.fill", color: String = "6366F1") {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.xpReward = 50
        self.dimensions = dimensions
        self.milestones = []
        self.isCompleted = false
        self.completedDate = nil
        self.createdDate = Date()
        self.iconName = iconName
        self.color = color
    }
    
    var progress: Double {
        guard !milestones.isEmpty else { return isCompleted ? 1.0 : 0.0 }
        let completed = milestones.filter { $0.isCompleted }.count
        return Double(completed) / Double(milestones.count)
    }
    
    var daysRemaining: Int? {
        guard let target = targetDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
        return max(0, days)
    }
}

@MainActor
final class PersonalGoalsManager: ObservableObject {
    @Published var goals: [PersonalGoal] = []
    
    private let storageKey = "lifeXP.personalGoals"
    
    init() {
        loadGoals()
    }
    
    func addGoal(_ goal: PersonalGoal) {
        goals.insert(goal, at: 0)
        saveGoals()
    }
    
    func updateGoal(_ goal: PersonalGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(_ goal: PersonalGoal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }
    
    func completeGoal(_ goalID: String) {
        if let index = goals.firstIndex(where: { $0.id == goalID }) {
            goals[index].isCompleted = true
            goals[index].completedDate = Date()
            saveGoals()
        }
    }
    
    func toggleMilestone(_ goalID: String, milestoneID: String) {
        if let goalIndex = goals.firstIndex(where: { $0.id == goalID }),
           let milestoneIndex = goals[goalIndex].milestones.firstIndex(where: { $0.id == milestoneID }) {
            goals[goalIndex].milestones[milestoneIndex].isCompleted.toggle()
            
            // Auto-complete goal if all milestones done
            if goals[goalIndex].milestones.allSatisfy({ $0.isCompleted }) {
                goals[goalIndex].isCompleted = true
                goals[goalIndex].completedDate = Date()
            }
            
            saveGoals()
        }
    }
    
    var activeGoals: [PersonalGoal] {
        goals.filter { !$0.isCompleted }
    }
    
    var completedGoals: [PersonalGoal] {
        goals.filter { $0.isCompleted }
    }
    
    var urgentGoals: [PersonalGoal] {
        activeGoals.filter { goal in
            if let days = goal.daysRemaining, days <= 7 {
                return true
            }
            return false
        }
    }
    
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([PersonalGoal].self, from: data) {
            goals = decoded
        }
    }
}

// MARK: - Skill Tree System

/// Represents a skill node in the progression tree
struct SkillNode: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let iconSystemName: String
    let dimension: LifeDimension
    let tier: Int // 1-5, higher = more advanced
    let xpRequired: Int
    let prerequisiteIDs: [String]
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    var tierLabel: String {
        switch tier {
        case 1: return "Novice"
        case 2: return "Apprentice"
        case 3: return "Adept"
        case 4: return "Expert"
        case 5: return "Master"
        default: return "Unknown"
        }
    }
}

/// Manages skill tree progression
@MainActor
final class SkillTreeManager: ObservableObject {
    @Published var nodes: [SkillNode] = []
    
    private let storageKey = "lifeXP.skillTree"
    
    init() {
        initializeSkillTree()
        loadProgress()
    }
    
    private func initializeSkillTree() {
        // Love dimension skills
        let loveNodes = [
            SkillNode(id: "love_1", name: "Connector", description: "Begin building meaningful relationships", iconSystemName: "person.2.fill", dimension: .love, tier: 1, xpRequired: 30, prerequisiteIDs: [], isUnlocked: false),
            SkillNode(id: "love_2", name: "Communicator", description: "Express yourself authentically", iconSystemName: "bubble.left.and.bubble.right.fill", dimension: .love, tier: 2, xpRequired: 80, prerequisiteIDs: ["love_1"], isUnlocked: false),
            SkillNode(id: "love_3", name: "Empath", description: "Deep emotional understanding", iconSystemName: "heart.circle.fill", dimension: .love, tier: 3, xpRequired: 150, prerequisiteIDs: ["love_2"], isUnlocked: false),
            SkillNode(id: "love_4", name: "Nurturer", description: "Support others' growth", iconSystemName: "hands.sparkles.fill", dimension: .love, tier: 4, xpRequired: 250, prerequisiteIDs: ["love_3"], isUnlocked: false),
            SkillNode(id: "love_5", name: "Love Master", description: "Mastery of connection", iconSystemName: "heart.fill", dimension: .love, tier: 5, xpRequired: 400, prerequisiteIDs: ["love_4"], isUnlocked: false)
        ]
        
        // Money dimension skills
        let moneyNodes = [
            SkillNode(id: "money_1", name: "Saver", description: "Building financial awareness", iconSystemName: "dollarsign.circle.fill", dimension: .money, tier: 1, xpRequired: 30, prerequisiteIDs: [], isUnlocked: false),
            SkillNode(id: "money_2", name: "Budgeter", description: "Mastering money flow", iconSystemName: "chart.pie.fill", dimension: .money, tier: 2, xpRequired: 80, prerequisiteIDs: ["money_1"], isUnlocked: false),
            SkillNode(id: "money_3", name: "Investor", description: "Growing wealth strategically", iconSystemName: "chart.line.uptrend.xyaxis", dimension: .money, tier: 3, xpRequired: 150, prerequisiteIDs: ["money_2"], isUnlocked: false),
            SkillNode(id: "money_4", name: "Entrepreneur", description: "Creating value and opportunity", iconSystemName: "lightbulb.fill", dimension: .money, tier: 4, xpRequired: 250, prerequisiteIDs: ["money_3"], isUnlocked: false),
            SkillNode(id: "money_5", name: "Money Master", description: "Financial freedom achieved", iconSystemName: "banknote.fill", dimension: .money, tier: 5, xpRequired: 400, prerequisiteIDs: ["money_4"], isUnlocked: false)
        ]
        
        // Mind dimension skills
        let mindNodes = [
            SkillNode(id: "mind_1", name: "Learner", description: "Cultivating curiosity", iconSystemName: "book.fill", dimension: .mind, tier: 1, xpRequired: 30, prerequisiteIDs: [], isUnlocked: false),
            SkillNode(id: "mind_2", name: "Thinker", description: "Developing critical thought", iconSystemName: "brain.head.profile", dimension: .mind, tier: 2, xpRequired: 80, prerequisiteIDs: ["mind_1"], isUnlocked: false),
            SkillNode(id: "mind_3", name: "Mindful", description: "Present awareness mastery", iconSystemName: "leaf.fill", dimension: .mind, tier: 3, xpRequired: 150, prerequisiteIDs: ["mind_2"], isUnlocked: false),
            SkillNode(id: "mind_4", name: "Wise", description: "Deep wisdom and insight", iconSystemName: "sparkles", dimension: .mind, tier: 4, xpRequired: 250, prerequisiteIDs: ["mind_3"], isUnlocked: false),
            SkillNode(id: "mind_5", name: "Mind Master", description: "Mental mastery achieved", iconSystemName: "brain", dimension: .mind, tier: 5, xpRequired: 400, prerequisiteIDs: ["mind_4"], isUnlocked: false)
        ]
        
        // Adventure dimension skills
        let adventureNodes = [
            SkillNode(id: "adventure_1", name: "Explorer", description: "Stepping out of comfort zone", iconSystemName: "figure.walk", dimension: .adventure, tier: 1, xpRequired: 30, prerequisiteIDs: [], isUnlocked: false),
            SkillNode(id: "adventure_2", name: "Traveler", description: "Discovering new horizons", iconSystemName: "airplane", dimension: .adventure, tier: 2, xpRequired: 80, prerequisiteIDs: ["adventure_1"], isUnlocked: false),
            SkillNode(id: "adventure_3", name: "Adventurer", description: "Embracing the unknown", iconSystemName: "mountain.2.fill", dimension: .adventure, tier: 3, xpRequired: 150, prerequisiteIDs: ["adventure_2"], isUnlocked: false),
            SkillNode(id: "adventure_4", name: "Pioneer", description: "Blazing new trails", iconSystemName: "flag.fill", dimension: .adventure, tier: 4, xpRequired: 250, prerequisiteIDs: ["adventure_3"], isUnlocked: false),
            SkillNode(id: "adventure_5", name: "Adventure Master", description: "Life is your playground", iconSystemName: "safari.fill", dimension: .adventure, tier: 5, xpRequired: 400, prerequisiteIDs: ["adventure_4"], isUnlocked: false)
        ]
        
        nodes = loveNodes + moneyNodes + mindNodes + adventureNodes
    }
    
    func updateUnlocks(dimensionXP: [LifeDimension: Int]) {
        var changed = false
        
        for i in nodes.indices {
            guard !nodes[i].isUnlocked else { continue }
            
            let dimXP = dimensionXP[nodes[i].dimension] ?? 0
            let prereqsMet = nodes[i].prerequisiteIDs.allSatisfy { prereqID in
                nodes.first { $0.id == prereqID }?.isUnlocked ?? false
            }
            
            if dimXP >= nodes[i].xpRequired && prereqsMet {
                nodes[i].isUnlocked = true
                nodes[i].unlockedDate = Date()
                changed = true
            }
        }
        
        if changed {
            saveProgress()
        }
    }
    
    func nodesForDimension(_ dimension: LifeDimension) -> [SkillNode] {
        nodes.filter { $0.dimension == dimension }.sorted { $0.tier < $1.tier }
    }
    
    func nextUnlock(for dimension: LifeDimension, currentXP: Int) -> SkillNode? {
        nodesForDimension(dimension)
            .filter { !$0.isUnlocked }
            .first
    }
    
    var totalUnlocked: Int {
        nodes.filter { $0.isUnlocked }.count
    }
    
    var recentUnlocks: [SkillNode] {
        nodes.filter { $0.isUnlocked }
            .sorted { ($0.unlockedDate ?? .distantPast) > ($1.unlockedDate ?? .distantPast) }
            .prefix(3)
            .map { $0 }
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(nodes) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SkillNode].self, from: data) {
            // Merge loaded progress with initialized tree
            for loadedNode in decoded {
                if let index = nodes.firstIndex(where: { $0.id == loadedNode.id }) {
                    nodes[index].isUnlocked = loadedNode.isUnlocked
                    nodes[index].unlockedDate = loadedNode.unlockedDate
                }
            }
        }
    }
}

// MARK: - Weekly Review System

/// Summary of a week's progress
struct WeeklyReview: Identifiable, Codable {
    let id: String
    let weekStartDate: Date
    let weekEndDate: Date
    let totalXPEarned: Int
    let itemsCompleted: Int
    let questsCompleted: Int
    let dimensionBreakdown: [String: Int] // dimension rawValue: XP
    let streakMaintained: Bool
    let challengesCompleted: Int
    let moodSummary: [String: Int] // mood rawValue: count
    let highlightBadge: String? // badge ID if earned
    let insight: String
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: weekStartDate)) - \(formatter.string(from: weekEndDate))"
    }
}

@MainActor
final class WeeklyReviewManager: ObservableObject {
    @Published var reviews: [WeeklyReview] = []
    @Published var currentWeekProgress: WeeklyProgress = WeeklyProgress()
    
    private let storageKey = "lifeXP.weeklyReviews"
    private let progressKey = "lifeXP.weeklyProgress"
    private let calendar = Calendar.current
    
    struct WeeklyProgress: Codable {
        var xpEarned: Int = 0
        var itemsCompleted: Int = 0
        var questsCompleted: Int = 0
        var dimensionXP: [String: Int] = [:]
        var moodLogs: [String: Int] = [:]
        var weekStartDate: Date?
    }
    
    init() {
        loadReviews()
        loadCurrentProgress()
        checkForNewWeek()
    }
    
    func logCompletion(xp: Int, dimensions: [LifeDimension], isQuest: Bool) {
        currentWeekProgress.xpEarned += xp
        
        if isQuest {
            currentWeekProgress.questsCompleted += 1
        } else {
            currentWeekProgress.itemsCompleted += 1
        }
        
        for dim in dimensions {
            let current = currentWeekProgress.dimensionXP[dim.rawValue] ?? 0
            currentWeekProgress.dimensionXP[dim.rawValue] = current + xp
        }
        
        saveCurrentProgress()
    }
    
    func logMood(_ mood: MoodState) {
        let current = currentWeekProgress.moodLogs[mood.rawValue] ?? 0
        currentWeekProgress.moodLogs[mood.rawValue] = current + 1
        saveCurrentProgress()
    }
    
    private func checkForNewWeek() {
        let today = Date()
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return
        }
        
        if let lastStart = currentWeekProgress.weekStartDate,
           let lastWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: lastStart)) {
            
            if lastWeekStart < startOfWeek {
                // Generate review for last week
                generateReview(for: lastWeekStart)
                
                // Reset progress
                currentWeekProgress = WeeklyProgress()
                currentWeekProgress.weekStartDate = startOfWeek
            }
        } else {
            currentWeekProgress.weekStartDate = startOfWeek
        }
        
        saveCurrentProgress()
    }
    
    private func generateReview(for weekStart: Date) {
        guard let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else {
            return
        }
        
        let insight = generateInsight()
        
        let review = WeeklyReview(
            id: UUID().uuidString,
            weekStartDate: weekStart,
            weekEndDate: weekEnd,
            totalXPEarned: currentWeekProgress.xpEarned,
            itemsCompleted: currentWeekProgress.itemsCompleted,
            questsCompleted: currentWeekProgress.questsCompleted,
            dimensionBreakdown: currentWeekProgress.dimensionXP,
            streakMaintained: currentWeekProgress.itemsCompleted > 0,
            challengesCompleted: 0, // Would need challenge data
            moodSummary: currentWeekProgress.moodLogs,
            highlightBadge: nil,
            insight: insight
        )
        
        reviews.insert(review, at: 0)
        
        // Keep last 12 weeks
        if reviews.count > 12 {
            reviews = Array(reviews.prefix(12))
        }
        
        saveReviews()
    }
    
    private func generateInsight() -> String {
        let xp = currentWeekProgress.xpEarned
        let items = currentWeekProgress.itemsCompleted
        
        if xp > 200 {
            return "Incredible week! You're making serious progress on your life goals."
        } else if xp > 100 {
            return "Great momentum this week. Keep building on this foundation."
        } else if items > 0 {
            return "You showed up this week. Consistency is key to growth."
        } else {
            return "Every week is a fresh start. What will you achieve next?"
        }
    }
    
    var latestReview: WeeklyReview? {
        reviews.first
    }
    
    var averageWeeklyXP: Int {
        guard !reviews.isEmpty else { return 0 }
        return reviews.reduce(0) { $0 + $1.totalXPEarned } / reviews.count
    }
    
    private func saveReviews() {
        if let encoded = try? JSONEncoder().encode(reviews) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadReviews() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([WeeklyReview].self, from: data) {
            reviews = decoded
        }
    }
    
    private func saveCurrentProgress() {
        if let encoded = try? JSONEncoder().encode(currentWeekProgress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }
    
    private func loadCurrentProgress() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(WeeklyProgress.self, from: data) {
            currentWeekProgress = decoded
        }
    }
}

// MARK: - Seasonal Events System

/// Represents a time-limited seasonal event
struct SeasonalEvent: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let iconSystemName: String
    let themeColor: String
    let startDate: Date
    let endDate: Date
    let bonusMultiplier: Double
    let specialBadgeID: String?
    let featuredDimension: LifeDimension?
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    var daysRemaining: Int {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        return max(0, days)
    }
    
    var progress: Double {
        let total = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(1.0, max(0, elapsed / total))
    }
}

/// Manages seasonal events
@MainActor
final class SeasonalEventManager: ObservableObject {
    @Published var events: [SeasonalEvent] = []
    
    init() {
        loadEvents()
    }
    
    private func loadEvents() {
        let calendar = Calendar.current
        let now = Date()
        
        // Generate dynamic events based on real dates
        let year = calendar.component(.year, from: now)
        
        // New Year Reset (January)
        if let janStart = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
           let janEnd = calendar.date(from: DateComponents(year: year, month: 1, day: 14)) {
            events.append(SeasonalEvent(
                id: "new_year_\(year)",
                name: "New Year Reset",
                description: "Fresh start energy! Double XP on all Mind activities",
                iconSystemName: "sparkles",
                themeColor: "6366F1",
                startDate: janStart,
                endDate: janEnd,
                bonusMultiplier: 2.0,
                specialBadgeID: "badge_new_year",
                featuredDimension: .mind
            ))
        }
        
        // Valentine's Season (February)
        if let febStart = calendar.date(from: DateComponents(year: year, month: 2, day: 7)),
           let febEnd = calendar.date(from: DateComponents(year: year, month: 2, day: 21)) {
            events.append(SeasonalEvent(
                id: "valentine_\(year)",
                name: "Connection Season",
                description: "Celebrate relationships! Bonus XP on Love dimension",
                iconSystemName: "heart.fill",
                themeColor: "EC4899",
                startDate: febStart,
                endDate: febEnd,
                bonusMultiplier: 1.5,
                specialBadgeID: "badge_valentine",
                featuredDimension: .love
            ))
        }
        
        // Summer Adventure (July-August)
        if let summerStart = calendar.date(from: DateComponents(year: year, month: 7, day: 1)),
           let summerEnd = calendar.date(from: DateComponents(year: year, month: 8, day: 31)) {
            events.append(SeasonalEvent(
                id: "summer_\(year)",
                name: "Summer Adventure",
                description: "Adventure awaits! Explore and earn bonus XP",
                iconSystemName: "sun.max.fill",
                themeColor: "F59E0B",
                startDate: summerStart,
                endDate: summerEnd,
                bonusMultiplier: 1.5,
                specialBadgeID: "badge_summer_adventure",
                featuredDimension: .adventure
            ))
        }
        
        // Year End Review (December)
        if let decStart = calendar.date(from: DateComponents(year: year, month: 12, day: 15)),
           let decEnd = calendar.date(from: DateComponents(year: year, month: 12, day: 31)) {
            events.append(SeasonalEvent(
                id: "year_end_\(year)",
                name: "Year in Review",
                description: "Reflect on your growth and earn completion bonuses",
                iconSystemName: "calendar.badge.checkmark",
                themeColor: "10B981",
                startDate: decStart,
                endDate: decEnd,
                bonusMultiplier: 1.75,
                specialBadgeID: "badge_year_wrapped",
                featuredDimension: nil
            ))
        }
    }
    
    var activeEvents: [SeasonalEvent] {
        events.filter { $0.isActive }
    }
    
    var currentEvent: SeasonalEvent? {
        activeEvents.first
    }
    
    func bonusMultiplier(for dimension: LifeDimension?) -> Double {
        for event in activeEvents {
            if event.featuredDimension == dimension || event.featuredDimension == nil {
                return event.bonusMultiplier
            }
        }
        return 1.0
    }
}

// MARK: - Time of Day Theme

/// Represents the current time of day for dynamic theming
enum TimeOfDay: String, CaseIterable {
    case earlyMorning = "early_morning"  // 5-7
    case morning = "morning"              // 7-12
    case afternoon = "afternoon"          // 12-17
    case evening = "evening"              // 17-20
    case night = "night"                  // 20-24
    case lateNight = "late_night"         // 0-5
    
    static var current: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<7: return .earlyMorning
        case 7..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<20: return .evening
        case 20..<24: return .night
        default: return .lateNight
        }
    }
    
    var greeting: String {
        switch self {
        case .earlyMorning: return "Early bird! 🌅"
        case .morning: return "Good morning! ☀️"
        case .afternoon: return "Good afternoon! 🌤️"
        case .evening: return "Good evening! 🌆"
        case .night: return "Good night! 🌙"
        case .lateNight: return "Night owl! 🦉"
        }
    }
    
    var suggestion: String {
        switch self {
        case .earlyMorning:
            return "Perfect time for meditation or planning"
        case .morning:
            return "High energy time - tackle challenging tasks"
        case .afternoon:
            return "Maintain momentum with focused work"
        case .evening:
            return "Wind down with reflection or light tasks"
        case .night:
            return "Rest is important - consider wrapping up"
        case .lateNight:
            return "Night sessions can be productive, but rest too"
        }
    }
    
    var accentColorAdjustment: Color {
        switch self {
        case .earlyMorning: return Color(hex: "F97316", default: .orange) // Warm orange
        case .morning: return Color(hex: "FBBF24", default: .yellow) // Sunny yellow
        case .afternoon: return Color(hex: "3B82F6", default: .blue) // Clear blue
        case .evening: return Color(hex: "8B5CF6", default: .purple) // Purple sunset
        case .night: return Color(hex: "6366F1", default: .indigo) // Deep indigo
        case .lateNight: return Color(hex: "1E1B4B", default: .black) // Midnight
        }
    }
    
    var backgroundIntensity: Double {
        switch self {
        case .earlyMorning: return 0.6
        case .morning: return 0.8
        case .afternoon: return 1.0
        case .evening: return 0.7
        case .night: return 0.5
        case .lateNight: return 0.3
        }
    }
}

// MARK: - Sound Effects Manager

/// Manages app sound effects.
enum SoundEffect: String {
    case complete = "complete"
    case levelUp = "level_up"
    case badgeUnlock = "badge_unlock"
    case comboIncrease = "combo"
    case streak = "streak"
    case celebration = "celebration"
    case tap = "tap"
    case swipe = "swipe"
}

@MainActor
final class SoundManager: ObservableObject {
    @Published var soundEnabled: Bool = true
    @Published var volume: Float = 0.7
    
    private let enabledKey = "lifeXP.soundSettings.enabled"
    private let volumeKey = "lifeXP.soundSettings.volume"
#if canImport(AVFoundation)
    private var audioPlayers: [SoundEffect: AVAudioPlayer] = [:]
    private var audioSessionConfigured = false
#endif
    
    init() {
        loadSettings()
    }
    
    func play(_ effect: SoundEffect) {
        guard soundEnabled else { return }
#if canImport(AVFoundation)
        configureAudioSessionIfNeeded()
        guard let player = player(for: effect) else { return }
        player.volume = max(0, min(1, volume))
        player.play()
#endif
    }
    
    private func loadSettings() {
        // Check if the key exists before reading, otherwise use default (true)
        if UserDefaults.standard.object(forKey: enabledKey) != nil {
            soundEnabled = UserDefaults.standard.bool(forKey: enabledKey)
        } else {
            soundEnabled = true // Default to enabled
        }
        
        let storedVolume = UserDefaults.standard.float(forKey: volumeKey)
        volume = storedVolume > 0 ? storedVolume : 0.7 // Default to 0.7 if not set
    }
    
    func saveSettings() {
        UserDefaults.standard.set(soundEnabled, forKey: enabledKey)
        UserDefaults.standard.set(volume, forKey: volumeKey)
    }

#if canImport(AVFoundation)
    private func configureAudioSessionIfNeeded() {
        guard !audioSessionConfigured else { return }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, options: [.mixWithOthers])
            try session.setActive(true)
            audioSessionConfigured = true
        } catch {
            audioSessionConfigured = false
        }
    }

    private func player(for effect: SoundEffect) -> AVAudioPlayer? {
        if let cached = audioPlayers[effect] {
            return cached
        }

        let tone = toneProfile(for: effect)
        let data = Self.makeToneWavData(
            frequency: tone.frequency,
            duration: tone.duration,
            sampleRate: 44_100
        )

        do {
            let player = try AVAudioPlayer(data: data)
            player.prepareToPlay()
            audioPlayers[effect] = player
            return player
        } catch {
            return nil
        }
    }

    private func toneProfile(for effect: SoundEffect) -> (frequency: Double, duration: Double) {
        switch effect {
        case .complete:
            return (880, 0.12)
        case .levelUp:
            return (1320, 0.2)
        case .badgeUnlock:
            return (1046, 0.18)
        case .comboIncrease:
            return (740, 0.12)
        case .streak:
            return (988, 0.16)
        case .celebration:
            return (1200, 0.22)
        case .tap:
            return (600, 0.06)
        case .swipe:
            return (520, 0.08)
        }
    }

    private static func makeToneWavData(
        frequency: Double,
        duration: Double,
        sampleRate: Double
    ) -> Data {
        let totalSamples = Int(duration * sampleRate)
        let amplitude = 0.25
        var samples = [Int16](repeating: 0, count: totalSamples)

        for index in 0..<totalSamples {
            let time = Double(index) / sampleRate
            let sample = sin(2.0 * Double.pi * frequency * time) * amplitude
            samples[index] = Int16(sample * Double(Int16.max))
        }

        var data = Data()
        let byteRate = Int(sampleRate) * 2
        let blockAlign: UInt16 = 2
        let bitsPerSample: UInt16 = 16
        let subchunk2Size = totalSamples * 2
        let chunkSize = 36 + subchunk2Size

        data.append("RIFF".data(using: .ascii) ?? Data())
        data.append(Self.leData(UInt32(chunkSize)))
        data.append("WAVE".data(using: .ascii) ?? Data())
        data.append("fmt ".data(using: .ascii) ?? Data())
        data.append(Self.leData(UInt32(16)))
        data.append(Self.leData(UInt16(1)))
        data.append(Self.leData(UInt16(1)))
        data.append(Self.leData(UInt32(sampleRate)))
        data.append(Self.leData(UInt32(byteRate)))
        data.append(Self.leData(blockAlign))
        data.append(Self.leData(bitsPerSample))
        data.append("data".data(using: .ascii) ?? Data())
        data.append(Self.leData(UInt32(subchunk2Size)))

        samples.withUnsafeBufferPointer { buffer in
            data.append(buffer.baseAddress!, count: buffer.count * MemoryLayout<Int16>.size)
        }

        return data
    }

    private static func leData(_ value: UInt16) -> Data {
        var littleEndian = value.littleEndian
        return Data(bytes: &littleEndian, count: MemoryLayout<UInt16>.size)
    }

    private static func leData(_ value: UInt32) -> Data {
        var littleEndian = value.littleEndian
        return Data(bytes: &littleEndian, count: MemoryLayout<UInt32>.size)
    }
#endif
}

// MARK: - Smart Insights Engine

/// Analyzes user patterns and provides personalized insights
@MainActor
final class InsightsEngine: ObservableObject {
    @Published var insights: [Insight] = []
    
    struct Insight: Identifiable {
        let id = UUID()
        let type: InsightType
        let title: String
        let message: String
        let iconSystemName: String
        let color: Color
        let actionLabel: String?
        let priority: Int // 1-5, higher = more important
    }
    
    enum InsightType {
        case streak
        case dimension
        case pattern
        case motivation
        case achievement
        case suggestion
    }
    
    func generateInsights(
        totalXP: Int,
        streak: Int,
        dimensionRatios: [(LifeDimension, Double)],
        completedToday: Int,
        recentCompletions: [Date]
    ) {
        var newInsights: [Insight] = []
        
        // Streak insights
        if streak == 0 {
            newInsights.append(Insight(
                type: .streak,
                title: "Start a streak!",
                message: "Complete one item today to begin your consistency journey",
                iconSystemName: "flame",
                color: BrandTheme.error,
                actionLabel: "Find a quick win",
                priority: 4
            ))
        } else if streak == 6 {
            newInsights.append(Insight(
                type: .streak,
                title: "One day to weekly streak!",
                message: "Complete something tomorrow to hit 7 days straight",
                iconSystemName: "flame.fill",
                color: BrandTheme.warning,
                actionLabel: nil,
                priority: 5
            ))
        } else if streak >= 7 && streak % 7 == 0 {
            newInsights.append(Insight(
                type: .achievement,
                title: "\(streak) day streak!",
                message: "You've maintained consistency for \(streak / 7) week(s). Incredible!",
                iconSystemName: "trophy.fill",
                color: BrandTheme.success,
                actionLabel: nil,
                priority: 5
            ))
        }
        
        // Dimension balance insights
        if let (weakDim, ratio) = dimensionRatios.min(by: { $0.1 < $1.1 }),
           let (_, strongRatio) = dimensionRatios.max(by: { $0.1 < $1.1 }) {
            
            if strongRatio > 0 && ratio < strongRatio * 0.5 {
                newInsights.append(Insight(
                    type: .dimension,
                    title: "\(weakDim.label) needs attention",
                    message: "Your \(weakDim.label.lowercased()) progress is lagging behind. Balance is key!",
                    iconSystemName: weakDim.iconSystemName,
                    color: BrandTheme.dimensionColor(weakDim),
                    actionLabel: "Find \(weakDim.label.lowercased()) items",
                    priority: 3
                ))
            }
        }
        
        // Time-based patterns
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 21 && completedToday == 0 {
            newInsights.append(Insight(
                type: .motivation,
                title: "Still time today",
                message: "A quick win before bed keeps the momentum going",
                iconSystemName: "moon.stars.fill",
                color: BrandTheme.mind,
                actionLabel: "Quick task",
                priority: 4
            ))
        }
        
        // Activity patterns
        if recentCompletions.count >= 5 {
            let hours = recentCompletions.map { Calendar.current.component(.hour, from: $0) }
            let avgHour = hours.reduce(0, +) / hours.count
            
            let timePhrase: String
            switch avgHour {
            case 5..<9: timePhrase = "early mornings"
            case 9..<12: timePhrase = "mid-mornings"
            case 12..<14: timePhrase = "around lunch"
            case 14..<17: timePhrase = "afternoons"
            case 17..<20: timePhrase = "evenings"
            default: timePhrase = "late nights"
            }
            
            newInsights.append(Insight(
                type: .pattern,
                title: "You're most active \(timePhrase)",
                message: "Schedule important tasks for when you're naturally productive",
                iconSystemName: "clock.fill",
                color: BrandTheme.info,
                actionLabel: nil,
                priority: 2
            ))
        }
        
        // Level milestone insights
        let level = totalXP / 120 + 1
        let xpToNext = level * 120 - totalXP
        
        if xpToNext <= 30 {
            newInsights.append(Insight(
                type: .achievement,
                title: "Level \(level + 1) is close!",
                message: "Just \(xpToNext) XP away from your next level",
                iconSystemName: "arrow.up.circle.fill",
                color: BrandTheme.accent,
                actionLabel: "Level up now",
                priority: 4
            ))
        }
        
        // Sort by priority
        insights = newInsights.sorted { $0.priority > $1.priority }
    }
    
    var topInsight: Insight? {
        insights.first
    }
}
