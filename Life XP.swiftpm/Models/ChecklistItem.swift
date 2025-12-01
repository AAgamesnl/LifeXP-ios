import Foundation

/// Individual checklist item that can be completed for XP.
struct ChecklistItem: Identifiable, Codable {
    let id: String
    let title: String
    let detail: String?
    let xp: Int
    let dimensions: [LifeDimension]
    let isPremium: Bool
}
