// Minimal placeholder to satisfy SwiftPM builds on non-Apple platforms.
// The full application depends on SwiftUI, which is unavailable outside Apple platforms.

import Foundation

/// Returns a short message confirming the placeholder build is being used and prints it.
@discardableResult
public func runLifeXPPlaceholder() -> String {
    let message = "Life XP placeholder build for non-Apple platforms."
    print(message)
    return message
}
