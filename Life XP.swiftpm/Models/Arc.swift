import Foundation

/// Core narrative structure: a themed Arc composed of Chapters and Quests.
/// Arcs bundle a clear promise (title/subtitle), visual icon, accent color,
/// focus dimensions for suggested recommendations, and a set of chapters that
/// progressively increase depth. Arcs are serializable so we can ship curated
/// content without a backend.
struct Arc: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let iconSystemName: String
    let accentColorHex: String
    let focusDimensions: [LifeDimension]
    let chapters: [Chapter]

    /// Total quest count across all chapters.
    var questCount: Int {
        chapters.reduce(0) { $0 + $1.quests.count }
    }

    /// Sum of all XP available in this arc.
    var totalXP: Int {
        chapters.flatMap { $0.quests }.reduce(0) { $0 + $1.xp }
    }
}

/// Subsection of an Arc that groups quests by theme and intensity.
struct Chapter: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let summary: String
    let quests: [Quest]

    var totalXP: Int {
        quests.reduce(0) { $0 + $1.xp }
    }
}

/// Atomic unit of play. Quests map to one or more LifeDimensions and can be
/// different kinds (action, reflection, choice). Estimated minutes are used to
/// present realistic pacing and quick wins on the Home and Arcs hub.
struct Quest: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let detail: String?
    let kind: QuestKind
    let xp: Int
    let dimensions: [LifeDimension]
    let estimatedMinutes: Int?

    /// Human-friendly time label (e.g., "~15 min") to keep UI consistent.
    var durationLabel: String? {
        guard let estimatedMinutes else { return nil }
        if estimatedMinutes < 10 { return "~10 min" }
        if estimatedMinutes < 25 { return "~20 min" }
        if estimatedMinutes < 45 { return "~30 min" }
        if estimatedMinutes < 75 { return "~45 min" }
        return "~\(estimatedMinutes) min"
    }
}

enum QuestKind: String, CaseIterable, Codable, Identifiable {
    case action
    case reflection
    case choice

    var id: String { rawValue }

    /// Human-friendly label.
    var label: String {
        switch self {
        case .action: return "Action"
        case .reflection: return "Reflection"
        case .choice: return "Choice"
        }
    }

    /// SF Symbol used across quest chips.
    var systemImage: String {
        switch self {
        case .action: return "bolt.fill"
        case .reflection: return "text.quote"
        case .choice: return "switch.2"
        }
    }

    /// Short description to teach players how to approach this quest type.
    var guidance: String {
        switch self {
        case .action:
            return "Do something tangible. Keep it small and finish in one sitting."
        case .reflection:
            return "Pause, write, feel. Capture insights so they stick."
        case .choice:
            return "Decide and set a rule. Clarity beats perfect plans."
        }
    }

    /// Lower value means higher priority when ordering next quests.
    var priority: Int {
        switch self {
        case .action: return 0
        case .reflection: return 1
        case .choice: return 2
        }
    }
}
