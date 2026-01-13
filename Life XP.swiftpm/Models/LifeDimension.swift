import Foundation

/// Core life dimensions used throughout the app.
enum LifeDimension: String, CaseIterable, Codable, Identifiable, Hashable {
    case love
    case money
    case mind
    case adventure

    var id: String { rawValue }

    /// User-facing label for the dimension.
    var label: String {
        String(localized: "dimension.\(rawValue)", bundle: .module)
    }

    /// Symbol that visually represents the dimension.
    var systemImage: String {
        switch self {
        case .love: return "heart.fill"
        case .money: return "dollarsign.circle.fill"
        case .mind: return "brain.head.profile"
        case .adventure: return "globe.europe.africa.fill"
        }
    }

    /// Alias for systemImage to match naming in other parts of the codebase.
    var iconSystemName: String { systemImage }
    
    /// Hex color code for the dimension's accent color.
    var accentColorHex: String {
        switch self {
        case .love: return "EC4899"      // Pink
        case .money: return "10B981"     // Green
        case .mind: return "8B5CF6"      // Purple
        case .adventure: return "F59E0B" // Orange
        }
    }
}

/// Coaching tone preference for in-app messaging.
enum ToneMode: String, CaseIterable, Identifiable, Hashable, Codable {
    case soft
    case realTalk

    var id: String { rawValue }

    /// Human-friendly label for the tone option.
    var label: String {
        String(localized: "tone.\(rawValue)", bundle: .module)
    }
}
