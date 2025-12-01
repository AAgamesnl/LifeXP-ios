import Foundation

/// Curated sequence of checklist items that represent a themed path.
struct Journey: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let iconSystemName: String
    let accentColorHex: String
    let durationDays: Int
    let focusDimensions: [LifeDimension]
    let stepItemIDs: [String]
}
