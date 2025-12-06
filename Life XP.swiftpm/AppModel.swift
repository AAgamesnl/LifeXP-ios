import SwiftUI
import Foundation

struct SpotlightTheme {
    let title: String
    let description: String
    let iconSystemName: String
    let focus: LifeDimension
}

enum NudgeIntensity: String, Codable, CaseIterable, Identifiable {
    case gentle, standard, assertive

    var id: String { rawValue }
    var label: String {
        switch self {
        case .gentle: return "Zacht"
        case .standard: return "Standaard"
        case .assertive: return "Vurig"
        }
    }

    var questBonus: Int {
        switch self {
        case .gentle: return 0
        case .standard: return 1
        case .assertive: return 2
        }
    }
}

enum QuestBoardDensity: String, Codable, CaseIterable, Identifiable {
    case lean, balanced, packed

    var id: String { rawValue }
    var label: String {
        switch self {
        case .lean: return "Compact"
        case .balanced: return "Normaal"
        case .packed: return "Veel opties"
        }
    }

    var questCount: Int {
        switch self {
        case .lean: return 2
        case .balanced: return 3
        case .packed: return 5
        }
    }
}

struct UserSettings: Codable {
    var toneMode: ToneMode
    var appearanceMode: AppearanceMode
    var safeMode: Bool
    var dailyNudgeIntensity: NudgeIntensity
    var maxConcurrentArcs: Int
    var questBoardDensity: QuestBoardDensity
    var showHeartRepairContent: Bool
    var enabledDimensions: Set<LifeDimension>
    var showProTeasers: Bool

    var showEnergyCard: Bool
    var showMomentumGrid: Bool
    var showQuickActions: Bool
    var showWeeklyBlueprint: Bool
    var showFocusDimensionCard: Bool
    var showFocusPlaylistCard: Bool
    var showLegendaryQuestCard: Bool
    var showSeasonalSpotlight: Bool
    var showSuggestionCard: Bool
    var compactHomeLayout: Bool
    var expandHomeCardsByDefault: Bool
    var showHeroCards: Bool
    var showStreaks: Bool
    var showArcProgressOnShare: Bool

    var primaryFocus: LifeDimension?
    var overwhelmedLevel: Int

    private enum CodingKeys: String, CodingKey {
        case toneMode
        case appearanceMode
        case safeMode
        case dailyNudgeIntensity
        case maxConcurrentArcs
        case questBoardDensity
        case showHeartRepairContent
        case enabledDimensions
        case showProTeasers
        case showEnergyCard
        case showMomentumGrid
        case showQuickActions
        case showWeeklyBlueprint
        case showFocusDimensionCard
        case showFocusPlaylistCard
        case showLegendaryQuestCard
        case showSeasonalSpotlight
        case showSuggestionCard
        case compactHomeLayout
        case expandHomeCardsByDefault
        case showHeroCards
        case showStreaks
        case showArcProgressOnShare
        case primaryFocus
        case overwhelmedLevel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        toneMode = try container.decodeIfPresent(ToneMode.self, forKey: .toneMode) ?? .soft
        appearanceMode = try container.decodeIfPresent(AppearanceMode.self, forKey: .appearanceMode) ?? .system
        safeMode = try container.decodeIfPresent(Bool.self, forKey: .safeMode) ?? false
        dailyNudgeIntensity = try container.decodeIfPresent(NudgeIntensity.self, forKey: .dailyNudgeIntensity) ?? .standard
        maxConcurrentArcs = try container.decodeIfPresent(Int.self, forKey: .maxConcurrentArcs) ?? 2
        questBoardDensity = try container.decodeIfPresent(QuestBoardDensity.self, forKey: .questBoardDensity) ?? .balanced
        showHeartRepairContent = try container.decodeIfPresent(Bool.self, forKey: .showHeartRepairContent) ?? true
        enabledDimensions = try container.decodeIfPresent(Set<LifeDimension>.self, forKey: .enabledDimensions) ?? Set(LifeDimension.allCases)
        showProTeasers = try container.decodeIfPresent(Bool.self, forKey: .showProTeasers) ?? true

        showEnergyCard = try container.decodeIfPresent(Bool.self, forKey: .showEnergyCard) ?? false
        showMomentumGrid = try container.decodeIfPresent(Bool.self, forKey: .showMomentumGrid) ?? true
        showQuickActions = try container.decodeIfPresent(Bool.self, forKey: .showQuickActions) ?? true
        showWeeklyBlueprint = try container.decodeIfPresent(Bool.self, forKey: .showWeeklyBlueprint) ?? false
        showFocusDimensionCard = try container.decodeIfPresent(Bool.self, forKey: .showFocusDimensionCard) ?? false
        showFocusPlaylistCard = try container.decodeIfPresent(Bool.self, forKey: .showFocusPlaylistCard) ?? false
        showLegendaryQuestCard = try container.decodeIfPresent(Bool.self, forKey: .showLegendaryQuestCard) ?? false
        showSeasonalSpotlight = try container.decodeIfPresent(Bool.self, forKey: .showSeasonalSpotlight) ?? false
        showSuggestionCard = try container.decodeIfPresent(Bool.self, forKey: .showSuggestionCard) ?? false
        compactHomeLayout = try container.decodeIfPresent(Bool.self, forKey: .compactHomeLayout) ?? false
        expandHomeCardsByDefault = try container.decodeIfPresent(Bool.self, forKey: .expandHomeCardsByDefault) ?? true
        showHeroCards = try container.decodeIfPresent(Bool.self, forKey: .showHeroCards) ?? true
        showStreaks = try container.decodeIfPresent(Bool.self, forKey: .showStreaks) ?? true
        showArcProgressOnShare = try container.decodeIfPresent(Bool.self, forKey: .showArcProgressOnShare) ?? true

        primaryFocus = try container.decodeIfPresent(LifeDimension.self, forKey: .primaryFocus)
        overwhelmedLevel = try container.decodeIfPresent(Int.self, forKey: .overwhelmedLevel) ?? 3
    }
}

/// Central source of truth for Life XP state, progress, and preferences.
@MainActor
final class AppModel: ObservableObject {
    // MARK: - Published data
    @Published var packs: [CategoryPack]
    let arcs: [Arc]
    private let arcByID: [String: Arc]
    private let arcByQuestID: [String: Arc]
    @Published private(set) var completedItemIDs: Set<String>

    // MARK: - Premium (placeholder for future IAP)
    @Published var premiumUnlocked: Bool = false

    // MARK: - Preferences
    @Published var settings: UserSettings {
        didSet { persistState() }
    }

    var toneMode: ToneMode {
        get { settings.toneMode }
        set { settings.toneMode = newValue }
    }

    var appearanceMode: AppearanceMode {
        get { settings.appearanceMode }
        set { settings.appearanceMode = newValue }
    }

    var hideHeavyTopics: Bool {
        get { settings.safeMode }
        set { settings.safeMode = newValue }
    }

    var primaryFocus: LifeDimension? {
        get { settings.primaryFocus }
        set { settings.primaryFocus = newValue }
    }

    var overwhelmedLevel: Int {
        get { settings.overwhelmedLevel }
        set { settings.overwhelmedLevel = newValue }
    }

    var showEnergyCard: Bool {
        get { settings.showEnergyCard }
        set { settings.showEnergyCard = newValue }
    }

    var showMomentumGrid: Bool {
        get { settings.showMomentumGrid }
        set { settings.showMomentumGrid = newValue }
    }

    var showQuickActions: Bool {
        get { settings.showQuickActions }
        set { settings.showQuickActions = newValue }
    }

    var compactHomeLayout: Bool {
        get { settings.compactHomeLayout }
        set { settings.compactHomeLayout = newValue }
    }

    var expandHomeCardsByDefault: Bool {
        get { settings.expandHomeCardsByDefault }
        set { settings.expandHomeCardsByDefault = newValue }
    }

    var showHeroCards: Bool {
        get { settings.showHeroCards }
        set { settings.showHeroCards = newValue }
    }

    var showStreaks: Bool {
        get { settings.showStreaks }
        set { settings.showStreaks = newValue }
    }

    var showArcProgressOnShare: Bool {
        get { settings.showArcProgressOnShare }
        set { settings.showArcProgressOnShare = newValue }
    }

    var showWeeklyBlueprint: Bool {
        get { settings.showWeeklyBlueprint }
        set { settings.showWeeklyBlueprint = newValue }
    }

    var showFocusDimensionCard: Bool {
        get { settings.showFocusDimensionCard }
        set { settings.showFocusDimensionCard = newValue }
    }

    var showFocusPlaylistCard: Bool {
        get { settings.showFocusPlaylistCard }
        set { settings.showFocusPlaylistCard = newValue }
    }

    var showLegendaryQuestCard: Bool {
        get { settings.showLegendaryQuestCard }
        set { settings.showLegendaryQuestCard = newValue }
    }

    var showSeasonalSpotlight: Bool {
        get { settings.showSeasonalSpotlight }
        set { settings.showSeasonalSpotlight = newValue }
    }

    var showSuggestionCard: Bool {
        get { settings.showSuggestionCard }
        set { settings.showSuggestionCard = newValue }
    }

    // MARK: - Streaks
    @Published private(set) var currentStreak: Int
    @Published private(set) var bestStreak: Int
    private var lastActiveDay: Date?

    // MARK: - Arcs
    @Published private(set) var arcStartDates: [String: Date]

    // MARK: - Environment
    private let calendar: Calendar
    private let persistence: PersistenceManaging

    /// Preferred color scheme based on the user's explicit appearance selection.
    var preferredColorScheme: ColorScheme? { settings.appearanceMode.colorScheme }

    // MARK: - Lifecycle
    init(calendar: Calendar = .current, persistence: PersistenceManaging = PersistenceManager()) {
        let calendar = calendar
        let persistence = persistence

        let packs = SampleContent.packs
        let arcs = SampleContent.arcs
        let arcByID = Dictionary(uniqueKeysWithValues: arcs.map { ($0.id, $0) })

        var questMap: [String: Arc] = [:]
        for arc in arcs {
            for quest in arc.chapters.flatMap({ $0.quests }) {
                questMap[quest.id] = arc
            }
        }

        let snapshot = persistence.loadSnapshot()
        let sanitized = AppModel.sanitized(snapshot: snapshot, arcs: arcs, packs: packs)

        self.calendar = calendar
        self.persistence = persistence

        self.packs = packs
        self.arcs = arcs
        self.arcByID = arcByID
        self.arcByQuestID = questMap

        self.completedItemIDs = sanitized.progress.completedItemIDs
        self.settings = sanitized.settings

        self.currentStreak = sanitized.progress.currentStreak
        self.bestStreak = sanitized.progress.bestStreak
        self.lastActiveDay = sanitized.progress.lastActiveDay

        self.arcStartDates = sanitized.progress.arcStartDates
    }

    // MARK: - Persistence

    /// Persists the current snapshot to disk. Failures are ignored so the UI remains responsive even if storage is unavailable.
    private func persistState() {
        persistence.saveSnapshot(currentSnapshot())
    }

    private func currentSnapshot() -> PersistenceSnapshot {
        PersistenceSnapshot(
            version: PersistenceManager.currentVersion,
            progress: ProgressState(
                completedItemIDs: completedItemIDs,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastActiveDay: lastActiveDay,
                arcStartDates: arcStartDates
            ),
            settings: settings
        )
    }

    private static func sanitized(snapshot: PersistenceSnapshot, arcs: [Arc], packs: [CategoryPack]) -> PersistenceSnapshot {
        var snapshot = snapshot

        let knownIDs = Set(packs.flatMap { $0.items.map { $0.id } } + arcs.flatMap { arc in
            arc.chapters.flatMap { $0.quests.map { $0.id } }
        })
        snapshot.progress.completedItemIDs = snapshot.progress.completedItemIDs.intersection(knownIDs)

        let knownArcIDs = Set(arcs.map { $0.id })
        snapshot.progress.arcStartDates = snapshot.progress.arcStartDates.filter {
            knownArcIDs.contains($0.key) && $0.value.timeIntervalSince1970.isFinite
        }

        snapshot.progress.currentStreak = max(0, snapshot.progress.currentStreak)
        snapshot.progress.bestStreak = max(snapshot.progress.currentStreak, snapshot.progress.bestStreak)
        snapshot.settings.safeMode = false
        snapshot.settings.showHeartRepairContent = true
        snapshot.settings.maxConcurrentArcs = 2
        snapshot.settings.overwhelmedLevel = max(0, snapshot.settings.overwhelmedLevel)

        let validDimensions = Set(LifeDimension.allCases)
        snapshot.settings.enabledDimensions = snapshot.settings.enabledDimensions.intersection(validDimensions)
        if snapshot.settings.enabledDimensions.isEmpty {
            snapshot.settings.enabledDimensions = validDimensions
        }

        return snapshot
    }

    // MARK: - Data helpers

    private var allowedDimensions: Set<LifeDimension> {
        settings.enabledDimensions.isEmpty ? Set(LifeDimension.allCases) : settings.enabledDimensions
    }

    private func respectsDimensions(_ dimensions: [LifeDimension]) -> Bool {
        dimensions.isEmpty || dimensions.contains { allowedDimensions.contains($0) }
    }

    private func isArcVisible(_ arc: Arc) -> Bool {
        if arcStartDates[arc.id] != nil { return true }
        if !settings.showHeartRepairContent && arc.id == SampleContent.heartRepairArcID {
            return false
        }
        return respectsDimensions(arc.focusDimensions)
    }

    var visibleArcs: [Arc] {
        arcs.filter { isArcVisible($0) }
    }

    /// Visible items for a given pack, respecting the safe mode toggle.
    func items(for pack: CategoryPack) -> [ChecklistItem] {
        var filtered = pack.items
        if hideHeavyTopics {
            filtered = filtered.filter { !SampleContent.heavyItemIDs.contains($0.id) }
        }
        filtered = filtered.filter { respectsDimensions($0.dimensions) }
        return filtered
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
            if !respectsDimensions(match.dimensions) { return nil }
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

    /// Flattened quests across all arcs.
    var allQuests: [Quest] {
        visibleArcs.flatMap { arc in
            arc.chapters.flatMap { $0.quests.filter { respectsDimensions($0.dimensions) } }
        }
    }

    // MARK: - Completion & XP

    /// Whether a given checklist item has been completed.
    func isCompleted(_ item: ChecklistItem) -> Bool {
        completedItemIDs.contains(item.id)
    }

    /// Whether a quest has been completed.
    func isCompleted(_ quest: Quest) -> Bool {
        completedItemIDs.contains(quest.id)
    }

    /// Toggles completion and updates streaks + persistence.
    func toggle(_ item: ChecklistItem) {
        let wasCompleted = isCompleted(item)
        let levelBefore = level

        if wasCompleted {
            completedItemIDs.remove(item.id)
        } else {
            completedItemIDs.insert(item.id)
            registerActivityToday()
        }
        let levelAfter = level
        persistState()

        if !wasCompleted && levelAfter > levelBefore {
            HapticsEngine.softCelebrate()
        }
    }

    /// Toggle a quest completion.
    func toggle(_ quest: Quest) {
        let wasCompleted = isCompleted(quest)
        let levelBefore = level
        let unlockedBadgesBefore = unlockedBadges.count
        let arc = arcByQuestID[quest.id]
        let chapter = arc?.chapters.first { chapter in
            chapter.quests.contains(where: { $0.id == quest.id })
        }
        let arcProgressBefore = arc.map { arcProgress($0) } ?? 0
        let chapterProgressBefore = chapter.map { chapterProgress($0) } ?? 0

        if wasCompleted {
            completedItemIDs.remove(quest.id)
        } else {
            completedItemIDs.insert(quest.id)
            registerActivityToday()
            if let arc = arcByQuestID[quest.id] {
                startArcIfNeeded(arc)
            }
            HapticsEngine.lightImpact()
        }
        let levelAfter = level
        persistState()

        guard !wasCompleted else { return }

        if levelAfter > levelBefore {
            HapticsEngine.softCelebrate()
        }

        if let arc = arc {
            let arcProgressAfter = arcProgress(arc)
            if arcProgressAfter >= 1 && arcProgressBefore < 1 {
                HapticsEngine.success()
            }
        }

        if let chapter = chapter {
            let chapterProgressAfter = chapterProgress(chapter)
            if chapterProgressAfter >= 1 && chapterProgressBefore < 1 {
                HapticsEngine.softCelebrate()
            }
        }

        let unlockedAfter = unlockedBadges.count
        if unlockedAfter > unlockedBadgesBefore {
            HapticsEngine.success()
        }
    }

    /// Resets all progress-related data while keeping personalization intact.
    func resetProgress() {
        resetAllProgress()
    }

    func resetAllProgress() {
        completedItemIDs.removeAll()
        currentStreak = 0
        bestStreak = 0
        lastActiveDay = nil
        arcStartDates.removeAll()
        persistState()
    }

    func resetArcProgress() {
        let arcQuestIDs = Set(arcs.flatMap { $0.chapters.flatMap { $0.quests.map { $0.id } } })
        completedItemIDs.subtract(arcQuestIDs)
        arcStartDates.removeAll()
        persistState()
    }

    func resetStreaksOnly() {
        currentStreak = 0
        bestStreak = 0
        lastActiveDay = nil
        persistState()
    }

    func resetStatsOnly() {
        // Remove progress-based stats but leave arc start dates intact.
        completedItemIDs.removeAll()
        currentStreak = 0
        bestStreak = 0
        lastActiveDay = nil
        persistState()
    }

    /// Updates the streak counters based on activity today. Handles gaps gracefully by resetting to 1 when a streak is broken.
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
    }

    /// Progress for a specific pack (0...1).
    func progress(for pack: CategoryPack) -> Double {
        let visibleItems = items(for: pack)
        guard !visibleItems.isEmpty else { return 0 }
        let done = visibleItems.filter { completedItemIDs.contains($0.id) }.count
        return normalizedProgress(done: done, total: visibleItems.count)
    }

    private func normalizedProgress(done: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        let ratio = Double(done) / Double(total)
        guard ratio.isFinite else { return 0 }
        return min(max(ratio, 0), 1)
    }

    /// Overall completion across all visible items (0...1).
    var globalProgress: Double {
        let items = allVisibleItems.count + allQuests.count
        guard items > 0 else { return 0 }
        let done = completedCount
        return normalizedProgress(done: done, total: items)
    }

    /// Total XP accumulated across all dimensions.
    var totalXP: Int {
        xpSources
            .filter { completedItemIDs.contains($0.id) }
            .reduce(0) { $0 + $1.xp }
    }

    /// Number of completed quests.
    var completedCount: Int {
        let knownIDs = Set(allVisibleItems.map { $0.id } + allQuests.map { $0.id })
        return completedItemIDs.intersection(knownIDs).count
    }

    /// Number of fully finished chapters.
    var completedChaptersCount: Int {
        visibleArcs.flatMap { $0.chapters }.filter { chapterProgress($0) >= 1 }.count
    }

    /// Remaining quests available in the visible packs.
    var remainingCount: Int {
        let total = allVisibleItems.count + allQuests.count
        return max(0, total - completedCount)
    }

    /// XP for a single dimension, counting only completed items.
    func xp(for dimension: LifeDimension) -> Int {
        xpSources
            .filter { completedItemIDs.contains($0.id) && $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }

    /// Maximum attainable XP for a dimension with the currently visible items.
    func maxXP(for dimension: LifeDimension) -> Int {
        xpSources
            .filter { $0.dimensions.contains(dimension) }
            .reduce(0) { $0 + $1.xp }
    }

    // MARK: - Arcs

    var activeArcCount: Int {
        arcStartDates.keys.compactMap { arcByID[$0] }.filter { arcProgress($0) < 1 }.count
    }

    var remainingArcSlots: Int {
        max(0, settings.maxConcurrentArcs - activeArcCount)
    }

    /// Arc completion percentage (0...1).
    func arcProgress(_ arc: Arc) -> Double {
        let quests = arc.chapters.flatMap { $0.quests }
        guard !quests.isEmpty else { return 0 }
        let done = quests.filter { completedItemIDs.contains($0.id) }.count
        return normalizedProgress(done: done, total: quests.count)
    }

    func chapterProgress(_ chapter: Chapter) -> Double {
        guard !chapter.quests.isEmpty else { return 0 }
        let done = chapter.quests.filter { completedItemIDs.contains($0.id) }.count
        return normalizedProgress(done: done, total: chapter.quests.count)
    }

    func remainingXP(for arc: Arc) -> Int {
        let earned = earnedXP(for: arc)
        return max(0, arc.totalXP - earned)
    }

    func earnedXP(for arc: Arc) -> Int {
        arc.chapters
            .flatMap { $0.quests }
            .filter { completedItemIDs.contains($0.id) }
            .reduce(0) { $0 + $1.xp }
    }

    func arc(for quest: Quest) -> Arc? {
        arcByQuestID[quest.id]
    }

    func arc(withID id: String) -> Arc? {
        arcByID[id]
    }

    var completedArcs: [Arc] {
        arcs.filter { arcProgress($0) >= 1 && isArcVisible($0) }
    }

    @discardableResult
    func startArcIfNeeded(_ arc: Arc, date: Date = Date()) -> Bool {
        if arcStartDates[arc.id] != nil {
            return true
        }
        guard remainingArcSlots > 0 else { return false }
        arcStartDates[arc.id] = date
        persistState()
        return true
    }

    func resetArcStart(_ arc: Arc) {
        arcStartDates.removeValue(forKey: arc.id)
        persistState()
    }

    /// Returns the day index (starting at 1) since the user started an arc, or nil when the arc hasn't started.
    func arcDay(for arc: Arc, date: Date = Date()) -> Int? {
        guard let start = arcStartDates[arc.id] else { return nil }
        let startDay = calendar.startOfDay(for: start)
        let current = calendar.startOfDay(for: date)
        let diff = calendar.dateComponents([.day], from: startDay, to: current).day ?? 0
        return max(1, diff + 1)
    }

    var activeArc: Arc? {
        let sorted = arcStartDates.sorted(by: { $0.value > $1.value })
        for entry in sorted {
            if let arc = arcByID[entry.key], arcProgress(arc) < 1 {
                return arc
            }
        }
        return sorted.compactMap { arcByID[$0.key] }.first
    }

    var activeArcs: [Arc] {
        arcStartDates
            .filter { arcID, _ in
                if let arc = arcByID[arcID] {
                    return arcProgress(arc) < 1
                }
                return false
            }
            .sorted(by: { $0.value > $1.value })
            .compactMap { arcByID[$0.key] }
    }

    func canStartArc(_ arc: Arc) -> Bool {
        remainingArcSlots > 0 || arcStartDates[arc.id] != nil
    }

    func nextQuests(in arc: Arc, limit: Int = 3) -> [Quest] {
        let finalLimit = max(0, limit)
        guard finalLimit > 0 else { return [] }

        var prioritized: [Quest] = []
        let weak = lowestDimension

        for chapter in arc.chapters {
            let open = chapter.quests.filter { !isCompleted($0) }
            let sorted = open.sorted { lhs, rhs in
                if let weak = weak {
                    let lhsMatch = lhs.dimensions.contains(weak)
                    let rhsMatch = rhs.dimensions.contains(weak)
                    if lhsMatch != rhsMatch { return lhsMatch }
                }

                if lhs.kind.priority != rhs.kind.priority {
                    return lhs.kind.priority < rhs.kind.priority
                }

                if lhs.xp != rhs.xp {
                    return lhs.xp > rhs.xp
                }

                return (lhs.estimatedMinutes ?? 30) < (rhs.estimatedMinutes ?? 30)
            }
            prioritized.append(contentsOf: sorted)

            if prioritized.count >= finalLimit { break }
        }

        if prioritized.count < finalLimit {
            let remaining = arc.chapters
                .flatMap { $0.quests }
                .filter { !isCompleted($0) && !prioritized.contains($0) }
                .sorted { lhs, rhs in
                    if lhs.kind.priority != rhs.kind.priority {
                        return lhs.kind.priority < rhs.kind.priority
                    }
                    return lhs.xp > rhs.xp
                }
            prioritized.append(contentsOf: remaining)
        }

        return Array(prioritized.prefix(finalLimit))
    }

    var questBoardLimit: Int {
        max(1, settings.questBoardDensity.questCount + settings.dailyNudgeIntensity.questBonus)
    }

    /// Arcs we propose the player starts next, prioritizing weak dimensions and unfinished arcs.
    var suggestedArcs: [Arc] {
        let incomplete = visibleArcs.filter { arcProgress($0) < 1 }
        guard !incomplete.isEmpty else { return [] }

        let unstarted = incomplete.filter { arcStartDates[$0.id] == nil }
        let candidates = (unstarted.isEmpty ? incomplete : unstarted)
            .filter { $0.id != activeArc?.id }

        let weak = lowestDimension
        let prioritized = candidates.sorted { lhs, rhs in
            if let weak = weak {
                let lhsMatch = lhs.focusDimensions.contains(weak)
                let rhsMatch = rhs.focusDimensions.contains(weak)
                if lhsMatch != rhsMatch { return lhsMatch }
            }

            if arcStartDates[lhs.id] != nil && arcStartDates[rhs.id] == nil {
                return false
            }

            if arcStartDates[lhs.id] == nil && arcStartDates[rhs.id] != nil {
                return true
            }

            let lhsRemaining = remainingXP(for: lhs)
            let rhsRemaining = remainingXP(for: rhs)
            if lhsRemaining != rhsRemaining { return lhsRemaining > rhsRemaining }
            return lhs.title < rhs.title
        }

        return Array(prioritized.prefix(4))
    }

    /// Combines the active arc with fallback suggestions to surface the most actionable quest board.
    func nextQuestBoard(limit: Int? = nil) -> (arc: Arc?, quests: [Quest]) {
        let finalLimit = limit ?? questBoardLimit
        guard finalLimit > 0 else { return (nil, []) }
        if let arc = activeArc {
            let quests = nextQuests(in: arc, limit: finalLimit)
            if !quests.isEmpty { return (arc, quests) }
        }

        if let arc = suggestedArcs.first {
            return (arc, nextQuests(in: arc, limit: finalLimit))
        }

        return (nil, [])
    }

    /// Handy entry for surfacing on Home, Stats, and the share card.
    var highlightedArc: Arc? {
        activeArc ?? suggestedArcs.first
    }

    var arcProgressHeadline: String {
        guard let arc = highlightedArc else { return "Nog geen arc gekozen." }
        let progress = Int(arcProgress(arc) * 100)
        if let day = arcDay(for: arc) {
            return "\(arc.title): dag \(day), \(progress)% compleet"
        }
        return "\(arc.title): \(progress)% compleet"
    }

    // MARK: - Suggestions & coaching

    private var xpSources: [(id: String, xp: Int, dimensions: [LifeDimension])] {
        let items = allVisibleItems.map { ($0.id, $0.xp, $0.dimensions) }
        let quests = allQuests.map { ($0.id, $0.xp, $0.dimensions) }
        return items + quests
    }

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

    /// Light-weight check-in based on the overwhelmed slider.
    var energyCheckIn: String {
        switch overwhelmedLevel {
        case 0...2:
            return "Je staat in herstelmodus. Kies iets zachts en vier elke micro stap."
        case 3...4:
            return "Je kan wat aan. Kies 1 focus-quest en 1 micro win voor momentum."
        default:
            return "Je bent in beast mode. Pak een hero quest en bouw aan je streak."
        }
    }

    /// Gentle resets the user can do when energy is low.
    var recoveryPrompts: [String] {
        [
            "Doe een 3-minuten reset: ademhaling, water, stretchen.",
            "Schrijf 5 dingen op die vandaag genoeg zijn. Niet perfect, wel echt.",
            "Maak een 'done list' van wat al goed ging en claim die dopamine.",
            "Plan een mini-reward na één task: thee, muziek, een meme kijken.",
            "Kies de makkelijkste quest die toch vooruitgang boekt." 
        ]
    }

    struct BlueprintStep: Identifiable {
        let id = UUID().uuidString
        let title: String
        let detail: String
        let icon: String
    }

    /// Weekly blueprint with tiny rituals and focus moves.
    var weeklyBlueprint: [BlueprintStep] {
        let dayIndex = calendar.component(.weekday, from: Date())
        let base: [[BlueprintStep]] = [
            [
                BlueprintStep(title: "Plan 1 bold move", detail: "Blokkeer 30 min voor een taak waar toekomst-jij blij van wordt.", icon: "target"),
                BlueprintStep(title: "Inbox reset", detail: "Snoei notificaties en 5 snelle replies.", icon: "tray.fill"),
                BlueprintStep(title: "Body check", detail: "10 minuten bewegen of een wandeling met muziek.", icon: "figure.walk")
            ],
            [
                BlueprintStep(title: "Social ping", detail: "Stuur een voice note naar iemand die je energie geeft.", icon: "bubble.left.and.bubble.right.fill"),
                BlueprintStep(title: "Money micro", detail: "Check 1 rekening of zet 10 euro apart.", icon: "creditcard.fill"),
                BlueprintStep(title: "Mind care", detail: "Schrijf 3 zinnen over wat je vandaag loslaat.", icon: "brain.head.profile")
            ],
            [
                BlueprintStep(title: "Adventure seed", detail: "Plan een mini-uitstap voor dit weekend.", icon: "safari.fill"),
                BlueprintStep(title: "Workspace reset", detail: "Ruim 1 hoekje op zodat je weer kan focussen.", icon: "square.grid.2x2.fill"),
                BlueprintStep(title: "Sleep prep", detail: "Leg je outfit klaar en zet je telefoon op nachtstand.", icon: "moon.zzz.fill")
            ]
        ]

        let deck = base[dayIndex % base.count]
        return deck
    }

    /// Quick wins tuned to the weakest dimension first.
    var focusPlaylist: [ChecklistItem] {
        if let dim = lowestDimension {
            let targeted = allVisibleItems.filter { item in
                item.dimensions.contains(dim) && !completedItemIDs.contains(item.id)
            }
            if !targeted.isEmpty {
                return Array(targeted.prefix(4))
            }
        }

        let available = allVisibleItems.filter { !completedItemIDs.contains($0.id) }
        return Array(available.prefix(4))
    }

    /// Packs sorted by remaining quests to nudge players into closure.
    var boosterPacks: [(pack: CategoryPack, remaining: Int, progress: Double)] {
        packs.compactMap { pack in
            let visible = items(for: pack)
            guard !visible.isEmpty else { return nil }
            let done = visible.filter { completedItemIDs.contains($0.id) }.count
            let remaining = visible.count - done
            return (pack: pack, remaining: remaining, progress: Double(done) / Double(visible.count))
        }
        .sorted { lhs, rhs in
            if lhs.progress == rhs.progress {
                return lhs.remaining < rhs.remaining
            }
            return lhs.progress > rhs.progress
        }
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
    /// Lightweight RPG-style level derived from total XP, always at least 1.
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
            (completedArcs.isEmpty, "Speel een arc uit om badge ‘Story Arc’ te claimen."),
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

        if completedArcs.count >= 1 {
            result.append(Badge(
                id: "badge_story_arc",
                name: "Story Arc",
                description: "Je hebt minstens één arc volledig uitgespeeld.",
                iconSystemName: "book.circle.fill"
            ))
        }

        if completedArcs.count >= 3 {
            result.append(Badge(
                id: "badge_arc_collector",
                name: "Arc Collector",
                description: "Drie arcs gecompleteerd: je leeft in seizoenen.",
                iconSystemName: "rectangle.stack.fill"
            ))
        }

        if completedChaptersCount >= 3 {
            result.append(Badge(
                id: "badge_chapter_closer",
                name: "Chapter Closer",
                description: "Je hebt 3+ chapters afgerond. Jij sluit lusjes.",
                iconSystemName: "book.closed.fill"
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
