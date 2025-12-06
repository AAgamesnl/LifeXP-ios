import SwiftUI

/// User-facing control over the app appearance.
enum AppearanceMode: String, CaseIterable, Identifiable, Hashable, Codable {
    case system
    case light
    case dark

    var id: String { rawValue }

    /// Human-readable label for settings UI.
    var label: String {
        switch self {
        case .system: return "Match system"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    /// Optional color scheme override to apply to the root scene.
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
