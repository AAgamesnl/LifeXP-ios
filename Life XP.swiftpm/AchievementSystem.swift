import SwiftUI
import Foundation

// MARK: - Achievement System with Trophy Case
// A comprehensive achievement and trophy system to celebrate user accomplishments

// MARK: - Models

/// Represents an achievement category
enum AchievementCategory: String, Codable, CaseIterable, Identifiable {
    case progress = "progress"
    case streak = "streak"
    case dimension = "dimension"
    case exploration = "exploration"
    case mastery = "mastery"
    case social = "social"
    case special = "special"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .progress: return "Progress"
        case .streak: return "Streaks"
        case .dimension: return "Dimensions"
        case .exploration: return "Exploration"
        case .mastery: return "Mastery"
        case .social: return "Social"
        case .special: return "Special"
        }
    }
    
    var iconSystemName: String {
        switch self {
        case .progress: return "chart.line.uptrend.xyaxis"
        case .streak: return "flame.fill"
        case .dimension: return "cube.fill"
        case .exploration: return "map.fill"
        case .mastery: return "crown.fill"
        case .social: return "person.3.fill"
        case .special: return "sparkles"
        }
    }
    
    var color: Color {
        switch self {
        case .progress: return .blue
        case .streak: return .orange
        case .dimension: return .purple
        case .exploration: return .green
        case .mastery: return .yellow
        case .social: return .pink
        case .special: return .mint
        }
    }
}

/// Represents a trophy tier/rarity
enum TrophyTier: String, Codable, CaseIterable, Comparable {
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    case platinum = "platinum"
    case diamond = "diamond"
    
    var label: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .platinum: return Color(red: 0.9, green: 0.9, blue: 1.0)
        case .diamond: return Color(red: 0.7, green: 0.9, blue: 1.0)
        }
    }
    
    var xpMultiplier: Double {
        switch self {
        case .bronze: return 1.0
        case .silver: return 1.5
        case .gold: return 2.0
        case .platinum: return 3.0
        case .diamond: return 5.0
        }
    }
    
    static func < (lhs: TrophyTier, rhs: TrophyTier) -> Bool {
        let order: [TrophyTier] = [.bronze, .silver, .gold, .platinum, .diamond]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

/// Represents an achievement definition
struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconSystemName: String
    let category: AchievementCategory
    let tier: TrophyTier
    let requirement: AchievementRequirement
    let xpReward: Int
    let isSecret: Bool
    
    init(
        id: String,
        title: String,
        description: String,
        iconSystemName: String,
        category: AchievementCategory,
        tier: TrophyTier,
        requirement: AchievementRequirement,
        xpReward: Int = 0,
        isSecret: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconSystemName = iconSystemName
        self.category = category
        self.tier = tier
        self.requirement = requirement
        self.xpReward = xpReward > 0 ? xpReward : Self.calculateXP(tier: tier, category: category)
        self.isSecret = isSecret
    }
    
    private static func calculateXP(tier: TrophyTier, category: AchievementCategory) -> Int {
        let baseXP: Int = switch category {
        case .progress: 25
        case .streak: 30
        case .dimension: 20
        case .exploration: 15
        case .mastery: 50
        case .social: 20
        case .special: 100
        }
        return Int(Double(baseXP) * tier.xpMultiplier)
    }
}

/// Defines achievement unlock requirements
struct AchievementRequirement: Codable {
    let type: RequirementType
    let threshold: Int
    let dimension: LifeDimension?
    let specificIDs: [String]?
    
    enum RequirementType: String, Codable {
        case totalXP
        case level
        case streak
        case completedItems
        case completedInDimension
        case completedArcs
        case completedQuests
        case daysActive
        case habitsCompleted
        case journalEntries
        case focusSessions
        case perfectDays // Days with 100% completion
        case uniqueDimensions // Working on all dimensions
        case specificItems // Specific item IDs
    }
    
    init(type: RequirementType, threshold: Int, dimension: LifeDimension? = nil, specificIDs: [String]? = nil) {
        self.type = type
        self.threshold = threshold
        self.dimension = dimension
        self.specificIDs = specificIDs
    }
}

/// Represents an unlocked achievement
struct UnlockedAchievement: Identifiable, Codable {
    let id: String
    let achievementID: String
    let unlockedAt: Date
    let xpAwarded: Int
    let wasNotified: Bool
    
    init(achievementID: String, unlockedAt: Date = Date(), xpAwarded: Int, wasNotified: Bool = false) {
        self.id = UUID().uuidString
        self.achievementID = achievementID
        self.unlockedAt = unlockedAt
        self.xpAwarded = xpAwarded
        self.wasNotified = wasNotified
    }
}

/// Achievement progress tracking
struct AchievementProgress: Identifiable, Codable {
    let id: String
    var currentValue: Int
    var lastUpdated: Date
    
    var progressRatio: Double {
        guard let achievement = AchievementLibrary.achievement(id) else { return 0 }
        return min(1.0, Double(currentValue) / Double(achievement.requirement.threshold))
    }
}

// MARK: - Achievement Library

/// Contains all achievement definitions
struct AchievementLibrary {
    static let allAchievements: [Achievement] = [
        // MARK: Progress Achievements
        Achievement(
            id: "first_step",
            title: "First Step",
            description: "Complete your first item",
            iconSystemName: "foot.fill",
            category: .progress,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedItems, threshold: 1)
        ),
        Achievement(
            id: "getting_started",
            title: "Getting Started",
            description: "Complete 10 items",
            iconSystemName: "flag.fill",
            category: .progress,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedItems, threshold: 10)
        ),
        Achievement(
            id: "making_progress",
            title: "Making Progress",
            description: "Complete 25 items",
            iconSystemName: "arrow.up.right",
            category: .progress,
            tier: .silver,
            requirement: AchievementRequirement(type: .completedItems, threshold: 25)
        ),
        Achievement(
            id: "halfway_hero",
            title: "Halfway Hero",
            description: "Complete 50 items",
            iconSystemName: "person.fill.checkmark",
            category: .progress,
            tier: .silver,
            requirement: AchievementRequirement(type: .completedItems, threshold: 50)
        ),
        Achievement(
            id: "century_club",
            title: "Century Club",
            description: "Complete 100 items",
            iconSystemName: "100.circle.fill",
            category: .progress,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedItems, threshold: 100)
        ),
        Achievement(
            id: "life_transformer",
            title: "Life Transformer",
            description: "Complete 250 items",
            iconSystemName: "sparkles",
            category: .progress,
            tier: .platinum,
            requirement: AchievementRequirement(type: .completedItems, threshold: 250)
        ),
        Achievement(
            id: "legend",
            title: "Legend",
            description: "Complete 500 items",
            iconSystemName: "crown.fill",
            category: .progress,
            tier: .diamond,
            requirement: AchievementRequirement(type: .completedItems, threshold: 500)
        ),
        
        // MARK: XP Achievements
        Achievement(
            id: "xp_starter",
            title: "XP Starter",
            description: "Earn 100 XP",
            iconSystemName: "star.fill",
            category: .progress,
            tier: .bronze,
            requirement: AchievementRequirement(type: .totalXP, threshold: 100)
        ),
        Achievement(
            id: "xp_collector",
            title: "XP Collector",
            description: "Earn 500 XP",
            iconSystemName: "star.circle.fill",
            category: .progress,
            tier: .silver,
            requirement: AchievementRequirement(type: .totalXP, threshold: 500)
        ),
        Achievement(
            id: "xp_hoarder",
            title: "XP Hoarder",
            description: "Earn 1,000 XP",
            iconSystemName: "star.square.fill",
            category: .progress,
            tier: .gold,
            requirement: AchievementRequirement(type: .totalXP, threshold: 1000)
        ),
        Achievement(
            id: "xp_master",
            title: "XP Master",
            description: "Earn 5,000 XP",
            iconSystemName: "star.leadinghalf.filled",
            category: .progress,
            tier: .platinum,
            requirement: AchievementRequirement(type: .totalXP, threshold: 5000)
        ),
        Achievement(
            id: "xp_legend",
            title: "XP Legend",
            description: "Earn 10,000 XP",
            iconSystemName: "burst.fill",
            category: .progress,
            tier: .diamond,
            requirement: AchievementRequirement(type: .totalXP, threshold: 10000)
        ),
        
        // MARK: Level Achievements
        Achievement(
            id: "level_5",
            title: "Rising Star",
            description: "Reach Level 5",
            iconSystemName: "5.circle.fill",
            category: .progress,
            tier: .bronze,
            requirement: AchievementRequirement(type: .level, threshold: 5)
        ),
        Achievement(
            id: "level_10",
            title: "Double Digits",
            description: "Reach Level 10",
            iconSystemName: "10.circle.fill",
            category: .progress,
            tier: .silver,
            requirement: AchievementRequirement(type: .level, threshold: 10)
        ),
        Achievement(
            id: "level_25",
            title: "Quarter Century",
            description: "Reach Level 25",
            iconSystemName: "25.circle.fill",
            category: .progress,
            tier: .gold,
            requirement: AchievementRequirement(type: .level, threshold: 25)
        ),
        Achievement(
            id: "level_50",
            title: "Half Century",
            description: "Reach Level 50",
            iconSystemName: "50.circle.fill",
            category: .progress,
            tier: .platinum,
            requirement: AchievementRequirement(type: .level, threshold: 50)
        ),
        
        // MARK: Streak Achievements
        Achievement(
            id: "streak_3",
            title: "On Fire",
            description: "Maintain a 3-day streak",
            iconSystemName: "flame.fill",
            category: .streak,
            tier: .bronze,
            requirement: AchievementRequirement(type: .streak, threshold: 3)
        ),
        Achievement(
            id: "streak_7",
            title: "Week Warrior",
            description: "Maintain a 7-day streak",
            iconSystemName: "calendar",
            category: .streak,
            tier: .silver,
            requirement: AchievementRequirement(type: .streak, threshold: 7)
        ),
        Achievement(
            id: "streak_14",
            title: "Fortnight Fighter",
            description: "Maintain a 14-day streak",
            iconSystemName: "calendar.badge.clock",
            category: .streak,
            tier: .silver,
            requirement: AchievementRequirement(type: .streak, threshold: 14)
        ),
        Achievement(
            id: "streak_30",
            title: "Month Master",
            description: "Maintain a 30-day streak",
            iconSystemName: "flame.circle.fill",
            category: .streak,
            tier: .gold,
            requirement: AchievementRequirement(type: .streak, threshold: 30)
        ),
        Achievement(
            id: "streak_60",
            title: "Iron Will",
            description: "Maintain a 60-day streak",
            iconSystemName: "bolt.shield.fill",
            category: .streak,
            tier: .platinum,
            requirement: AchievementRequirement(type: .streak, threshold: 60)
        ),
        Achievement(
            id: "streak_100",
            title: "Unstoppable",
            description: "Maintain a 100-day streak",
            iconSystemName: "trophy.fill",
            category: .streak,
            tier: .diamond,
            requirement: AchievementRequirement(type: .streak, threshold: 100)
        ),
        
        // MARK: Dimension Achievements
        Achievement(
            id: "love_starter",
            title: "Heart Opener",
            description: "Complete 10 Love items",
            iconSystemName: "heart.fill",
            category: .dimension,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 10, dimension: .love)
        ),
        Achievement(
            id: "love_master",
            title: "Love Expert",
            description: "Complete 50 Love items",
            iconSystemName: "heart.circle.fill",
            category: .dimension,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 50, dimension: .love)
        ),
        Achievement(
            id: "money_starter",
            title: "Wealth Builder",
            description: "Complete 10 Money items",
            iconSystemName: "dollarsign.circle.fill",
            category: .dimension,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 10, dimension: .money)
        ),
        Achievement(
            id: "money_master",
            title: "Financial Guru",
            description: "Complete 50 Money items",
            iconSystemName: "banknote.fill",
            category: .dimension,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 50, dimension: .money)
        ),
        Achievement(
            id: "mind_starter",
            title: "Mind Expander",
            description: "Complete 10 Mind items",
            iconSystemName: "brain.head.profile",
            category: .dimension,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 10, dimension: .mind)
        ),
        Achievement(
            id: "mind_master",
            title: "Mental Master",
            description: "Complete 50 Mind items",
            iconSystemName: "brain.fill",
            category: .dimension,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 50, dimension: .mind)
        ),
        Achievement(
            id: "adventure_starter",
            title: "Explorer",
            description: "Complete 10 Adventure items",
            iconSystemName: "figure.hiking",
            category: .dimension,
            tier: .bronze,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 10, dimension: .adventure)
        ),
        Achievement(
            id: "adventure_master",
            title: "Adventure King",
            description: "Complete 50 Adventure items",
            iconSystemName: "mountain.2.fill",
            category: .dimension,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedInDimension, threshold: 50, dimension: .adventure)
        ),
        
        // MARK: Balance Achievement
        Achievement(
            id: "balanced_life",
            title: "Balanced Life",
            description: "Complete items in all 4 dimensions in one day",
            iconSystemName: "circle.grid.2x2.fill",
            category: .dimension,
            tier: .gold,
            requirement: AchievementRequirement(type: .uniqueDimensions, threshold: 4)
        ),
        
        // MARK: Exploration Achievements
        Achievement(
            id: "arc_beginner",
            title: "Journey Begins",
            description: "Complete your first arc",
            iconSystemName: "book.fill",
            category: .exploration,
            tier: .silver,
            requirement: AchievementRequirement(type: .completedArcs, threshold: 1)
        ),
        Achievement(
            id: "arc_explorer",
            title: "Arc Explorer",
            description: "Complete 3 arcs",
            iconSystemName: "books.vertical.fill",
            category: .exploration,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedArcs, threshold: 3)
        ),
        Achievement(
            id: "quest_starter",
            title: "Quest Seeker",
            description: "Complete 10 quests",
            iconSystemName: "scroll.fill",
            category: .exploration,
            tier: .silver,
            requirement: AchievementRequirement(type: .completedQuests, threshold: 10)
        ),
        Achievement(
            id: "quest_master",
            title: "Quest Master",
            description: "Complete 50 quests",
            iconSystemName: "map.fill",
            category: .exploration,
            tier: .gold,
            requirement: AchievementRequirement(type: .completedQuests, threshold: 50)
        ),
        
        // MARK: Mastery Achievements
        Achievement(
            id: "habit_former",
            title: "Habit Former",
            description: "Complete 50 habit check-ins",
            iconSystemName: "repeat.circle.fill",
            category: .mastery,
            tier: .silver,
            requirement: AchievementRequirement(type: .habitsCompleted, threshold: 50)
        ),
        Achievement(
            id: "habit_master",
            title: "Habit Master",
            description: "Complete 200 habit check-ins",
            iconSystemName: "repeat.1.circle.fill",
            category: .mastery,
            tier: .gold,
            requirement: AchievementRequirement(type: .habitsCompleted, threshold: 200)
        ),
        Achievement(
            id: "journal_writer",
            title: "Journal Writer",
            description: "Write 10 journal entries",
            iconSystemName: "book.closed.fill",
            category: .mastery,
            tier: .bronze,
            requirement: AchievementRequirement(type: .journalEntries, threshold: 10)
        ),
        Achievement(
            id: "journal_master",
            title: "Journal Master",
            description: "Write 50 journal entries",
            iconSystemName: "text.book.closed.fill",
            category: .mastery,
            tier: .gold,
            requirement: AchievementRequirement(type: .journalEntries, threshold: 50)
        ),
        Achievement(
            id: "focus_initiate",
            title: "Focus Initiate",
            description: "Complete 10 focus sessions",
            iconSystemName: "timer",
            category: .mastery,
            tier: .bronze,
            requirement: AchievementRequirement(type: .focusSessions, threshold: 10)
        ),
        Achievement(
            id: "focus_master",
            title: "Deep Focus Master",
            description: "Complete 100 focus sessions",
            iconSystemName: "hourglass.circle.fill",
            category: .mastery,
            tier: .gold,
            requirement: AchievementRequirement(type: .focusSessions, threshold: 100)
        ),
        Achievement(
            id: "perfect_day",
            title: "Perfect Day",
            description: "Complete all daily tasks",
            iconSystemName: "checkmark.seal.fill",
            category: .mastery,
            tier: .silver,
            requirement: AchievementRequirement(type: .perfectDays, threshold: 1)
        ),
        Achievement(
            id: "perfect_week",
            title: "Perfect Week",
            description: "Have 7 perfect days",
            iconSystemName: "seal.fill",
            category: .mastery,
            tier: .platinum,
            requirement: AchievementRequirement(type: .perfectDays, threshold: 7)
        ),
        
        // MARK: Special Achievements
        Achievement(
            id: "early_bird",
            title: "Early Bird",
            description: "Complete an item before 7 AM",
            iconSystemName: "sunrise.fill",
            category: .special,
            tier: .bronze,
            requirement: AchievementRequirement(type: .specificItems, threshold: 1),
            isSecret: true
        ),
        Achievement(
            id: "night_owl",
            title: "Night Owl",
            description: "Complete an item after 11 PM",
            iconSystemName: "moon.stars.fill",
            category: .special,
            tier: .bronze,
            requirement: AchievementRequirement(type: .specificItems, threshold: 1),
            isSecret: true
        ),
        Achievement(
            id: "weekend_warrior",
            title: "Weekend Warrior",
            description: "Complete 10 items on weekends",
            iconSystemName: "sun.max.fill",
            category: .special,
            tier: .silver,
            requirement: AchievementRequirement(type: .specificItems, threshold: 10),
            isSecret: true
        ),
        Achievement(
            id: "dedicated",
            title: "Dedicated",
            description: "Use the app for 30 days",
            iconSystemName: "heart.circle.fill",
            category: .special,
            tier: .gold,
            requirement: AchievementRequirement(type: .daysActive, threshold: 30)
        ),
        Achievement(
            id: "veteran",
            title: "Veteran",
            description: "Use the app for 100 days",
            iconSystemName: "medal.fill",
            category: .special,
            tier: .platinum,
            requirement: AchievementRequirement(type: .daysActive, threshold: 100)
        ),
        Achievement(
            id: "life_master",
            title: "Life Master",
            description: "Use the app for 365 days",
            iconSystemName: "crown.fill",
            category: .special,
            tier: .diamond,
            requirement: AchievementRequirement(type: .daysActive, threshold: 365),
            isSecret: true
        )
    ]
    
    static func achievement(_ id: String) -> Achievement? {
        allAchievements.first { $0.id == id }
    }
    
    static func achievements(for category: AchievementCategory) -> [Achievement] {
        allAchievements.filter { $0.category == category }
    }
    
    static func achievements(for tier: TrophyTier) -> [Achievement] {
        allAchievements.filter { $0.tier == tier }
    }
}

// MARK: - Achievement Manager

/// Manages achievement progress and unlocking
@MainActor
final class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: [UnlockedAchievement] = []
    @Published var progress: [String: AchievementProgress] = [:]
    @Published var newlyUnlocked: Achievement?
    @Published var showUnlockAnimation = false
    
    private let unlockedKey = "lifeXP.unlockedAchievements"
    private let progressKey = "lifeXP.achievementProgress"
    
    init() {
        loadData()
    }
    
    // MARK: - Public API
    
    func checkAchievements(appModel: AppModel) {
        for achievement in AchievementLibrary.allAchievements {
            guard !isUnlocked(achievement.id) else { continue }
            
            let currentProgress = calculateProgress(for: achievement, appModel: appModel)
            updateProgress(for: achievement.id, value: currentProgress)
            
            if currentProgress >= achievement.requirement.threshold {
                unlock(achievement)
            }
        }
    }
    
    func isUnlocked(_ achievementID: String) -> Bool {
        unlockedAchievements.contains { $0.achievementID == achievementID }
    }
    
    func progressRatio(for achievementID: String) -> Double {
        guard let progress = progress[achievementID],
              let achievement = AchievementLibrary.achievement(achievementID) else { return 0 }
        return min(1.0, Double(progress.currentValue) / Double(achievement.requirement.threshold))
    }
    
    func unlockedCount(for category: AchievementCategory) -> Int {
        let categoryAchievements = AchievementLibrary.achievements(for: category)
        return categoryAchievements.filter { isUnlocked($0.id) }.count
    }
    
    func totalCount(for category: AchievementCategory) -> Int {
        AchievementLibrary.achievements(for: category).count
    }
    
    func unlockedCount(for tier: TrophyTier) -> Int {
        let tierAchievements = AchievementLibrary.achievements(for: tier)
        return tierAchievements.filter { isUnlocked($0.id) }.count
    }
    
    var totalUnlocked: Int {
        unlockedAchievements.count
    }
    
    var totalXPFromAchievements: Int {
        unlockedAchievements.reduce(0) { $0 + $1.xpAwarded }
    }
    
    var recentUnlocks: [UnlockedAchievement] {
        unlockedAchievements
            .sorted { $0.unlockedAt > $1.unlockedAt }
            .prefix(5)
            .map { $0 }
    }
    
    // MARK: - Private Methods
    
    private func calculateProgress(for achievement: Achievement, appModel: AppModel) -> Int {
        switch achievement.requirement.type {
        case .totalXP:
            return appModel.totalXP
        case .level:
            return appModel.level
        case .streak:
            return max(appModel.currentStreak, appModel.bestStreak)
        case .completedItems:
            return appModel.completedItemIDs.count
        case .completedInDimension:
            guard let dimension = achievement.requirement.dimension else { return 0 }
            return appModel.allVisibleItems
                .filter { $0.dimensions.contains(dimension) && appModel.completedItemIDs.contains($0.id) }
                .count
        case .completedArcs:
            return appModel.arcs.filter { appModel.arcProgress($0) >= 1.0 }.count
        case .completedQuests:
            return appModel.arcs
                .flatMap { $0.chapters.flatMap { $0.quests } }
                .filter { appModel.completedItemIDs.contains($0.id) }
                .count
        case .daysActive:
            // Would need to track actual days active
            return appModel.currentStreak + 7 // Estimate
        case .habitsCompleted:
            // Would need HabitManager integration
            return 0
        case .journalEntries:
            // Would need JournalManager integration
            return 0
        case .focusSessions:
            // Would need FocusTimerManager integration
            return 0
        case .perfectDays:
            // Would need to track perfect days
            return 0
        case .uniqueDimensions:
            // Check if user has completed items in all dimensions today
            // Simplified for now
            return LifeDimension.allCases.filter { dim in
                appModel.allVisibleItems
                    .filter { $0.dimensions.contains(dim) && appModel.completedItemIDs.contains($0.id) }
                    .count > 0
            }.count
        case .specificItems:
            // Special achievements checked elsewhere
            return 0
        }
    }
    
    private func updateProgress(for achievementID: String, value: Int) {
        if var existing = progress[achievementID] {
            existing.currentValue = value
            existing.lastUpdated = Date()
            progress[achievementID] = existing
        } else {
            progress[achievementID] = AchievementProgress(
                id: achievementID,
                currentValue: value,
                lastUpdated: Date()
            )
        }
        saveData()
    }
    
    private func unlock(_ achievement: Achievement) {
        let unlocked = UnlockedAchievement(
            achievementID: achievement.id,
            xpAwarded: achievement.xpReward
        )
        unlockedAchievements.append(unlocked)
        
        // Trigger animation
        newlyUnlocked = achievement
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showUnlockAnimation = true
        }
        HapticsEngine.softCelebrate()
        
        // Reset animation after delay
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                withAnimation {
                    showUnlockAnimation = false
                    newlyUnlocked = nil
                }
            }
        }
        
        saveData()
    }
    
    // MARK: - Persistence
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: unlockedKey),
           let decoded = try? JSONDecoder().decode([UnlockedAchievement].self, from: data) {
            unlockedAchievements = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([String: AchievementProgress].self, from: data) {
            progress = decoded
        }
    }
    
    private func saveData() {
        if let data = try? JSONEncoder().encode(unlockedAchievements) {
            UserDefaults.standard.set(data, forKey: unlockedKey)
        }
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }
}

// MARK: - Views

/// Main Trophy Case View
struct TrophyCaseView: View {
    @Environment(AppModel.self) private var appModel
    @StateObject private var manager = AchievementManager()
    
    @State private var selectedCategory: AchievementCategory?
    @State private var selectedTier: TrophyTier?
    @State private var showingAchievement: Achievement?
    
    var filteredAchievements: [Achievement] {
        var achievements = AchievementLibrary.allAchievements
        
        if let category = selectedCategory {
            achievements = achievements.filter { $0.category == category }
        }
        
        if let tier = selectedTier {
            achievements = achievements.filter { $0.tier == tier }
        }
        
        // Sort: unlocked first, then by tier
        return achievements.sorted { a, b in
            let aUnlocked = manager.isUnlocked(a.id)
            let bUnlocked = manager.isUnlocked(b.id)
            
            if aUnlocked != bUnlocked {
                return aUnlocked
            }
            return a.tier > b.tier
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Stats header
                    TrophyStatsHeader(manager: manager)
                    
                    // Category filter
                    CategoryFilterRow(selectedCategory: $selectedCategory)
                    
                    // Tier filter
                    TierFilterRow(selectedTier: $selectedTier)
                    
                    // Recent unlocks
                    if !manager.recentUnlocks.isEmpty && selectedCategory == nil && selectedTier == nil {
                        RecentUnlocksCard(manager: manager, onSelect: { achievement in
                            showingAchievement = achievement
                        })
                    }
                    
                    // Achievements grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                        ForEach(filteredAchievements) { achievement in
                            AchievementTile(
                                achievement: achievement,
                                isUnlocked: manager.isUnlocked(achievement.id),
                                progress: manager.progressRatio(for: achievement.id)
                            ) {
                                showingAchievement = achievement
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.bottom, 100)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Trophy Case")
            .sheet(item: $showingAchievement) { achievement in
                AchievementDetailSheet(
                    achievement: achievement,
                    isUnlocked: manager.isUnlocked(achievement.id),
                    progress: manager.progressRatio(for: achievement.id),
                    unlockedAt: manager.unlockedAchievements.first { $0.achievementID == achievement.id }?.unlockedAt
                )
            }
            .overlay {
                if manager.showUnlockAnimation, let achievement = manager.newlyUnlocked {
                    AchievementUnlockOverlay(achievement: achievement)
                }
            }
            .onAppear {
                manager.checkAchievements(appModel: appModel)
            }
        }
    }
}

// MARK: - Trophy Stats Header

struct TrophyStatsHeader: View {
    @ObservedObject var manager: AchievementManager
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Main stat
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trophy Collection")
                        .font(.headline)
                    Text("\(manager.totalUnlocked) of \(AchievementLibrary.allAchievements.count) unlocked")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // XP from achievements
                VStack(alignment: .trailing) {
                    Text("+\(manager.totalXPFromAchievements)")
                        .font(.title2.bold())
                        .foregroundStyle(.yellow)
                    Text("XP earned")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.secondary.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(manager.totalUnlocked) / CGFloat(max(1, AchievementLibrary.allAchievements.count)))
                }
            }
            .frame(height: 12)
            
            // Tier breakdown
            HStack(spacing: 16) {
                ForEach(TrophyTier.allCases, id: \.self) { tier in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(tier.color)
                            .frame(width: 24, height: 24)
                            .overlay {
                                Text("\(manager.unlockedCount(for: tier))")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                            }
                        Text(tier.label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Category Filter Row

struct CategoryFilterRow: View {
    @Binding var selectedCategory: AchievementCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryFilterChip(
                    label: "All",
                    icon: "square.grid.2x2.fill",
                    isSelected: selectedCategory == nil,
                    color: .gray
                ) {
                    selectedCategory = nil
                }
                
                ForEach(AchievementCategory.allCases) { category in
                    CategoryFilterChip(
                        label: category.label,
                        icon: category.iconSystemName,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
        }
    }
}

// MARK: - Tier Filter Row

struct TierFilterRow: View {
    @Binding var selectedTier: TrophyTier?
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(TrophyTier.allCases, id: \.self) { tier in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTier = selectedTier == tier ? nil : tier
                    }
                } label: {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(tier.color)
                            .frame(width: 12, height: 12)
                        Text(tier.label)
                            .font(.caption.bold())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(selectedTier == tier ? tier.color.opacity(0.2) : Color.secondary.opacity(0.1))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
    }
}

struct CategoryFilterChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                action()
            }
            HapticsEngine.lightImpact()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(label)
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.2) : Color.secondary.opacity(0.1))
            .foregroundStyle(isSelected ? color : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? color : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Recent Unlocks Card

struct RecentUnlocksCard: View {
    @ObservedObject var manager: AchievementManager
    let onSelect: (Achievement) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Recent Unlocks")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(manager.recentUnlocks) { unlock in
                        if let achievement = AchievementLibrary.achievement(unlock.achievementID) {
                            Button {
                                onSelect(achievement)
                            } label: {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(achievement.tier.color.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: achievement.iconSystemName)
                                            .font(.title2)
                                            .foregroundStyle(achievement.tier.color)
                                    }
                                    
                                    Text(achievement.title)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .frame(width: 70)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding()
        .modifier(BrandCardModifier())
    }
}

// MARK: - Achievement Tile

struct AchievementTile: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Background
                    Circle()
                        .fill(isUnlocked ? achievement.tier.color.opacity(0.2) : Color.secondary.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    // Progress ring (if not unlocked)
                    if !isUnlocked && progress > 0 {
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(achievement.tier.color.opacity(0.5), lineWidth: 3)
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                    }
                    
                    // Icon
                    if isUnlocked || !achievement.isSecret {
                        Image(systemName: achievement.iconSystemName)
                            .font(.title2)
                            .foregroundStyle(isUnlocked ? achievement.tier.color : .secondary)
                    } else {
                        Image(systemName: "questionmark")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Unlocked checkmark
                    if isUnlocked {
                        Circle()
                            .fill(.green)
                            .frame(width: 18, height: 18)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                            }
                            .offset(x: 22, y: 22)
                    }
                }
                
                // Title
                Text(achievement.isSecret && !isUnlocked ? "???" : achievement.title)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                
                // Tier indicator
                Circle()
                    .fill(achievement.tier.color)
                    .frame(width: 8, height: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.secondary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Achievement Detail Sheet

struct AchievementDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Double
    let unlockedAt: Date?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xl) {
                    // Trophy display
                    ZStack {
                        // Glow effect
                        if isUnlocked {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [achievement.tier.color.opacity(0.5), .clear],
                                        center: .center,
                                        startRadius: 40,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                        }
                        
                        // Trophy
                        ZStack {
                            Circle()
                                .fill(isUnlocked ? achievement.tier.color.opacity(0.3) : Color.secondary.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            if !isUnlocked {
                                Circle()
                                    .trim(from: 0, to: progress)
                                    .stroke(achievement.tier.color, lineWidth: 6)
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                            }
                            
                            Image(systemName: achievement.iconSystemName)
                                .font(.system(size: 48))
                                .foregroundStyle(isUnlocked ? achievement.tier.color : .secondary)
                        }
                    }
                    
                    // Title and tier
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(achievement.tier.color)
                                .frame(width: 12, height: 12)
                            Text(achievement.tier.label)
                                .font(.subheadline.bold())
                                .foregroundStyle(achievement.tier.color)
                        }
                        
                        Text(achievement.title)
                            .font(.title.bold())
                        
                        Text(achievement.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Status
                    if isUnlocked {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Unlocked")
                                    .font(.headline)
                            }
                            
                            if let date = unlockedAt {
                                Text(date, style: .date)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    } else {
                        VStack(spacing: 12) {
                            Text("Progress")
                                .font(.subheadline.bold())
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.secondary.opacity(0.2))
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(achievement.tier.color)
                                        .frame(width: geometry.size.width * progress)
                                }
                            }
                            .frame(height: 12)
                            
                            Text("\(Int(progress * 100))% complete")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    }
                    
                    // Reward
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("+\(achievement.xpReward) XP")
                            .font(.headline)
                        
                        if !isUnlocked {
                            Text("on unlock")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                    
                    // Category
                    HStack {
                        Image(systemName: achievement.category.iconSystemName)
                            .foregroundStyle(achievement.category.color)
                        Text(achievement.category.label)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if achievement.isSecret {
                            Label("Secret", systemImage: "eye.slash.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.md))
                }
                .padding()
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Achievement")
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

// MARK: - Achievement Unlock Overlay

struct AchievementUnlockOverlay: View {
    let achievement: Achievement
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Achievement Unlocked!")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                // Trophy
                ZStack {
                    // Particle effects
                    ForEach(0..<12, id: \.self) { i in
                        Circle()
                            .fill(achievement.tier.color)
                            .frame(width: 8, height: 8)
                            .offset(x: cos(Double(i) * .pi / 6) * 80, y: sin(Double(i) * .pi / 6) * 80)
                            .opacity(opacity * 0.5)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [achievement.tier.color, achievement.tier.color.opacity(0.3)],
                                center: .center,
                                startRadius: 20,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: achievement.iconSystemName)
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                }
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                
                VStack(spacing: 8) {
                    Text(achievement.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text(achievement.description)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(achievement.tier.color)
                            .frame(width: 12, height: 12)
                        Text(achievement.tier.label)
                            .font(.subheadline.bold())
                            .foregroundStyle(achievement.tier.color)
                        
                        Text("•")
                            .foregroundStyle(.white.opacity(0.5))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("+\(achievement.xpReward) XP")
                                .font(.subheadline.bold())
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .opacity(opacity)
            }
            .padding(32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
                rotation = 0
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct TrophyCaseView_Previews: PreviewProvider {
    static var previews: some View {
        TrophyCaseView()
            .environmentObject(AppModel())
    }
}
#endif
