import SwiftUI

/// Centralized localization keys for user-facing copy.
enum L10n {
    static let appTitle = LocalizedStringKey("app.title")

    static let tabHome = LocalizedStringKey("tab.home")
    static let tabArcs = LocalizedStringKey("tab.arcs")
    static let tabPacks = LocalizedStringKey("tab.packs")
    static let tabStats = LocalizedStringKey("tab.stats")
    static let tabSettings = LocalizedStringKey("tab.settings")

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
        String(localized: .init(self))
    }
}
