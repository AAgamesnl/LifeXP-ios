import SwiftUI

/// TimelineView wrapper that pauses animations when the scene is inactive,
/// reduce-motion is enabled, or the view is off-screen.
struct AdaptiveTimelineView<Content: View>: View {
    let minimumInterval: TimeInterval
    let isActive: Bool
    let content: (TimelineView<AnimationTimelineSchedule, Content>.Context) -> Content

    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false

    init(
        minimumInterval: TimeInterval = 1.0 / 120,
        isActive: Bool = true,
        @ViewBuilder content: @escaping (TimelineView<AnimationTimelineSchedule, Content>.Context) -> Content
    ) {
        self.minimumInterval = minimumInterval
        self.isActive = isActive
        self.content = content
    }

    private var shouldPause: Bool {
        reduceMotion || scenePhase != .active || !isVisible || !isActive
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: minimumInterval, paused: shouldPause)) { timeline in
            content(timeline)
        }
        .onAppear {
            isVisible = true
        }
        .onDisappear {
            isVisible = false
        }
    }
}
