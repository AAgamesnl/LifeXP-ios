import SwiftUI

// MARK: - Interactive Tutorial System
// Provides guided walkthroughs and tooltips for new users
// Now with AWESOME animations and polish!

// MARK: - Tutorial Step Model

struct TutorialStep: Identifiable {
    let id: String
    let title: String
    let message: String
    let iconSystemName: String
    let highlightAnchor: HighlightAnchor?
    let action: TutorialAction?
    let celebrationType: CelebrationType
    let accentColor: Color
    
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
    
    enum CelebrationType {
        case none
        case sparkle
        case confetti
        case pulse
        case bounce
    }
    
    init(
        id: String,
        title: String,
        message: String,
        iconSystemName: String,
        highlightAnchor: HighlightAnchor? = nil,
        action: TutorialAction? = nil,
        celebrationType: CelebrationType = .none,
        accentColor: Color = BrandTheme.accent
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.iconSystemName = iconSystemName
        self.highlightAnchor = highlightAnchor
        self.action = action
        self.celebrationType = celebrationType
        self.accentColor = accentColor
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
                    message: "Your life is about to become an epic adventure. Ready to level up in real life?",
                    iconSystemName: "sparkles",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .confetti,
                    accentColor: BrandTheme.accent
                ),
                TutorialStep(
                    id: "welcome_2",
                    title: "Your Command Center",
                    message: "Home is your daily dashboard. Check momentum, grab quick wins, and reset your focus.",
                    iconSystemName: "house.fill",
                    highlightAnchor: .tab(.home),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.accent
                ),
                TutorialStep(
                    id: "welcome_3",
                    title: "Story Journeys",
                    message: "Journeys are guided arcs with quests and chapters. Pick a storyline and make real progress.",
                    iconSystemName: "book.fill",
                    highlightAnchor: .tab(.journeys),
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.love
                ),
                TutorialStep(
                    id: "welcome_4",
                    title: "Packs = Action Lists",
                    message: "Packs hold your checklist items. Tap into any pack to earn XP with quick, focused actions.",
                    iconSystemName: "checklist",
                    highlightAnchor: .tab(.packs),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.success
                ),
                TutorialStep(
                    id: "welcome_5",
                    title: "Stats & Achievements",
                    message: "Stats shows your XP, streaks, and badges. Track growth and celebrate milestones.",
                    iconSystemName: "chart.bar.xaxis",
                    highlightAnchor: .tab(.stats),
                    action: nil,
                    celebrationType: .bounce,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "welcome_6",
                    title: "Personalize in Settings",
                    message: "Fine-tune your coaching style, focus dimensions, and app preferences anytime.",
                    iconSystemName: "gearshape.fill",
                    highlightAnchor: .tab(.settings),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.mind
                ),
                TutorialStep(
                    id: "welcome_7",
                    title: "Four Life Dimensions",
                    message: "Love ❤️ • Money 💰 • Mind 🧠 • Adventure ⚡\n\nBalance them for a stronger, happier you.",
                    iconSystemName: "circle.grid.2x2.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.mind
                ),
                TutorialStep(
                    id: "welcome_8",
                    title: "Earn XP & Level Up",
                    message: "Every completed item gives XP. Stack it up to level fast and unlock rewards.",
                    iconSystemName: "star.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .bounce,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "welcome_9",
                    title: "Your Journey Begins Now",
                    message: "You're ready. Complete items, follow arcs, and watch your life transform. 🚀",
                    iconSystemName: "rocket.fill",
                    highlightAnchor: nil,
                    action: TutorialStep.TutorialAction(label: "Let's Go!", handler: {}),
                    celebrationType: .confetti,
                    accentColor: BrandTheme.success
                )
            ]
            
        case .firstItem:
            return [
                TutorialStep(
                    id: "item_1",
                    title: "Tap to Complete ✓",
                    message: "Tap any item to mark it done. Each tap is a small victory!",
                    iconSystemName: "checkmark.circle.fill",
                    highlightAnchor: .card("item"),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.success
                ),
                TutorialStep(
                    id: "item_2",
                    title: "XP = Progress",
                    message: "Harder items reward more XP. Choose wisely based on your energy level!",
                    iconSystemName: "star.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "item_3",
                    title: "Combo Power! ⚡",
                    message: "Complete items within 5 minutes to build combos. 2x, 3x, even 4x XP multipliers!",
                    iconSystemName: "bolt.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .bounce,
                    accentColor: BrandTheme.adventure
                )
            ]
            
        case .arcsIntro:
            return [
                TutorialStep(
                    id: "arc_1",
                    title: "Epic Story Arcs 📖",
                    message: "Arcs are guided quests for real life change. Like chapters in your personal story.",
                    iconSystemName: "book.fill",
                    highlightAnchor: .tab(.journeys),
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.accent
                ),
                TutorialStep(
                    id: "arc_2",
                    title: "Choose Your Quest",
                    message: "Heart Repair? Money Reset? Calm Mind? Pick what speaks to you right now.",
                    iconSystemName: "flag.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.love
                ),
                TutorialStep(
                    id: "arc_3",
                    title: "Unlock Legendary Status",
                    message: "Complete all chapters in an arc = legendary badge + massive XP boost! 🏆",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .confetti,
                    accentColor: BrandTheme.warning
                )
            ]
            
        case .dimensionsExplained:
            return [
                TutorialStep(
                    id: "dim_1",
                    title: "The Four Pillars",
                    message: "A balanced life means growing in all dimensions. Here's your roadmap:",
                    iconSystemName: "circle.grid.2x2.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.accent
                ),
                TutorialStep(
                    id: "dim_2",
                    title: "❤️ Love",
                    message: "Deep connections, self-care, and emotional intelligence. The foundation of happiness.",
                    iconSystemName: "heart.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.love
                ),
                TutorialStep(
                    id: "dim_3",
                    title: "💰 Money",
                    message: "Financial freedom, smart decisions, and building the life you deserve.",
                    iconSystemName: "dollarsign.circle.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.money
                ),
                TutorialStep(
                    id: "dim_4",
                    title: "🧠 Mind",
                    message: "Clarity, growth, and becoming the best version of yourself. Your greatest asset.",
                    iconSystemName: "brain.head.profile",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.mind
                ),
                TutorialStep(
                    id: "dim_5",
                    title: "⚡ Adventure",
                    message: "New experiences, bold moves, and living without regrets. Make memories!",
                    iconSystemName: "safari.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.adventure
                ),
                TutorialStep(
                    id: "dim_6",
                    title: "Perfect Balance = Unstoppable",
                    message: "We'll show you which dimension needs attention. Trust the process!",
                    iconSystemName: "scale.3d",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .confetti,
                    accentColor: BrandTheme.success
                )
            ]
            
        case .streaksGuide:
            return [
                TutorialStep(
                    id: "streak_1",
                    title: "Ignite Your Streak 🔥",
                    message: "One item per day keeps the streak alive. Small wins compound into big results!",
                    iconSystemName: "flame.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "streak_2",
                    title: "Streak = Power",
                    message: "3 days = badge. 7 days = bigger badge. 21 days = UNSTOPPABLE badge! 🏆",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .bounce,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "streak_3",
                    title: "Fall Down, Get Up",
                    message: "Broke your streak? No shame. Champions restart. Your best streak is forever remembered.",
                    iconSystemName: "arrow.counterclockwise",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.success
                )
            ]
            
        case .badgesOverview:
            return [
                TutorialStep(
                    id: "badge_1",
                    title: "Collect Badges 🏆",
                    message: "Badges = proof of your progress. Bronze → Silver → Gold → Diamond tiers await!",
                    iconSystemName: "rosette",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "badge_2",
                    title: "How to Unlock",
                    message: "XP milestones, streak achievements, arc completions, and dimension mastery all unlock badges.",
                    iconSystemName: "lock.open.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.success
                ),
                TutorialStep(
                    id: "badge_3",
                    title: "Your Trophy Case",
                    message: "All your achievements in one place. Show off your collection and aim for 100%!",
                    iconSystemName: "trophy.fill",
                    highlightAnchor: .tab(.stats),
                    action: nil,
                    celebrationType: .confetti,
                    accentColor: BrandTheme.warning
                )
            ]
            
        case .settingsWalkthrough:
            return [
                TutorialStep(
                    id: "settings_1",
                    title: "Make It Yours ⚙️",
                    message: "Life XP adapts to YOU. Customize everything in Settings.",
                    iconSystemName: "gearshape.fill",
                    highlightAnchor: .tab(.settings),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.mind
                ),
                TutorialStep(
                    id: "settings_2",
                    title: "Your Coaching Style",
                    message: "Soft & gentle or Real talk? Pick how you want to be motivated.",
                    iconSystemName: "bubble.left.and.bubble.right.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .none,
                    accentColor: BrandTheme.love
                ),
                TutorialStep(
                    id: "settings_3",
                    title: "Focus Mode",
                    message: "Overwhelmed? Enable only the dimensions that matter most right now.",
                    iconSystemName: "target",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.success
                )
            ]
            
        case .gamificationFeatures:
            return [
                TutorialStep(
                    id: "game_1",
                    title: "Daily Challenges 🎯",
                    message: "Fresh challenges every 24 hours. Complete them for bonus XP!",
                    iconSystemName: "target",
                    highlightAnchor: .card("challenges"),
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.warning
                ),
                TutorialStep(
                    id: "game_2",
                    title: "Combo System ⚡",
                    message: "Quick completions = combos. Combos = XP multipliers. Go fast, earn more!",
                    iconSystemName: "bolt.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .bounce,
                    accentColor: BrandTheme.adventure
                ),
                TutorialStep(
                    id: "game_3",
                    title: "Mood Check-ins",
                    message: "Tell us how you feel. We'll suggest items that match your energy.",
                    iconSystemName: "face.smiling.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.love
                ),
                TutorialStep(
                    id: "game_4",
                    title: "Skill Trees 🌳",
                    message: "Each dimension has skills to unlock. Watch your character evolve!",
                    iconSystemName: "chart.bar.doc.horizontal.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .pulse,
                    accentColor: BrandTheme.mind
                ),
                TutorialStep(
                    id: "game_5",
                    title: "Custom Goals 🚩",
                    message: "Set your own goals with milestones. Your dreams, your rules!",
                    iconSystemName: "flag.fill",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .sparkle,
                    accentColor: BrandTheme.success
                ),
                TutorialStep(
                    id: "game_6",
                    title: "Seasonal Events 🎉",
                    message: "Special limited-time events with exclusive rewards. Don't miss out!",
                    iconSystemName: "sparkles",
                    highlightAnchor: nil,
                    action: nil,
                    celebrationType: .confetti,
                    accentColor: BrandTheme.accent
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
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var backdropOpacity: Double = 0
    @State private var cardOffset: CGFloat = 24
    @State private var showSparkles: Bool = false
    @State private var showConfetti: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var transitionDirection: TransitionDirection = .forward
    
    private enum TransitionDirection {
        case forward
        case backward
    }
    
    var body: some View {
        if manager.isShowingTutorial, let step = manager.currentStep {
            ZStack {
                // Animated backdrop with gradient
                ZStack {
                    Color.black.opacity(0.7)
                    
                    // Subtle gradient overlay for depth
                    LinearGradient(
                        colors: [
                            step.accentColor.opacity(0.1),
                            Color.clear,
                            step.accentColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .ignoresSafeArea()
                .opacity(backdropOpacity)
                .onTapGesture {
                    dismissWithAnimation()
                }
                
                // Floating particles in background
                TutorialParticlesView(color: step.accentColor, intensity: .subtle)
                
                if showSparkles {
                    TutorialParticlesView(color: step.accentColor, intensity: .sparkle)
                }
                
                // Confetti for special moments
                if showConfetti {
                    ConfettiView(isActive: $showConfetti, particleCount: 40)
                }
                
                // Tutorial card
                VStack(spacing: 0) {
                    Spacer()
                    
                    TutorialCard(
                        step: step,
                        stepIndex: manager.currentStepIndex,
                        totalSteps: manager.totalSteps,
                        onNext: { 
                            HapticsEngine.lightImpact()
                            manager.nextStep() 
                        },
                        onPrevious: { 
                            HapticsEngine.lightImpact()
                            manager.previousStep() 
                        },
                        onSkip: { 
                            dismissWithAnimation()
                        },
                        isLastStep: manager.isLastStep
                    )
                    .scaleEffect(cardScale)
                    .opacity(cardOpacity)
                    .offset(y: cardOffset)
                    .id(step.id)
                    .transition(cardTransition)
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.bottom, DesignSystem.spacing.xxxl)
                }
            }
            .onAppear {
                appearAnimation(for: step)
            }
            .onChange(of: manager.currentStepIndex) { oldValue, newValue in
                transitionDirection = newValue >= oldValue ? .forward : .backward
                if let newStep = manager.currentStep {
                    transitionAnimation(to: newStep)
                }
            }
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: manager.currentStepIndex)
        }
    }
    
    private var cardTransition: AnyTransition {
        let insertionEdge: Edge = transitionDirection == .forward ? .trailing : .leading
        let removalEdge: Edge = transitionDirection == .forward ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: insertionEdge).combined(with: .opacity),
            removal: .move(edge: removalEdge).combined(with: .opacity)
        )
    }
    
    private func appearAnimation(for step: TutorialStep) {
        withAnimation(.easeOut(duration: 0.3)) {
            backdropOpacity = 1
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.1)) {
            cardScale = 1
            cardOpacity = 1
            cardOffset = 0
        }
        
        triggerCelebration(for: step)
        HapticsEngine.softCelebrate()
    }
    
    private func transitionAnimation(to step: TutorialStep) {
        // Gentle micro-transition without disappearing
        withAnimation(.easeInOut(duration: 0.2)) {
            cardScale = 0.98
            cardOffset = 8
            cardOpacity = 1
        }
        
        // Reset celebrations
        showSparkles = false
        showConfetti = false
        
        // Entrance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                cardScale = 1
                cardOpacity = 1
                cardOffset = 0
            }
            
            triggerCelebration(for: step)
            HapticsEngine.lightImpact()
        }
    }
    
    private func triggerCelebration(for step: TutorialStep) {
        switch step.celebrationType {
        case .confetti:
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
            }
        case .sparkle:
            showSparkles = true
        case .pulse:
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
        case .bounce:
            // Handled in TutorialCard
            break
        case .none:
            break
        }
    }
    
    private func dismissWithAnimation() {
        withAnimation(.easeIn(duration: 0.2)) {
            cardScale = 0.8
            cardOpacity = 0
            backdropOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            manager.skipTutorial()
        }
    }
}

// MARK: - Tutorial Particles View

struct TutorialParticlesView: View {
    let color: Color
    @State private var particles: [TutorialParticle] = []
    let intensity: Intensity
    
    enum Intensity {
        case subtle
        case sparkle
    }
    
    struct TutorialParticle: Identifiable {
        let id = UUID()
        let baseX: CGFloat
        let offsetY: CGFloat
        let scale: CGFloat
        let opacity: Double
        let driftSpeed: Double
        let swayAmplitude: CGFloat
        let phase: Double
        let rotationSpeed: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
                let time = timeline.date.timeIntervalSinceReferenceDate
                ZStack {
                    ForEach(particles) { particle in
                        let travel = (time * particle.driftSpeed + particle.phase)
                            .truncatingRemainder(dividingBy: Double(geometry.size.height + 80))
                        let yPosition = geometry.size.height - CGFloat(travel) + particle.offsetY
                        let xPosition = particle.baseX + particle.swayAmplitude * CGFloat(sin(time * 0.7 + particle.phase))
                        let rotation = time * particle.rotationSpeed
                        
                        Image(systemName: "sparkle")
                            .font(.system(size: 12))
                            .foregroundColor(color)
                            .scaleEffect(particle.scale)
                            .opacity(particle.opacity)
                            .rotationEffect(.degrees(rotation))
                            .position(x: xPosition, y: yPosition)
                    }
                }
                .onAppear {
                    createParticles(in: geometry.size)
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            TutorialParticle(
                baseX: CGFloat.random(in: 12...max(12, size.width - 12)),
                offsetY: CGFloat.random(in: -40...40),
                scale: CGFloat.random(in: scaleRange),
                opacity: Double.random(in: opacityRange),
                driftSpeed: Double.random(in: driftSpeedRange),
                swayAmplitude: CGFloat.random(in: swayRange),
                phase: Double.random(in: 0...120),
                rotationSpeed: Double.random(in: rotationRange)
            )
        }
    }
    
    private var particleCount: Int {
        switch intensity {
        case .subtle:
            return 14
        case .sparkle:
            return 26
        }
    }
    
    private var opacityRange: ClosedRange<Double> {
        switch intensity {
        case .subtle:
            return 0.18...0.35
        case .sparkle:
            return 0.35...0.75
        }
    }
    
    private var scaleRange: ClosedRange<CGFloat> {
        switch intensity {
        case .subtle:
            return 0.5...1.0
        case .sparkle:
            return 0.7...1.4
        }
    }
    
    private var driftSpeedRange: ClosedRange<Double> {
        switch intensity {
        case .subtle:
            return 14...26
        case .sparkle:
            return 20...36
        }
    }
    
    private var swayRange: ClosedRange<CGFloat> {
        switch intensity {
        case .subtle:
            return 4...10
        case .sparkle:
            return 8...18
        }
    }
    
    private var rotationRange: ClosedRange<Double> {
        switch intensity {
        case .subtle:
            return -12...12
        case .sparkle:
            return -24...24
        }
    }
}

private struct TutorialCardParticlesView: View {
    let color: Color
    @State private var particles: [TutorialCardParticle] = []
    
    struct TutorialCardParticle: Identifiable {
        let id = UUID()
        let baseX: CGFloat
        let baseY: CGFloat
        let scale: CGFloat
        let opacity: Double
        let driftSpeed: Double
        let phase: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
                let time = timeline.date.timeIntervalSinceReferenceDate
                ZStack {
                    ForEach(particles) { particle in
                        let x = particle.baseX + CGFloat(sin(time * 0.5 + particle.phase)) * 8
                        let y = particle.baseY + CGFloat(cos(time * particle.driftSpeed + particle.phase)) * 6
                        
                        Circle()
                            .fill(color.opacity(particle.opacity))
                            .frame(width: 4 * particle.scale, height: 4 * particle.scale)
                            .position(x: x, y: y)
                    }
                }
                .onAppear {
                    createParticles(in: geometry.size)
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<14).map { _ in
            TutorialCardParticle(
                baseX: CGFloat.random(in: 20...max(20, size.width - 20)),
                baseY: CGFloat.random(in: 20...max(20, size.height - 20)),
                scale: CGFloat.random(in: 0.6...1.2),
                opacity: Double.random(in: 0.12...0.24),
                driftSpeed: Double.random(in: 0.4...0.8),
                phase: Double.random(in: 0...6.28)
            )
        }
    }
}

private struct TutorialCardAmbientGlow: View {
    let color: Color
    @State private var glowShift: CGFloat = -16
    
    var body: some View {
        RadialGradient(
            colors: [
                color.opacity(0.22),
                color.opacity(0.12),
                Color.clear
            ],
            center: .topLeading,
            startRadius: 20,
            endRadius: 220
        )
        .offset(x: glowShift, y: -glowShift)
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                glowShift = 16
            }
        }
        .allowsHitTesting(false)
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
    
    @State private var iconBounce: Bool = false
    @State private var iconRotation: Double = 0
    @State private var glowPulse: Bool = false
    @State private var progressAnimated: Bool = false
    @State private var floatingCard: Bool = false
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xl) {
            // Animated progress bar
            TutorialProgressBar(
                currentStep: stepIndex,
                totalSteps: totalSteps,
                color: step.accentColor
            )
            
            // Animated icon with glow
            ZStack {
                // Outer glow ring (animated)
                Circle()
                    .fill(step.accentColor.opacity(0.15))
                    .frame(width: 110, height: 110)
                    .scaleEffect(glowPulse ? 1.15 : 1.0)
                    .opacity(glowPulse ? 0.5 : 0.8)
                
                // Middle ring
                Circle()
                    .fill(step.accentColor.opacity(0.25))
                    .frame(width: 95, height: 95)
                
                // Main icon container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [step.accentColor, step.accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: step.iconSystemName)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(iconRotation))
                        .scaleEffect(iconBounce ? 1.15 : 1.0)
                }
                .shadow(color: step.accentColor.opacity(0.5), radius: 20, y: 8)
            }
            
            // Content with animation
            VStack(spacing: DesignSystem.spacing.md) {
                Text(step.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(BrandTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(step.message)
                    .font(DesignSystem.text.bodyMedium)
                    .foregroundColor(BrandTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            .padding(.horizontal, DesignSystem.spacing.sm)
            
            // Enhanced action buttons
            HStack(spacing: DesignSystem.spacing.md) {
                if stepIndex > 0 {
                    Button(action: onPrevious) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                        }
                        .foregroundColor(BrandTheme.textSecondary)
                        .padding(.horizontal, DesignSystem.spacing.md)
                        .padding(.vertical, DesignSystem.spacing.sm)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                if !isLastStep {
                    Button("Skip") {
                        onSkip()
                    }
                    .foregroundColor(BrandTheme.mutedText)
                    .font(.system(size: 14, weight: .medium))
                }
                
                // Main action button with glow
                Button(action: {
                    if let action = step.action {
                        action.handler()
                    }
                    onNext()
                }) {
                    HStack(spacing: 8) {
                        Text(isLastStep ? (step.action?.label ?? "Let's Go!") : "Continue")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                        
                        Image(systemName: isLastStep ? "sparkles" : "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, DesignSystem.spacing.xl)
                    .padding(.vertical, DesignSystem.spacing.md)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [step.accentColor, step.accentColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: step.accentColor.opacity(0.4), radius: 12, y: 6)
                }
                .buttonStyle(TutorialButtonStyle())
            }
        }
        .padding(DesignSystem.spacing.xl)
        .padding(.top, DesignSystem.spacing.sm)
        .background(
            ZStack {
                // Glass effect background
                RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                BrandTheme.cardBackground.opacity(0.9),
                                BrandTheme.cardBackground.opacity(0.95)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                TutorialCardAmbientGlow(color: step.accentColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                    )
                
                TutorialCardParticlesView(color: step.accentColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                    )
                
                // Accent glow at top
                VStack {
                    LinearGradient(
                        colors: [step.accentColor.opacity(0.2), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .clipShape(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                    )
                    Spacer()
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xxl, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [step.accentColor.opacity(0.3), BrandTheme.borderSubtle.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: step.accentColor.opacity(0.15), radius: 40, y: 20)
        .shadow(color: Color.black.opacity(0.2), radius: 30, y: 15)
        .offset(y: floatingCard ? -4 : 4)
        .rotation3DEffect(
            .degrees(floatingCard ? 0.6 : -0.6),
            axis: (x: 1, y: 0, z: 0)
        )
        .onAppear {
            startAnimations()
        }
        .onChange(of: stepIndex) { _, _ in
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Reset states
        iconBounce = false
        iconRotation = -10
        glowPulse = false
        floatingCard = false
        
        // Animate icon entrance
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1)) {
            iconRotation = 0
        }
        
        // Bounce effect based on celebration type
        if step.celebrationType == .bounce {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.2)) {
                iconBounce = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    iconBounce = false
                }
            }
        }
        
        // Glow pulse
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3)) {
            glowPulse = true
        }
        
        withAnimation(.easeInOut(duration: 5.5).repeatForever(autoreverses: true).delay(0.4)) {
            floatingCard = true
        }
    }
}

// MARK: - Tutorial Progress Bar

struct TutorialProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? color : BrandTheme.borderSubtle.opacity(0.5))
                    .frame(width: index == currentStep ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentStep)
            }
        }
    }
}

// MARK: - Tutorial Button Style

struct TutorialButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Tutorial List View

struct TutorialListView: View {
    @EnvironmentObject var manager: TutorialManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSequence: TutorialSequence?
    @State private var showAnimation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Animated Header
                    VStack(spacing: DesignSystem.spacing.md) {
                        ZStack {
                            TutorialHeaderRings(isAnimating: showAnimation)
                            IconContainer(
                                systemName: "book.fill",
                                color: BrandTheme.accent,
                                size: .hero,
                                style: .gradient
                            )
                        }
                        .frame(width: 170, height: 170)
                        
                        Text("Master Life XP")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text("Interactive guides to unlock your full potential")
                            .font(DesignSystem.text.bodyMedium)
                            .foregroundColor(BrandTheme.mutedText)
                            .multilineTextAlignment(.center)
                        
                        // Progress indicator
                        let completed = manager.completedSequences.count
                        let total = TutorialSequence.allCases.count
                        
                        HStack(spacing: DesignSystem.spacing.sm) {
                            ProgressView(value: Double(completed), total: Double(total))
                                .tint(BrandTheme.accent)
                            
                            Text("\(completed)/\(total)")
                                .font(.caption.bold())
                                .foregroundColor(BrandTheme.accent)
                        }
                        .padding(.horizontal, DesignSystem.spacing.xl)
                    }
                    .padding(.top, DesignSystem.spacing.xl)
                    .padding(.bottom, DesignSystem.spacing.md)
                    
                    // Tutorial list with categories
                    VStack(spacing: DesignSystem.spacing.lg) {
                        // Essential tutorials
                        TutorialCategorySection(
                            title: "Getting Started",
                            icon: "star.fill",
                            tutorials: [.welcome, .firstItem, .dimensionsExplained],
                            manager: manager,
                            onSelect: selectTutorial
                        )
                        
                        // Advanced tutorials
                        TutorialCategorySection(
                            title: "Level Up Your Game",
                            icon: "flame.fill",
                            tutorials: [.arcsIntro, .streaksGuide, .badgesOverview],
                            manager: manager,
                            onSelect: selectTutorial
                        )
                        
                        // Pro features
                        TutorialCategorySection(
                            title: "Pro Features",
                            icon: "crown.fill",
                            tutorials: [.gamificationFeatures, .settingsWalkthrough],
                            manager: manager,
                            onSelect: selectTutorial
                        )
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    
                    // Reset button
                    if !manager.completedSequences.isEmpty {
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                manager.resetAllTutorials()
                            }
                            HapticsEngine.lightImpact()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset Progress")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BrandTheme.error)
                            .padding(.horizontal, DesignSystem.spacing.lg)
                            .padding(.vertical, DesignSystem.spacing.sm)
                            .background(
                                Capsule()
                                    .fill(BrandTheme.error.opacity(0.1))
                            )
                        }
                        .buttonStyle(.plain)
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
            .onAppear {
                showAnimation = true
            }
        }
    }
    
    private func selectTutorial(_ sequence: TutorialSequence) {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            manager.startTutorial(sequence)
        }
    }
}

private struct TutorialHeaderRings: View {
    let isAnimating: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                let size = CGFloat(104 + index * 26)
                Circle()
                    .stroke(BrandTheme.accent.opacity(0.24 - Double(index) * 0.06), lineWidth: 2)
                    .frame(width: size, height: size)
                    .scaleEffect(isAnimating ? 1.05 + CGFloat(index) * 0.02 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .drawingGroup()
        .allowsHitTesting(false)
    }
}

// MARK: - Tutorial Category Section

struct TutorialCategorySection: View {
    let title: String
    let icon: String
    let tutorials: [TutorialSequence]
    let manager: TutorialManager
    let onSelect: (TutorialSequence) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            // Category header
            HStack(spacing: DesignSystem.spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(BrandTheme.accent)
                
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(BrandTheme.textSecondary)
                    .textCase(.uppercase)
            }
            
            // Tutorial cards
            VStack(spacing: DesignSystem.spacing.sm) {
                ForEach(tutorials, id: \.rawValue) { sequence in
                    TutorialListRow(
                        sequence: sequence,
                        isCompleted: manager.hasCompleted(sequence)
                    ) {
                        onSelect(sequence)
                    }
                }
            }
        }
    }
}

struct TutorialListRow: View {
    let sequence: TutorialSequence
    let isCompleted: Bool
    let onStart: () -> Void
    
    @State private var isPressed = false
    
    private var accentColor: Color {
        switch sequence {
        case .welcome: return BrandTheme.accent
        case .firstItem: return BrandTheme.success
        case .arcsIntro: return BrandTheme.love
        case .dimensionsExplained: return BrandTheme.mind
        case .streaksGuide: return BrandTheme.warning
        case .badgesOverview: return BrandTheme.warning
        case .settingsWalkthrough: return BrandTheme.mind
        case .gamificationFeatures: return BrandTheme.adventure
        }
    }
    
    var body: some View {
        Button(action: {
            HapticsEngine.lightImpact()
            onStart()
        }) {
            HStack(spacing: DesignSystem.spacing.md) {
                // Animated Icon
                ZStack {
                    Circle()
                        .fill(isCompleted ? BrandTheme.success.opacity(0.15) : accentColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: sequence.iconSystemName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isCompleted ? BrandTheme.success : accentColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(sequence.title)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        if isCompleted {
                            HStack(spacing: 2) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                Text("Done")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(BrandTheme.success)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(BrandTheme.success.opacity(0.15))
                            )
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "play.circle")
                            .font(.system(size: 12))
                        Text("\(sequence.steps.count) interactive steps")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                // Play button
                ZStack {
                    Circle()
                        .fill(isCompleted ? BrandTheme.success.opacity(0.1) : accentColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: isCompleted ? "arrow.clockwise" : "play.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isCompleted ? BrandTheme.success : accentColor)
                }
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(
                        isCompleted ? BrandTheme.success.opacity(0.2) : accentColor.opacity(0.15),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                isPressed = pressing
            }
        }, perform: {})
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
    @EnvironmentObject var tutorialManager: TutorialManager
    @State private var showTutorials = false
    @State private var isAnimating = false
    
    var body: some View {
        Button {
            HapticsEngine.lightImpact()
            showTutorials = true
        } label: {
            ZStack {
                // Subtle pulse animation for first-time users
                if !tutorialManager.hasCompleted(.welcome) {
                    Circle()
                        .fill(BrandTheme.accent.opacity(0.2))
                        .frame(width: 36, height: 36)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .opacity(isAnimating ? 0 : 0.5)
                }
                
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [BrandTheme.accent, BrandTheme.accent.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .sheet(isPresented: $showTutorials) {
            TutorialListView()
                .environmentObject(tutorialManager)
        }
        .onAppear {
            if !tutorialManager.hasCompleted(.welcome) {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
        }
    }
}
