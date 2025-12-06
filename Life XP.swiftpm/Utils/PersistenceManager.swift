import Foundation

/// Describes the persistent state we keep between app launches.
struct PersistenceSnapshot: Codable {
    /// Versioned payload so we can migrate in the future when models change.
    var version: Int
    var progress: ProgressState
    var preferences: PreferencesState
    var home: HomePreferences
}

/// Progress-related state such as completions and streaks.
struct ProgressState: Codable {
    var completedItemIDs: Set<String>
    var currentStreak: Int
    var bestStreak: Int
    var lastActiveDay: Date?
    var arcStartDates: [String: Date]
}

/// User settings and mood toggles.
struct PreferencesState: Codable {
    var toneMode: ToneMode
    var appearanceMode: AppearanceMode
    var hideHeavyTopics: Bool
    var primaryFocus: LifeDimension?
    var overwhelmedLevel: Int
}

/// Home screen customization toggles.
struct HomePreferences: Codable {
    var showEnergyCard: Bool
    var showMomentumGrid: Bool
    var showQuickActions: Bool
    var compactHomeLayout: Bool
    var expandHomeCardsByDefault: Bool
}

/// Simple interface to allow dependency injection and testing.
protocol PersistenceManaging {
    func loadSnapshot() -> PersistenceSnapshot
    func saveSnapshot(_ snapshot: PersistenceSnapshot)
    func reset()
}

/// Centralized persistence service that hides storage keys and encoding details.
final class PersistenceManager: PersistenceManaging {
    static let currentVersion = 1

    private enum Storage {
        static let snapshot = "lifeXP.persistence.snapshot"
    }

    private enum LegacyKeys {
        static let completed = "lifeXP.completedItemIDs"
        static let toneMode = "lifeXP.toneMode"
        static let appearanceMode = "lifeXP.appearanceMode"
        static let hideHeavy = "lifeXP.hideHeavy"
        static let currentStreak = "lifeXP.currentStreak"
        static let bestStreak = "lifeXP.bestStreak"
        static let lastActiveDay = "lifeXP.lastActiveDay"
        static let homeEnergy = "lifeXP.homeEnergy"
        static let homeMomentum = "lifeXP.homeMomentum"
        static let homeQuickActions = "lifeXP.homeQuickActions"
        static let homeCompact = "lifeXP.homeCompact"
        static let homeExpanded = "lifeXP.homeExpanded"
        static let arcStarts = "lifeXP.arcStarts"
        static let primaryFocus = "lifeXP.primaryFocus"
        static let overwhelmLevel = "lifeXP.overwhelmLevel"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func loadSnapshot() -> PersistenceSnapshot {
        if let data = defaults.data(forKey: Storage.snapshot) {
            do {
                let decoded = try decoder.decode(PersistenceSnapshot.self, from: data)
                return migrate(decoded)
            } catch {
                // Corrupt payloads should not crash the app; wipe and fall back to defaults.
                defaults.removeObject(forKey: Storage.snapshot)
            }
        }

        if let legacy = loadLegacySnapshot() {
            saveSnapshot(legacy)
            return legacy
        }

        return PersistenceManager.defaultSnapshot()
    }

    func saveSnapshot(_ snapshot: PersistenceSnapshot) {
        guard let data = try? encoder.encode(snapshot) else { return }
        defaults.set(data, forKey: Storage.snapshot)
    }

    func reset() {
        defaults.removeObject(forKey: Storage.snapshot)
    }

    // MARK: - Helpers

    private func migrate(_ snapshot: PersistenceSnapshot) -> PersistenceSnapshot {
        var snapshot = snapshot
        if snapshot.version != Self.currentVersion {
            snapshot.version = Self.currentVersion
        }
        return snapshot
    }

    private func loadLegacySnapshot() -> PersistenceSnapshot? {
        let completed = Set(defaults.stringArray(forKey: LegacyKeys.completed) ?? [])

        let tone: ToneMode
        if let rawTone = defaults.string(forKey: LegacyKeys.toneMode),
           let storedTone = ToneMode(rawValue: rawTone) {
            tone = storedTone
        } else {
            tone = .soft
        }

        let appearance: AppearanceMode
        if let rawAppearance = defaults.string(forKey: LegacyKeys.appearanceMode),
           let storedAppearance = AppearanceMode(rawValue: rawAppearance) {
            appearance = storedAppearance
        } else {
            appearance = .system
        }

        let arcStarts: [String: Date]
        if let storedStarts = defaults.dictionary(forKey: LegacyKeys.arcStarts) as? [String: TimeInterval] {
            arcStarts = storedStarts.mapValues { Date(timeIntervalSince1970: $0) }
        } else {
            arcStarts = [:]
        }

        let preferences = PreferencesState(
            toneMode: tone,
            appearanceMode: appearance,
            hideHeavyTopics: defaults.bool(forKey: LegacyKeys.hideHeavy),
            primaryFocus: defaults.string(forKey: LegacyKeys.primaryFocus).flatMap { LifeDimension(rawValue: $0) },
            overwhelmedLevel: defaults.object(forKey: LegacyKeys.overwhelmLevel) as? Int ?? 3
        )

        let home = HomePreferences(
            showEnergyCard: defaults.object(forKey: LegacyKeys.homeEnergy) as? Bool ?? true,
            showMomentumGrid: defaults.object(forKey: LegacyKeys.homeMomentum) as? Bool ?? true,
            showQuickActions: defaults.object(forKey: LegacyKeys.homeQuickActions) as? Bool ?? true,
            compactHomeLayout: defaults.object(forKey: LegacyKeys.homeCompact) as? Bool ?? false,
            expandHomeCardsByDefault: defaults.object(forKey: LegacyKeys.homeExpanded) as? Bool ?? true
        )

        let progress = ProgressState(
            completedItemIDs: completed,
            currentStreak: defaults.integer(forKey: LegacyKeys.currentStreak),
            bestStreak: defaults.integer(forKey: LegacyKeys.bestStreak),
            lastActiveDay: defaults.object(forKey: LegacyKeys.lastActiveDay) as? Date,
            arcStartDates: arcStarts
        )

        // Nothing to migrate if the user never launched the app before.
        if completed.isEmpty,
           progress.currentStreak == 0,
           progress.bestStreak == 0,
           progress.lastActiveDay == nil,
           arcStarts.isEmpty,
           preferences.primaryFocus == nil,
           !defaults.bool(forKey: LegacyKeys.hideHeavy) {
            return nil
        }

        return PersistenceSnapshot(
            version: Self.currentVersion,
            progress: progress,
            preferences: preferences,
            home: home
        )
    }

    static func defaultSnapshot() -> PersistenceSnapshot {
        PersistenceSnapshot(
            version: currentVersion,
            progress: ProgressState(
                completedItemIDs: [],
                currentStreak: 0,
                bestStreak: 0,
                lastActiveDay: nil,
                arcStartDates: [:]
            ),
            preferences: PreferencesState(
                toneMode: .soft,
                appearanceMode: .system,
                hideHeavyTopics: false,
                primaryFocus: nil,
                overwhelmedLevel: 3
            ),
            home: HomePreferences(
                showEnergyCard: true,
                showMomentumGrid: true,
                showQuickActions: true,
                compactHomeLayout: false,
                expandHomeCardsByDefault: true
            )
        )
    }
}
