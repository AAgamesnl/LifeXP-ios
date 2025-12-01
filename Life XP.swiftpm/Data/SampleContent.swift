import Foundation

/// Central entry point for curated sample content used by the app.
enum SampleContent {
    static let packs = PackLibrary.core
    static let heavyItemIDs = PackLibrary.heavyItemIDs
    static let journeys = JourneyLibrary.all
}
