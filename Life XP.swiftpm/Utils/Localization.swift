import SwiftUI

/// Centralized localization keys for user-facing copy.
enum L10n {
    static let appTitle = LocalizedStringKey("app.title")

    static let tabHub = LocalizedStringKey("tab.hub")
    static let tabStory = LocalizedStringKey("tab.story")
    static let tabTraining = LocalizedStringKey("tab.training")
    static let tabReflection = LocalizedStringKey("tab.reflection")
    static let tabSettings = LocalizedStringKey("tab.settings")

    static let hubTitle = LocalizedStringKey("hub.title")
    static let hubDailyQuestTitle = LocalizedStringKey("hub.dailyQuest.title")
    static let hubDailyQuestSubtitle = LocalizedStringKey("hub.dailyQuest.subtitle")
    static let hubProgressTitle = LocalizedStringKey("hub.progress.title")
    static let hubCTAStartAdventure = LocalizedStringKey("hub.cta.startAdventure")
    static let hubCTAContinueArc = LocalizedStringKey("hub.cta.continueArc")
    static let hubCTAClaimReward = LocalizedStringKey("hub.cta.claimReward")
    static let hubCTAExploreArcs = LocalizedStringKey("hub.cta.exploreArcs")
    static let hubCTAClaimSubtitle = LocalizedStringKey("hub.cta.claimReward.subtitle")
    static let hubCTAExploreSubtitle = LocalizedStringKey("hub.cta.exploreArcs.subtitle")
    static let hubModesTitle = LocalizedStringKey("hub.modes.title")
    static let hubModeStoryTitle = LocalizedStringKey("hub.mode.story.title")
    static let hubModeStorySubtitle = LocalizedStringKey("hub.mode.story.subtitle")
    static let hubModeTrainingTitle = LocalizedStringKey("hub.mode.training.title")
    static let hubModeTrainingSubtitle = LocalizedStringKey("hub.mode.training.subtitle")
    static let hubModeReflectionTitle = LocalizedStringKey("hub.mode.reflection.title")
    static let hubModeReflectionSubtitle = LocalizedStringKey("hub.mode.reflection.subtitle")
    static let hubDailyQuestCompleted = LocalizedStringKey("hub.dailyQuest.completed")
    static let hubDailyQuestEmpty = LocalizedStringKey("hub.dailyQuest.empty")
    static let hubProgressTotalXP = LocalizedStringKey("hub.progress.totalXp")
    static let hubProgressToNextLevel = LocalizedStringKey("hub.progress.nextLevel")
    static let hubProgressStreak = LocalizedStringKey("hub.progress.streak")
    static let hubProgressXPRemaining = LocalizedStringKey("hub.progress.xpRemaining")
    static let hubProgressStreakDays = LocalizedStringKey("hub.progress.streakDays")
    static let hubProgressLevelFormat = LocalizedStringKey("hub.progress.level")

    static let storyModeTitle = LocalizedStringKey("story.title")
    static let storyModeSubtitle = LocalizedStringKey("story.subtitle")
    static let storyModeActive = LocalizedStringKey("story.section.active")
    static let storyModeSuggested = LocalizedStringKey("story.section.suggested")
    static let storyModeLibrary = LocalizedStringKey("story.section.library")

    static let trainingModeTitle = LocalizedStringKey("training.title")
    static let trainingModeSubtitle = LocalizedStringKey("training.subtitle")
    static let trainingSectionInProgress = LocalizedStringKey("training.section.inProgress")
    static let trainingSectionRecommended = LocalizedStringKey("training.section.recommended")
    static let trainingSectionCompleted = LocalizedStringKey("training.section.completed")
    static let trainingSectionPremium = LocalizedStringKey("training.section.premium")

    static let reflectionModeTitle = LocalizedStringKey("reflection.title")
    static let reflectionModeSubtitle = LocalizedStringKey("reflection.subtitle")
    static let reflectionRitualTitle = LocalizedStringKey("reflection.ritual.title")
    static let reflectionRitualSubtitle = LocalizedStringKey("reflection.ritual.subtitle")
    static let reflectionAchievementsTitle = LocalizedStringKey("reflection.achievements.title")
    static let reflectionAchievementsSubtitle = LocalizedStringKey("reflection.achievements.subtitle")
    static let reflectionCheckInTitle = LocalizedStringKey("reflection.checkIn.title")
    static let reflectionAchievementLevelFormat = LocalizedStringKey("reflection.achievement.level")
    static let reflectionAchievementXPFormat = LocalizedStringKey("reflection.achievement.xp")
    static let reflectionAchievementStreakFormat = LocalizedStringKey("reflection.achievement.streak")
    static let reflectionAchievementBadgesFormat = LocalizedStringKey("reflection.achievement.badges")
    static let reflectionAchievementMomentum = LocalizedStringKey("reflection.achievement.momentum")
    static let reflectionAchievementUnlocked = LocalizedStringKey("reflection.achievement.unlocked")

    static let statusLive = LocalizedStringKey("status.live")
    static let statusCompleted = LocalizedStringKey("status.completed")
    static let progressPercentCompleteFormat = LocalizedStringKey("progress.percentComplete")
    static let quickActionsTitle = LocalizedStringKey("home.quickActions.title")
    static let packsTitle = LocalizedStringKey("home.packs.title")
    static let packsSubtitle = LocalizedStringKey("home.packs.subtitle")

    static let startArcTitle = LocalizedStringKey("home.startArc.title")
    static let startArcSubtitle = LocalizedStringKey("home.startArc.subtitle")

    static let actionLogMoodTitle = LocalizedStringKey("action.logMood.title")
    static let actionLogMoodSubtitle = LocalizedStringKey("action.logMood.subtitle")
    static let actionArcsTitle = LocalizedStringKey("action.arcs.title")
    static let actionArcsSubtitle = LocalizedStringKey("action.arcs.subtitle")
    static let actionPacksTitle = LocalizedStringKey("action.packs.title")
    static let actionPacksSubtitle = LocalizedStringKey("action.packs.subtitle")

    static let arcsNextQuestsTitle = LocalizedStringKey("arcs.nextQuests.title")
    static let settingsNextQuestsTitle = LocalizedStringKey("settings.nextQuests.title")
    static let settingsNextQuestsSubtitle = LocalizedStringKey("settings.nextQuests.subtitle")

    static let commonDone = LocalizedStringKey("common.done")
    static let moreFeaturesTitle = LocalizedStringKey("moreFeatures.title")
    static let packsScreenTitle = LocalizedStringKey("packs.title")
    static let packsSearchPrompt = LocalizedStringKey("packs.searchPrompt")
}

extension String {
    /// Convenience for localized strings outside SwiftUI views.
    var localized: String {
        String(localized: .init(self), bundle: .module)
    }
}
