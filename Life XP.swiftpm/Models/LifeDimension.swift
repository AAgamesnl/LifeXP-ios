import SwiftUI
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
        switch self {
        case .love: return "Love"
        case .money: return "Money"
        case .mind: return "Mind"
        case .adventure: return "Adventure"
        }
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
}

/// Coaching tone preference for in-app messaging.
enum ToneMode: String, CaseIterable, Identifiable, Hashable, Codable {
    case soft
    case realTalk

    var id: String { rawValue }

    /// Human-friendly label for the tone option.
    var label: String {
        switch self {
        case .soft: return "Soft & gentle"
        case .realTalk: return "Real talk"
        }
    }
}
