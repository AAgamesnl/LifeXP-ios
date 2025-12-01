import SwiftUI
import Foundation

struct SpotlightTheme {
    let title: String
    let description: String
    let iconSystemName: String
    let focus: LifeDimension
}

/// Central source of truth for Life XP state, progress, and preferences.
final class AppModel: ObservableObject {
    // MARK: - Published data
    @Published var packs: [CategoryPack]
    let journeys: [Journey]
    @Published private(set) var completedItemIDs: Set<String>

    // MARK: - Premium (placeholder for future IAP)
    @Published var premiumUnlocked: Bool = false

    // MARK: - Preferences
    @Published var toneMode: ToneMode {
        didSet { persistToneMode() }
    }

    @Published var hideHeavyTopics: Bool {
        didSet { persistHideHeavyTopics() }
    }

    @Published var primaryFocus: LifeDimension? = nil
    @Published var overwhelmedLevel: Int = 3

    // MARK: - Streaks
    @Published private(set) var currentStreak: Int
    @Published private(set) var bestStreak: Int
    private var lastActiveDay: Date?

    // MARK: - Environment
    private let calendar: Calendar
    private let userDefaults: UserDefaults

    private enum Keys {
        static let completed = "lifeXP.completedItemIDs"
        static let toneMode = "lifeXP.toneMode"
        static let hideHeavy = "lifeXP.hideHeavy"
        static let currentStreak = "lifeXP.currentStreak"
        static let bestStreak = "lifeXP.bestStreak"
        static let lastActiveDay = "lifeXP.lastActiveDay"
    }

    // MARK: - Lifecycle

    init(calendar: Calendar = .current, userDefaults: UserDefaults = .standard) {
        self.calendar = calendar
        self.userDefaults = userDefaults

        self.packs = SampleContent.packs
        self.journeys = SampleContent.journeys
        self.completedItemIDs = Set(userDefaults.stringArray(forKey: Keys.completed) ?? [])

        if let rawTone = userDefaults.string(forKey: Keys.toneMode),
           let storedTone = ToneMode(rawValue: rawTone) {
            self.toneMode = storedTone
        } else {
            self.toneMode = .soft
        }

        self.hideHeavyTopics = userDefaults.bool(forKey: Keys.hideHeavy)
        self.currentStreak = userDefaults.integer(forKey: Keys.currentStreak)
        self.bestStreak = userDefaults.integer(forKey: Keys.bestStreak)
        self.lastActiveDay = userDefaults.object(forKey: Keys.lastActiveDay) as? Date
    }

    // MARK: - Persistence

    private func persistCompleted() {
        userDefaults.set(Array(completedItemIDs), forKey: Keys.completed)
    }

    private func persistToneMode() {
        userDefaults.set(toneMode.rawValue, forKey: Keys.toneMode)
    }

    private func persistHideHeavyTopics() {
        userDefaults.set(hideHeavyTopics, forKey: Keys.hideHeavy)
    }

    private func persistStreaks() {
        userDefaults.set(currentStreak, forKey: Keys.currentStreak)
        userDefaults.set(bestStreak, forKey: Keys.bestStreak)
        if let last = lastActiveDay {
            userDefaults.set(last, forKey: Keys.lastActiveDay)
        }
    }

    // MARK: - Data helpers

    /// Visible items for a given pack, respecting the safe mode toggle.
    func items(for pack: CategoryPack) -> [ChecklistItem] {
        if hideHeavyTopics {
            return pack.items.filter { !SampleContent.heavyItemIDs.contains($0.id) }
        }
        return pack.items
    }

    /// Flattened list of items across all packs with safe mode applied.
    var allVisibleItems: [ChecklistItem] {
        packs.flatMap { items(for: $0) }
    }

    /// Returns an item by ID, or nil if it is hidden by safe mode.
    func item(withID id: String) -> ChecklistItem? {
        for pack in packs {
            guard let match = pack.items.first(where: { $0.id == id }) else { continue }
            if hideHeavyTopics && SampleContent.heavyItemIDs.contains(id) {
                return nil
            }
            return match
        }
        return nil
    }

    /// Returns the pack that contains a given item ID.
    func pack(for itemID: String) -> CategoryPack? {
        packs.first { pack in
            pack.items.contains(where: { $0.id == itemID })
        }
    }

    // MARK: - Completion & XP

    /// Whether a given checklist item has been completed.
    func isCompleted(_ item: ChecklistItem) -> Bool {
        completedItemIDs.contains(item.id)
    }

    /// Toggles completion and updates streaks + persistence.
    func toggle(_ item: ChecklistItem) {
        let wasCompleted = isCompleted(item)

        if wasCompleted {
            completedItemIDs.remove(item.id)
        } else {
            completedItemIDs.insert(item.id)
            registerActivityToday()
        }
        persistCompleted()
    }

    private func registerActivityToday(date: Date = Date()) {
        let today = calendar.startOfDay(for: date)

        if let last = lastActiveDay {
            let lastDay = calendar.startOfDay(for: last)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            switch diff {
            case 0:
                break // same day
            case 1:
                currentStreak += 1
            default:
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        lastActiveDay = today
        bestStreak = max(bestStreak, currentStreak)
        persistStreaks()
    }

    /// Progress for a specific pack (0...1).
    func progress(for pack: CategoryPack) -> Double {
        let visibleItems = items(for: pack)
        guard !visibleItems.isEmpty else { return 0 }
        let done = visibleItems.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(visibleItems.count)
    }

    /// Overall completion across all visible items (0...1).
    var globalProgress: Double {
        let items = allVisibleItems
        guard !items.isEmpty else { return 0 }
        let done = items.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(items.count)
    }

    /// Total XP accumulated across all dimensions.
    var totalXP: Int {
        allVisibleItems
            .filter { completedItemIDs.contains($0.id) }
            .reduce(0) { $0 + $1.xp }
    }

    /// XP for a single dimension, counting only completed items.
    func xp(for dimension: LifeDimension) -> Int {
        allVisibleItems
            .filter { completedItemIDs.contains($0.id) && $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }

    /// Maximum attainable XP for a dimension with the currently visible items.
    func maxXP(for dimension: LifeDimension) -> Int {
        allVisibleItems
            .filter { $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }

    // MARK: - Journeys

    /// Journey completion percentage (0...1).
    func journeyProgress(_ journey: Journey) -> Double {
        let steps = journey.stepItemIDs.compactMap { item(withID: $0) }
        guard !steps.isEmpty else { return 0 }
        let done = steps.filter { completedItemIDs.contains($0.id) }.count
        return Double(done) / Double(steps.count)
    }

    /// Number of completed steps in a journey.
    func journeyCompletedCount(_ journey: Journey) -> Int {
        journey.stepItemIDs
            .compactMap { item(withID: $0) }
            .filter { completedItemIDs.contains($0.id) }
            .count
    }

    /// Total steps available in a journey after applying safe mode.
    func journeyTotalCount(_ journey: Journey) -> Int {
        journey.stepItemIDs.compactMap { item(withID: $0) }.count
    }

    /// Journeys fully completed (all steps done).
    var completedJourneys: [Journey] {
        journeys.filter { journeyProgress($0) >= 1 }
    }

    // MARK: - Suggestions & coaching

    /// Random incomplete item suggestion that respects premium access.
    var suggestedItem: (pack: CategoryPack, item: ChecklistItem)? {
        let pairs: [(pack: CategoryPack, item: ChecklistItem)] = packs.flatMap { pack in
            items(for: pack).map { (pack: pack, item: $0) }
        }

        let incomplete = pairs.filter { pair in
            !completedItemIDs.contains(pair.item.id) &&
            (!pair.item.isPremium || premiumUnlocked)
        }

        return incomplete.randomElement()
    }

    private func ratio(for dimension: LifeDimension) -> Double {
        let max = maxXP(for: dimension)
        guard max > 0 else { return 0 }
        return Double(xp(for: dimension)) / Double(max)
    }

    /// Sorted overview of each dimension with its relative completion.
    var dimensionRankings: [(dimension: LifeDimension, ratio: Double, earned: Int, total: Int)] {
        LifeDimension.allCases
            .map { dim in (dim, ratio(for: dim), xp(for: dim), maxXP(for: dim)) }
            .filter { $0.total > 0 }
            .sorted { $0.ratio > $1.ratio }
    }

    /// Aggregated balance score across all dimensions.
    var dimensionBalanceScore: Int {
        let ratios = dimensionRankings.map { $0.ratio }
        guard !ratios.isEmpty else { return 0 }
        return Int((ratios.reduce(0, +) / Double(ratios.count)) * 100)
    }

    /// Short label for where the user should aim next.
    var focusHeadline: String {
        if let lowest = lowestDimension {
            return "Focus \(lowest.label) voor een betere balans."
        }
        return "Pak een willekeurige quest en houd de flow vast."
    }

    /// Lightweight rituals that rotate daily for extra inspiration.
    var ritualOfTheDay: String {
        let rituals = [
            "Schrijf 3 zinnen over wat je vandaag wilt voelen.",
            "Drink water, adem diep in en uit voor 60 seconden.",
            "Stuur iemand een snelle appreciatie-voice note.",
            "Maak je favoriete hoekje netjes; micro reset.",
            "Plan 1 bold move voor je toekomst-self en blok het in.",
            "Zet een timer en beweeg 7 minuten: springen, rekken, lopen.",
            "Kies je outfit voor morgen en leg ‘m klaar (future you zegt bedankt).",
        ]

        let index = calendar.component(.day, from: Date()) % rituals.count
        return rituals[index]
    }

    /// Smallest quests to grab dopamine without overthinking.
    var microWins: [ChecklistItem] {
        let available = allVisibleItems.filter { !completedItemIDs.contains($0.id) }
        return Array(available.sorted(by: { $0.xp < $1.xp }).prefix(4))
    }

    /// High impact quests to pitch as weekly boss battles.
    var heroQuests: [ChecklistItem] {
        let available = allVisibleItems.filter { !completedItemIDs.contains($0.id) }
        return Array(available.sorted(by: { $0.xp > $1.xp }).prefix(3))
    }

    /// Dimension with the lowest relative progress, if any.
    var lowestDimension: LifeDimension? {
        let candidates = LifeDimension.allCases.filter { maxXP(for: $0) > 0 }
        guard !candidates.isEmpty else { return nil }
        return candidates.min(by: { ratio(for: $0) < ratio(for: $1) })
    }

    /// Curated list of incomplete items that match the weakest dimension.
    var focusSuggestions: [ChecklistItem] {
        guard let dim = lowestDimension else { return [] }
        let candidates = allVisibleItems.filter { item in
            item.dimensions.contains(dim) && !completedItemIDs.contains(item.id)
        }
        return Array(candidates.prefix(3))
    }

    /// High XP item to pitch as eenmalige "boss fight".
    var legendaryQuest: ChecklistItem? {
        allVisibleItems
            .filter { !completedItemIDs.contains($0.id) }
            .sorted(by: { $0.xp > $1.xp })
            .first
    }

    /// Soft or real-talk affirmation tuned to progress.
    var dailyAffirmation: String {
        let inspirationsSoft = [
            "Je hoeft het niet perfect te doen om het toch te laten tellen.",
            "Vandaag is een goed moment om te bouwen aan het leven dat je wilt voelen.",
            "Rust en actie kunnen naast elkaar bestaan. Kies één mini-actie nu.",
            "Je pace is prima. Je verschijnt; dat is de winst.",
        ]

        let inspirationsRealTalk = [
            "Niet wachten op motivatie; bewegen creëert motivatie.",
            "Geen zin? Prima. Doe het alsnog, maar kleiner.",
            "De toekomst-versie van jou rekent op vandaag. Start.",
            "Momentum > perfecte planning.", 
        ]

        let base = toneMode == .soft ? inspirationsSoft : inspirationsRealTalk
        let index = calendar.component(.weekOfYear, from: Date()) % base.count
        return base[index]
    }

    /// Weekly spotlight theme that rotates om de gebruiker een hoofdstuk te geven.
    var seasonalSpotlight: (theme: SpotlightTheme, items: [ChecklistItem])? {
        let themes: [SpotlightTheme] = [
            SpotlightTheme(title: "Adventure Season", description: "Elke week minstens één herinnering maken die opvalt.", iconSystemName: "safari.fill", focus: .adventure),
            SpotlightTheme(title: "Soft Power", description: "Rustige discipline: slaap, boundaries, beauty rituals.", iconSystemName: "sparkles.tv.fill", focus: .mind),
            SpotlightTheme(title: "Glow with friends", description: "Samen leren, bouwen en vieren.", iconSystemName: "person.3.sequence.fill", focus: .love),
            SpotlightTheme(title: "Money Play", description: "Cashflow, skills en kansen unlocken.", iconSystemName: "creditcard.fill", focus: .money)
        ]

        guard !themes.isEmpty else { return nil }
        let week = calendar.component(.weekOfYear, from: Date())
        let theme = themes[week % themes.count]

        let themedItems = allVisibleItems.filter {
            $0.dimensions.contains(theme.focus) && !completedItemIDs.contains($0.id)
        }

        let picks = themedItems.isEmpty ? Array(allVisibleItems.shuffled().prefix(3)) : Array(themedItems.shuffled().prefix(3))
        guard !picks.isEmpty else { return nil }

        return (theme: theme, items: picks)
    }

    /// Tone-aware coaching message based on overall progress.
    var coachMessage: String {
        let score = Int(globalProgress * 100)

        switch toneMode {
        case .soft:
            if score < 20 {
                return "Iedereen start ergens. Eén kleine taak vandaag is genoeg. Je hoeft niet ineens je hele leven te fixen."
            } else if score < 50 {
                return "Je bent bezig, en dat zie je. Kies vandaag iets uit je focus-pack en vier dat het gelukt is."
            } else {
                return "Je bent al een eind op weg. Vergeet niet ook te rusten en te genieten van wat je al hebt gebouwd."
            }

        case .realTalk:
            if score < 20 {
                return "Je leven gaat zichzelf niet levelen. Eén kleine taak. Vandaag. Geen excuses."
            } else if score < 50 {
                return "Je bent onderweg, maar je speelt nog op easy mode. Pak vandaag iets waar je eigenlijk geen zin in hebt."
            } else {
                return "Je bent aan het levellen. Nu niet achteroverleunen en alles laten rotten. Blijf consequent."
            }
        }
    }

    // MARK: - Leveling

    /// Lightweight RPG-style level derived from total XP.
    var level: Int {
        max(1, totalXP / 120 + 1)
    }

    private var levelStartXP: Int {
        (level - 1) * 120
    }

    /// Progress (0...1) through the current level.
    var levelProgress: Double {
        let span = 120
        let current = totalXP - levelStartXP
        return Double(max(0, min(current, span))) / Double(span)
    }

    /// How much XP is needed to reach the next level.
    var xpToNextLevel: Int {
        max(0, level * 120 - totalXP)
    }

    /// A bite-sized hint of what unlocks next.
    var nextUnlockMessage: String {
        let milestones: [(Bool, String)] = [
            (totalXP < 50, "Nog \(50 - totalXP) XP tot badge ‘Getting Started’."),
            (totalXP < 200, "Nog \(200 - totalXP) XP tot badge ‘Leveling Up’."),
            (totalXP < 500, "\(500 - totalXP) XP te gaan tot ‘Life Architect’."),
            (totalXP < 1000, "Legend status komt dichterbij: nog \(1000 - totalXP) XP."),
            (xp(for: .adventure) < 120 && maxXP(for: .adventure) > 0, "Focus adventure voor badge ‘Explorer’."),
            (xp(for: .mind) < 150 && maxXP(for: .mind) > 0, "Mind-work badge ‘Inner Work’ staat klaar als je nog \(150 - xp(for: .mind)) XP pakt."),
            (completedJourneys.isEmpty, "Speel een journey uit om badge ‘Story Arc’ te claimen."),
            (currentStreak < 7, "\(max(0, 7 - currentStreak)) dagen tot je ‘Consistency Era’ badge terugziet."),
            (bestStreak < 21, "Ga voor 21 dagen streak om ‘Unstoppable’ te claimen."),
        ]

        return milestones.first(where: { $0.0 })?.1 ?? "Je hebt de grote milestones gehaald. Tijd voor je eigen legendarische side quest."
    }

    // MARK: - Badges

    /// Derived badges from XP and streak milestones.
    var unlockedBadges: [Badge] {
        var result: [Badge] = []

        if totalXP >= 50 {
            result.append(Badge(
                id: "badge_getting_started",
                name: "Getting Started",
                description: "Je hebt de eerste stappen gezet en al 50+ XP verzameld.",
                iconSystemName: "sparkles"
            ))
        }

        if totalXP >= 200 {
            result.append(Badge(
                id: "badge_leveling_up",
                name: "Leveling Up",
                description: "Je hebt 200+ XP. Je bent officieel bezig met een glow-up.",
                iconSystemName: "arrow.up.circle.fill"
            ))
        }

        if totalXP >= 500 {
            result.append(Badge(
                id: "badge_architect",
                name: "Life Architect",
                description: "500+ XP: je leven is een designproject geworden.",
                iconSystemName: "rectangle.3.group.fill"
            ))
        }

        if totalXP >= 1000 {
            result.append(Badge(
                id: "badge_legend",
                name: "Level 100 Vibes",
                description: "1000+ XP verzameld. Je speelt nu op Legendary.",
                iconSystemName: "star.circle.fill"
            ))
        }

        if xp(for: .love) >= 80 {
            result.append(Badge(
                id: "badge_soft_lover",
                name: "Soft Lover",
                description: "Je investeert serieus in relaties en verbinding.",
                iconSystemName: "heart.circle.fill"
            ))
        }

        if xp(for: .money) >= 80 {
            result.append(Badge(
                id: "badge_money_minded",
                name: "Money Minded",
                description: "Je bent eerlijk naar je geld aan het kijken en dat betaalt zich terug.",
                iconSystemName: "banknote.fill"
            ))
        }

        if xp(for: .adventure) >= 120 {
            result.append(Badge(
                id: "badge_explorer",
                name: "Explorer",
                description: "Je verzamelt actief nieuwe herinneringen en micro-avonturen.",
                iconSystemName: "safari.fill"
            ))
        }

        if xp(for: .mind) >= 150 {
            result.append(Badge(
                id: "badge_inner_work",
                name: "Inner Work",
                description: "Mind-work is priority. Reflectie, therapie en routines zijn geland.",
                iconSystemName: "brain"
            ))
        }

        if currentStreak >= 3 {
            result.append(Badge(
                id: "badge_streak_3",
                name: "On A Roll",
                description: "Minstens 3 dagen na elkaar iets voor je leven gedaan.",
                iconSystemName: "flame.fill"
            ))
        }

        if bestStreak >= 7 {
            result.append(Badge(
                id: "badge_streak_7",
                name: "Consistency Era",
                description: "Je hebt een streak van 7+ dagen gehaald.",
                iconSystemName: "calendar.badge.checkmark"
            ))
        }

        if bestStreak >= 21 {
            result.append(Badge(
                id: "badge_unstoppable",
                name: "Unstoppable",
                description: "21+ dagen streak. Dit is hoe momentum voelt.",
                iconSystemName: "bolt.fill"
            ))
        }

        if completedJourneys.count >= 1 {
            result.append(Badge(
                id: "badge_story_arc",
                name: "Story Arc",
                description: "Je hebt minstens één journey volledig uitgespeeld.",
                iconSystemName: "book.circle.fill"
            ))
        }

        if completedJourneys.count >= 3 {
            result.append(Badge(
                id: "badge_arc_collector",
                name: "Arc Collector",
                description: "Drie journeys gecompleteerd: je leeft in seizoenen.",
                iconSystemName: "rectangle.stack.fill"
            ))
        }

        let ratios = LifeDimension.allCases.map { ratio(for: $0) }
        if ratios.allSatisfy({ $0 >= 0.6 }) && !ratios.isEmpty {
            result.append(Badge(
                id: "badge_balanced", 
                name: "Balanced", 
                description: "Elke dimensie staat op 60%+ van zijn potentieel.",
                iconSystemName: "circle.grid.cross"
            ))
        }

        return result
    }
}
