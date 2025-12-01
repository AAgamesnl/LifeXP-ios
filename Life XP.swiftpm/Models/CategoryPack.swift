import Foundation

/// Grouping of related checklist items with shared styling.
struct CategoryPack: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let iconSystemName: String
    let accentColorHex: String
    let isPremium: Bool
    let items: [ChecklistItem]
}
