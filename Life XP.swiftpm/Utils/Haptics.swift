import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Haptics Engine

/// Centralized haptic feedback manager with various feedback types for different interactions.
/// Provides graceful degradation on platforms that don't support haptics.
enum HapticsEngine {
    
    // MARK: - Impact Feedback
    
    /// Light impact for subtle interactions like button taps and selections.
    static func lightImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Medium impact for moderate interactions like toggling items.
    static func mediumImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Heavy impact for significant actions like completing a quest.
    static func heavyImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Soft impact for gentle feedback.
    static func softImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Rigid impact for precise feedback.
    static func rigidImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    // MARK: - Notification Feedback
    
    /// Success feedback for achievements, level ups, and completions.
    static func success() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }
    
    /// Warning feedback for caution-requiring actions.
    static func warning() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
        #endif
    }
    
    /// Error feedback for failed actions or validation errors.
    static func error() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        #endif
    }
    
    // MARK: - Selection Feedback
    
    /// Selection changed feedback for pickers, sliders, and similar controls.
    static func selectionChanged() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
    
    // MARK: - Composite Feedback
    
    /// Soft celebration for minor achievements like completing an item.
    static func softCelebrate() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        // Double tap effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let light = UIImpactFeedbackGenerator(style: .light)
            light.impactOccurred()
        }
        #endif
    }
    
    /// Level up celebration with escalating feedback.
    static func levelUp() {
        #if canImport(UIKit)
        // Build up
        let soft = UIImpactFeedbackGenerator(style: .soft)
        soft.prepare()
        soft.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            let medium = UIImpactFeedbackGenerator(style: .medium)
            medium.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            let heavy = UIImpactFeedbackGenerator(style: .heavy)
            heavy.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
        #endif
    }
    
    /// Badge unlock celebration.
    static func badgeUnlock() {
        #if canImport(UIKit)
        // Triple tap pattern
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
        #endif
    }
    
    /// Arc completion celebration with dramatic escalation.
    static func arcComplete() {
        #if canImport(UIKit)
        // Drumroll effect
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let heavy = UIImpactFeedbackGenerator(style: .heavy)
            heavy.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
        #endif
    }
    
    /// Streak milestone celebration.
    static func streakMilestone() {
        #if canImport(UIKit)
        // Fire pattern
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let medium = UIImpactFeedbackGenerator(style: .medium)
            medium.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
        #endif
    }
    
    /// Tab switch feedback.
    static func tabSwitch() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Pull to refresh feedback.
    static func pullToRefresh() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Swipe action feedback.
    static func swipeAction() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    /// Reset/delete confirmation feedback.
    static func destructiveAction() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
        #endif
    }
}

// MARK: - Haptic View Modifier

struct HapticOnTap: ViewModifier {
    let style: HapticStyle
    
    enum HapticStyle {
        case light
        case medium
        case heavy
        case soft
        case success
        case warning
        case selection
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                triggerHaptic()
            }
    }
    
    private func triggerHaptic() {
        switch style {
        case .light:
            HapticsEngine.lightImpact()
        case .medium:
            HapticsEngine.mediumImpact()
        case .heavy:
            HapticsEngine.heavyImpact()
        case .soft:
            HapticsEngine.softImpact()
        case .success:
            HapticsEngine.success()
        case .warning:
            HapticsEngine.warning()
        case .selection:
            HapticsEngine.selectionChanged()
        }
    }
}

extension View {
    /// Adds haptic feedback on tap.
    func hapticOnTap(_ style: HapticOnTap.HapticStyle = .light) -> some View {
        modifier(HapticOnTap(style: style))
    }
}
