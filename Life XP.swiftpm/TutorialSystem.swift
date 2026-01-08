import SwiftUI

// MARK: - Interactive Tutorial System
// Provides guided walkthroughs and tooltips for new users

// MARK: - Tutorial Step Model

struct TutorialStep: Identifiable {
    let id: String
    let title: String
    let message: String
    let iconSystemName: String
    let highlightAnchor: HighlightAnchor?
    let action: TutorialAction?
    
    enum HighlightAnchor {
        case tab(Tab)
        case card(String)
        case button(String)
        case custom(CGRect)
        
        enum Tab: String {
            case home, journeys, packs, stats, settings
        }
    }
    
    struct TutorialAction {
        let label: String
        let handler: () -> Void
    }
}

// MARK: - Tutorial Sequences

enum TutorialSequence: String, CaseIterable {
    case welcome
    case firstItem
    case arcsIntro
    case dimensionsExplained
    case streaksGuide
    case badgesOverview
    case settingsWalkthrough
    case gamificationFeatures
    
    var steps: [TutorialStep] {
        switch self {
        case .welcome:
            return [
                TutorialStep(
                    id: "welcome_1",
                    title: "Welcome to Life XP! 🎮",
                    message: "Your life is about to become an adventure game. Let's show you around!",
                    iconSystemName: "sparkles",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "welcome_2",
                    title: "This is Your Home",
                    message: "Here you'll see your progress, daily challenges, and quick wins. Everything starts here.",
                    iconSystemName: "house.fill",
                    highlightAnchor: .tab(.home),
                    action: nil
                ),
                TutorialStep(
                    id: "welcome_3",
                    title: "Four Life Dimensions",
                    message: "We track your growth in Love ❤️, Money 💰, Mind 🧠, and Adventure ⚡. Balance is key!",
                    iconSystemName: "circle.grid.2x2.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "welcome_4",
                    title: "Earn XP & Level Up",
                    message: "Complete items to earn XP. Level up to unlock badges and celebrate your progress!",
                    iconSystemName: "star.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "welcome_5",
                    title: "Ready to Start?",
                    message: "Let's complete your first item together and see how it works!",
                    iconSystemName: "play.fill",
                    highlightAnchor: nil,
                    action: TutorialStep.TutorialAction(label: "Let's Go!", handler: {})
                )
            ]
            
        case .firstItem:
            return [
                TutorialStep(
                    id: "item_1",
                    title: "Completing Items",
                    message: "Tap any item to mark it complete. You can also swipe right for a quick complete!",
                    iconSystemName: "checkmark.circle.fill",
                    highlightAnchor: .card("item"),
                    action: nil
                ),
                TutorialStep(
                    id: "item_2",
                    title: "XP Rewards",
                    message: "Each item rewards XP based on difficulty. Harder items = more XP!",
                    iconSystemName: "star.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "item_3",
                    title: "Combos Multiply XP",
                    message: "Complete items quickly to build combos. Higher combos = XP multipliers!",
                    iconSystemName: "bolt.fill",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
            
        case .arcsIntro:
            return [
                TutorialStep(
                    id: "arc_1",
                    title: "Story Arcs",
                    message: "Arcs are guided journeys with chapters and quests. They help you tackle big life goals step by step.",
                    iconSystemName: "book.fill",
                    highlightAnchor: .tab(.journeys),
                    action: nil
                ),
                TutorialStep(
                    id: "arc_2",
                    title: "Pick Your Adventure",
                    message: "Choose an arc that resonates with where you are in life. You can have multiple arcs active!",
                    iconSystemName: "flag.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "arc_3",
                    title: "Complete Chapters",
                    message: "Work through quests to complete chapters. Finishing an arc unlocks special badges!",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
            
        case .dimensionsExplained:
            return [
                TutorialStep(
                    id: "dim_1",
                    title: "Life Dimensions",
                    message: "Every item contributes to one or more dimensions. Let's break them down:",
                    iconSystemName: "circle.grid.2x2.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "dim_2",
                    title: "❤️ Love",
                    message: "Relationships, connections, self-love, and emotional well-being",
                    iconSystemName: "heart.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "dim_3",
                    title: "💰 Money",
                    message: "Financial health, career growth, savings, and smart spending",
                    iconSystemName: "dollarsign.circle.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "dim_4",
                    title: "🧠 Mind",
                    message: "Mental health, learning, mindfulness, and personal development",
                    iconSystemName: "brain.head.profile",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "dim_5",
                    title: "⚡ Adventure",
                    message: "New experiences, travel, trying new things, and stepping out of comfort zones",
                    iconSystemName: "safari.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "dim_6",
                    title: "Balance Matters",
                    message: "Aim for progress in all dimensions. The app will suggest items to help you balance!",
                    iconSystemName: "scale.3d",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
            
        case .streaksGuide:
            return [
                TutorialStep(
                    id: "streak_1",
                    title: "Build Your Streak 🔥",
                    message: "Complete at least one item per day to build your streak!",
                    iconSystemName: "flame.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "streak_2",
                    title: "Streak Benefits",
                    message: "Longer streaks unlock badges and prove your consistency. Your best streak is always saved!",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "streak_3",
                    title: "Don't Break It!",
                    message: "Missing a day resets your streak. But don't worry - just start again!",
                    iconSystemName: "arrow.counterclockwise",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
            
        case .badgesOverview:
            return [
                TutorialStep(
                    id: "badge_1",
                    title: "Earn Badges 🏆",
                    message: "Badges celebrate your achievements. There are 15+ badges to unlock!",
                    iconSystemName: "rosette",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "badge_2",
                    title: "How to Unlock",
                    message: "Earn XP, maintain streaks, complete arcs, and balance your dimensions to unlock badges.",
                    iconSystemName: "lock.open.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "badge_3",
                    title: "Trophy Case",
                    message: "View all your badges in the Trophy Case. See what you've earned and what's next!",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: .tab(.stats),
                    action: nil
                )
            ]
            
        case .settingsWalkthrough:
            return [
                TutorialStep(
                    id: "settings_1",
                    title: "Customize Your Experience",
                    message: "Make Life XP work for you. Head to Settings to personalize everything.",
                    iconSystemName: "gearshape.fill",
                    highlightAnchor: .tab(.settings),
                    action: nil
                ),
                TutorialStep(
                    id: "settings_2",
                    title: "Coaching Tone",
                    message: "Choose between soft encouragement or real-talk motivation.",
                    iconSystemName: "bubble.left.and.bubble.right.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "settings_3",
                    title: "Focus Dimensions",
                    message: "Enable only the dimensions you want to focus on right now.",
                    iconSystemName: "target",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
            
        case .gamificationFeatures:
            return [
                TutorialStep(
                    id: "game_1",
                    title: "Daily Challenges",
                    message: "New challenges every day! Complete them for bonus XP.",
                    iconSystemName: "target",
                    highlightAnchor: .card("challenges"),
                    action: nil
                ),
                TutorialStep(
                    id: "game_2",
                    title: "Combos & Multipliers",
                    message: "Complete items quickly to build combos. The higher your combo, the more XP you earn!",
                    iconSystemName: "bolt.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "game_3",
                    title: "Mood Tracking",
                    message: "Log your mood to get personalized suggestions based on how you feel.",
                    iconSystemName: "face.smiling.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "game_4",
                    title: "Skill Trees",
                    message: "Progress unlocks skills in each dimension. Watch your character grow!",
                    iconSystemName: "chart.bar.doc.horizontal.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "game_5",
                    title: "Personal Goals",
                    message: "Create your own goals with milestones. Track anything that matters to you!",
                    iconSystemName: "flag.fill",
                    highlightAnchor: nil,
                    action: nil
                ),
                TutorialStep(
                    id: "game_6",
                    title: "Seasonal Events",
                    message: "Special events throughout the year offer bonus XP and exclusive badges!",
                    iconSystemName: "sparkles",
                    highlightAnchor: nil,
                    action: nil
                )
            ]
        }
    }
    
    var title: String {
        switch self {
        case .welcome: return "Welcome Tour"
        case .firstItem: return "Completing Items"
        case .arcsIntro: return "Story Arcs"
        case .dimensionsExplained: return "Life Dimensions"
        case .streaksGuide: return "Streaks"
        case .badgesOverview: return "Badges & Achievements"
        case .settingsWalkthrough: return "Settings"
        case .gamificationFeatures: return "Game Features"
        }
    }
    
    var iconSystemName: String {
        switch self {
        case .welcome: return "hand.wave.fill"
        case .firstItem: return "checkmark.circle.fill"
        case .arcsIntro: return "book.fill"
        case .dimensionsExplained: return "circle.grid.2x2.fill"
        case .streaksGuide: return "flame.fill"
        case .badgesOverview: return "rosette"
        case .settingsWalkthrough: return "gearshape.fill"
        case .gamificationFeatures: return "gamecontroller.fill"
        }
    }
}

// MARK: - Tutorial Manager

@MainActor
final class TutorialManager: ObservableObject {
    @Published var isShowingTutorial = false
    @Published var currentSequence: TutorialSequence?
    @Published var currentStepIndex: Int = 0
    @Published var completedSequences: Set<String> = []
    
    private let storageKey = "lifeXP.tutorialCompleted"
    
    init() {
        loadProgress()
    }
    
    var currentStep: TutorialStep? {
        guard let sequence = currentSequence,
              currentStepIndex < sequence.steps.count else { return nil }
        return sequence.steps[currentStepIndex]
    }
    
    var totalSteps: Int {
        currentSequence?.steps.count ?? 0
    }
    
    var isLastStep: Bool {
        currentStepIndex >= totalSteps - 1
    }
    
    func startTutorial(_ sequence: TutorialSequence) {
        currentSequence = sequence
        currentStepIndex = 0
        isShowingTutorial = true
    }
    
    func nextStep() {
        if isLastStep {
            completeTutorial()
        } else {
            currentStepIndex += 1
        }
    }
    
    func previousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    func skipTutorial() {
        completeTutorial()
    }
    
    private func completeTutorial() {
        if let sequence = currentSequence {
            completedSequences.insert(sequence.rawValue)
            saveProgress()
        }
        
        isShowingTutorial = false
        currentSequence = nil
        currentStepIndex = 0
    }
    
    func hasCompleted(_ sequence: TutorialSequence) -> Bool {
        completedSequences.contains(sequence.rawValue)
    }
    
    func resetAllTutorials() {
        completedSequences.removeAll()
        saveProgress()
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(Array(completedSequences), forKey: storageKey)
    }
    
    private func loadProgress() {
        if let saved = UserDefaults.standard.stringArray(forKey: storageKey) {
            completedSequences = Set(saved)
        }
    }
}

// MARK: - Tutorial Overlay View

struct TutorialOverlay: View {
    @ObservedObject var manager: TutorialManager
    @State private var cardScale: CGFloat = 0.9
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        if manager.isShowingTutorial, let step = manager.currentStep {
            ZStack {
                // Backdrop
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Dismiss on background tap
                        manager.skipTutorial()
                    }
                
                // Tutorial card
                VStack(spacing: 0) {
                    Spacer()
                    
                    TutorialCard(
                        step: step,
                        stepIndex: manager.currentStepIndex,
                        totalSteps: manager.totalSteps,
                        onNext: { manager.nextStep() },
                        onPrevious: { manager.previousStep() },
                        onSkip: { manager.skipTutorial() },
                        isLastStep: manager.isLastStep
                    )
                    .scaleEffect(cardScale)
                    .opacity(cardOpacity)
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.bottom, DesignSystem.spacing.xxxl)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    cardScale = 1
                    cardOpacity = 1
                }
            }
            .onChange(of: manager.currentStepIndex) { _, _ in
                // Animate step change
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    cardScale = 0.95
                    cardOpacity = 0.5
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        cardScale = 1
                        cardOpacity = 1
                    }
                }
            }
        }
    }
}

struct TutorialCard: View {
    let step: TutorialStep
    let stepIndex: Int
    let totalSteps: Int
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onSkip: () -> Void
    let isLastStep: Bool
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xl) {
            // Progress dots
            HStack(spacing: DesignSystem.spacing.sm) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index == stepIndex ? BrandTheme.accent : BrandTheme.borderSubtle)
                        .frame(width: 8, height: 8)
                }
            }
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [BrandTheme.accent, BrandTheme.accentSoft],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: step.iconSystemName)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: BrandTheme.accent.opacity(0.3), radius: 16, y: 8)
            
            // Content
            VStack(spacing: DesignSystem.spacing.md) {
                Text(step.title)
                    .font(DesignSystem.text.headlineLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(step.message)
                    .font(DesignSystem.text.bodyMedium)
                    .foregroundColor(BrandTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Actions
            HStack(spacing: DesignSystem.spacing.lg) {
                if stepIndex > 0 {
                    Button(action: onPrevious) {
                        HStack(spacing: DesignSystem.spacing.sm) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .buttonStyle(GhostButtonStyle())
                }
                
                Spacer()
                
                if !isLastStep {
                    Button("Skip") {
                        onSkip()
                    }
                    .buttonStyle(GhostButtonStyle())
                }
                
                Button(action: {
                    HapticsEngine.lightImpact()
                    if let action = step.action {
                        action.handler()
                    }
                    onNext()
                }) {
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Text(isLastStep ? (step.action?.label ?? "Done") : "Next")
                        if !isLastStep {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .buttonStyle(GlowButtonStyle(size: .medium))
            }
        }
        .padding(DesignSystem.spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                .fill(BrandTheme.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                .strokeBorder(BrandTheme.borderSubtle.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 30, y: 15)
    }
}

// MARK: - Tutorial List View

struct TutorialListView: View {
    @StateObject var manager = TutorialManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Header
                    VStack(spacing: DesignSystem.spacing.md) {
                        IconContainer(
                            systemName: "book.fill",
                            color: BrandTheme.accent,
                            size: .hero,
                            style: .gradient
                        )
                        
                        Text("Learn Life XP")
                            .font(DesignSystem.text.displaySmall)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text("Choose a tutorial to learn about app features")
                            .font(DesignSystem.text.bodyMedium)
                            .foregroundColor(BrandTheme.mutedText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, DesignSystem.spacing.xl)
                    .padding(.bottom, DesignSystem.spacing.md)
                    
                    // Tutorial list
                    VStack(spacing: DesignSystem.spacing.md) {
                        ForEach(TutorialSequence.allCases, id: \.rawValue) { sequence in
                            TutorialListRow(
                                sequence: sequence,
                                isCompleted: manager.hasCompleted(sequence)
                            ) {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    manager.startTutorial(sequence)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    
                    // Reset button
                    if !manager.completedSequences.isEmpty {
                        Button {
                            manager.resetAllTutorials()
                        } label: {
                            Label("Reset All Tutorials", systemImage: "arrow.counterclockwise")
                                .font(DesignSystem.text.labelMedium)
                        }
                        .buttonStyle(GhostButtonStyle(color: BrandTheme.error))
                        .padding(.top, DesignSystem.spacing.xl)
                    }
                }
                .padding(.bottom, DesignSystem.spacing.xxl)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Tutorials")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct TutorialListRow: View {
    let sequence: TutorialSequence
    let isCompleted: Bool
    let onStart: () -> Void
    
    var body: some View {
        Button(action: onStart) {
            HStack(spacing: DesignSystem.spacing.lg) {
                // Icon
                IconContainer(
                    systemName: sequence.iconSystemName,
                    color: isCompleted ? BrandTheme.success : BrandTheme.accent,
                    size: .medium,
                    style: isCompleted ? .filled : .soft
                )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(sequence.title)
                            .font(DesignSystem.text.labelLarge)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(BrandTheme.success)
                        }
                    }
                    
                    Text("\(sequence.steps.count) steps")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(BrandTheme.mutedText)
            }
            .padding(DesignSystem.spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(BrandTheme.borderSubtle.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Tooltip View

struct TooltipView: View {
    let message: String
    var arrowDirection: ArrowDirection = .top
    
    enum ArrowDirection {
        case top, bottom, left, right
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if arrowDirection == .top {
                TooltipArrow()
                    .fill(BrandTheme.cardBackground)
                    .frame(width: 20, height: 10)
            }
            
            HStack(spacing: 0) {
                if arrowDirection == .left {
                    TooltipArrow()
                        .fill(BrandTheme.cardBackground)
                        .frame(width: 10, height: 20)
                        .rotationEffect(.degrees(-90))
                }
                
                Text(message)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                    .padding(.horizontal, DesignSystem.spacing.md)
                    .padding(.vertical, DesignSystem.spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                            .fill(BrandTheme.cardBackground)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
                
                if arrowDirection == .right {
                    TooltipArrow()
                        .fill(BrandTheme.cardBackground)
                        .frame(width: 10, height: 20)
                        .rotationEffect(.degrees(90))
                }
            }
            
            if arrowDirection == .bottom {
                TooltipArrow()
                    .fill(BrandTheme.cardBackground)
                    .frame(width: 20, height: 10)
                    .rotationEffect(.degrees(180))
            }
        }
    }
}

private struct TooltipArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Feature Discovery

struct FeatureDiscoveryView: View {
    let feature: Feature
    let onDismiss: () -> Void
    
    @State private var appeared = false
    
    struct Feature {
        let title: String
        let description: String
        let iconSystemName: String
        let color: Color
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            // Pulsing icon
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .scaleEffect(appeared ? 1.2 : 1)
                    .opacity(appeared ? 0 : 0.5)
                
                Circle()
                    .fill(feature.color)
                    .frame(width: 80, height: 80)
                
                Image(systemName: feature.iconSystemName)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: DesignSystem.spacing.sm) {
                Text("New Feature!")
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(feature.color)
                
                Text(feature.title)
                    .font(DesignSystem.text.headlineLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(feature.description)
                    .font(DesignSystem.text.bodyMedium)
                    .foregroundColor(BrandTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Got it!") {
                onDismiss()
            }
            .buttonStyle(GlowButtonStyle(color: feature.color, size: .medium))
        }
        .padding(DesignSystem.spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                .fill(BrandTheme.cardBackground)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 30, y: 15)
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                appeared = true
            }
        }
    }
}

// MARK: - Quick Help Button

struct QuickHelpButton: View {
    @State private var showTutorials = false
    
    var body: some View {
        Button {
            showTutorials = true
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(BrandTheme.accent)
        }
        .sheet(isPresented: $showTutorials) {
            TutorialListView()
        }
    }
}
