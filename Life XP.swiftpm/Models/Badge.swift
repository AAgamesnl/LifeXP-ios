import Foundation

/// Milestone earned after reaching specific XP or streak thresholds.
struct Badge: Identifiable {
    let id: String
    let name: String
    let description: String
    let iconSystemName: String
}
