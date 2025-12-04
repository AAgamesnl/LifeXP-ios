import SwiftUI
#if os(iOS)
import UIKit
#endif

extension Color {
    /// Initializes a `Color` from a hex string like `#FF00AA`.
    init(hex: String, default defaultColor: Color = .accentColor) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        guard cleaned.count == 6,
              let rgb = UInt64(cleaned, radix: 16)
        else {
            self = defaultColor
            return
        }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self = Color(red: r, green: g, blue: b)
    }

    /// Provides a dynamic color that adapts between light and dark appearances.
    static func dynamic(light: Color, dark: Color) -> Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
        #else
        return light
        #endif
    }
}
