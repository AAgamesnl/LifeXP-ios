import SwiftUI
import Foundation

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

    /// Dimension with the lowest relative progress, if any.
    var lowestDimension: LifeDimension? {
        let candidates = LifeDimension.allCases.filter { maxXP(for: $0) > 0 }
        guard !candidates.isEmpty else { return nil }
        return candidates.min(by: { ratio(for: $0) < ratio(for: $1) })
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

        return result
    }
}
