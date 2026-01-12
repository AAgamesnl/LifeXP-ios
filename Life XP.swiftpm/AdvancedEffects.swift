import SwiftUI

// MARK: - Advanced Visual Effects & Animations
// Premium-quality visual effects optimized for smooth 120fps performance

// MARK: - Optimized Animation Presets

/// High-performance animation presets for smooth 120fps
struct SilkyAnimation {
    /// Ultra-fast micro-interaction (16ms response)
    static let micro = Animation.spring(response: 0.22, dampingFraction: 0.92)
    /// Instant feedback for taps
    static let tap = Animation.spring(response: 0.28, dampingFraction: 0.88)
    /// Snappy state transitions
    static let snappy = Animation.spring(response: 0.32, dampingFraction: 0.84)
    /// Smooth general animations
    static let smooth = Animation.spring(response: 0.48, dampingFraction: 0.88)
    /// Gentle easing for subtle changes
    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.92)
    /// Bouncy celebration effect
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.68)
    /// Elastic for playful interactions
    static let elastic = Animation.spring(response: 0.55, dampingFraction: 0.6)
}

// MARK: - Completion Particles (GPU Accelerated)

struct CompletionParticles: View {
    @Binding var isActive: Bool
    var color: Color = BrandTheme.success
    var particleCount: Int = 16
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var particles: [ParticleData] = []
    
    struct ParticleData: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
        let angle: Double
    }
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x - 5 * particle.scale,
                        y: particle.y - 5 * particle.scale,
                        width: 10 * particle.scale,
                        height: 10 * particle.scale
                    )
                    
                    context.opacity = particle.opacity
                    context.fill(Circle().path(in: rect), with: .color(color))
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue && !reduceMotion {
                    emitParticles(in: geo.size)
                } else if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isActive = false
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func emitParticles(in size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        particles = (0..<particleCount).map { i in
            let angle = (Double(i) / Double(particleCount)) * 2 * .pi
            return ParticleData(
                x: centerX,
                y: centerY,
                scale: CGFloat.random(in: 0.5...1.2),
                opacity: 1,
                angle: angle
            )
        }
        
        withAnimation(.easeOut(duration: 0.5)) {
            particles = particles.map { p in
                var particle = p
                let distance = CGFloat.random(in: 50...80)
                particle.x += cos(p.angle) * distance
                particle.y += sin(p.angle) * distance
                particle.scale *= 0.3
                particle.opacity = 0
                return particle
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isActive = false
            particles = []
        }
    }
}

// MARK: - Firework Effect (120fps Canvas)

struct FireworkEffect: View {
    @Binding var isActive: Bool
    var colors: [Color] = [BrandTheme.accent, BrandTheme.success, BrandTheme.warning, BrandTheme.love]
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bursts: [BurstData] = []
    
    struct BurstData: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var particles: [BurstParticle]
    }
    
    struct BurstParticle: Identifiable {
        let id = UUID()
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var scale: CGFloat = 1
        var opacity: Double = 1
        let angle: Double
        let colorIndex: Int
    }
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for burst in bursts {
                    for particle in burst.particles {
                        let x = burst.x + particle.offsetX
                        let y = burst.y + particle.offsetY
                        let particleSize = 6 * particle.scale
                        
                        let rect = CGRect(
                            x: x - particleSize / 2,
                            y: y - particleSize / 2,
                            width: particleSize,
                            height: particleSize
                        )
                        
                        context.opacity = particle.opacity
                        context.fill(Circle().path(in: rect), with: .color(colors[particle.colorIndex % colors.count]))
                    }
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue && !reduceMotion {
                    createFirework(in: geo.size)
                } else if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        isActive = false
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createFirework(in size: CGSize) {
        for burstIndex in 0..<2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(burstIndex) * 0.12) {
                let x = CGFloat.random(in: size.width * 0.25...size.width * 0.75)
                let y = CGFloat.random(in: size.height * 0.2...size.height * 0.5)
                
                let particleCount = 12
                let particles = (0..<particleCount).map { i in
                    let angle = Double(i) / Double(particleCount) * 2 * .pi
                    return BurstParticle(angle: angle, colorIndex: Int.random(in: 0..<colors.count))
                }
                
                let burst = BurstData(x: x, y: y, particles: particles)
                bursts.append(burst)
                
                withAnimation(.easeOut(duration: 0.45)) {
                    if let index = bursts.firstIndex(where: { $0.id == burst.id }) {
                        bursts[index].particles = bursts[index].particles.map { p in
                            var particle = p
                            let distance = CGFloat.random(in: 40...70)
                            particle.offsetX = cos(p.angle) * distance
                            particle.offsetY = sin(p.angle) * distance
                            return particle
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        if let index = bursts.firstIndex(where: { $0.id == burst.id }) {
                            bursts[index].particles = bursts[index].particles.map { p in
                                var particle = p
                                particle.opacity = 0
                                particle.scale = 0.2
                                return particle
                            }
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isActive = false
            bursts = []
        }
    }
}

// MARK: - Glow Pulse Effect

struct GlowPulseEffect: ViewModifier {
    let color: Color
    let isActive: Bool
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var glowOpacity: Double = 0
    @State private var glowRadius: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Radii.lg, style: .continuous)
                    .fill(color.opacity(glowOpacity))
                    .blur(radius: glowRadius)
                    .scaleEffect(1.1)
            )
            .onChange(of: isActive) { _, newValue in
                if newValue && !reduceMotion {
                    triggerGlow()
                }
            }
    }
    
    private func triggerGlow() {
        glowOpacity = 0.45
        glowRadius = 18
        
        withAnimation(.easeOut(duration: 0.45)) {
            glowOpacity = 0
            glowRadius = 30
        }
    }
}

extension View {
    func glowPulse(color: Color, isActive: Bool) -> some View {
        modifier(GlowPulseEffect(color: color, isActive: isActive))
    }
}

// MARK: - Animated Counter

struct AnimatedCounter: View {
    let value: Int
    let font: Font
    let color: Color
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var displayValue: Int = 0
    
    var body: some View {
        Text("\(displayValue)")
            .font(font)
            .foregroundColor(color)
            .contentTransition(.numericText(value: Double(displayValue)))
            .onAppear {
                if reduceMotion {
                    displayValue = value
                } else {
                    withAnimation(SilkyAnimation.smooth) {
                        displayValue = value
                    }
                }
            }
            .onChange(of: value) { _, newValue in
                if reduceMotion {
                    displayValue = newValue
                } else {
                    withAnimation(SilkyAnimation.snappy) {
                        displayValue = newValue
                    }
                }
            }
    }
}

// MARK: - Motivational Quotes System

struct MotivationalQuote: Identifiable {
    let id = UUID()
    let text: String
    let author: String?
    let category: Category
    
    enum Category {
        case general, streak, levelUp, dimension(LifeDimension), morning, evening
    }
}

@MainActor
final class MotivationalQuotesManager: ObservableObject {
    @Published var currentQuote: MotivationalQuote?
    
    private let quotes: [MotivationalQuote] = [
        // General motivation
        MotivationalQuote(text: "Small steps every day lead to big transformations.", author: nil, category: .general),
        MotivationalQuote(text: "You don't have to be perfect, you just have to begin.", author: nil, category: .general),
        MotivationalQuote(text: "Progress, not perfection.", author: nil, category: .general),
        MotivationalQuote(text: "The best time to start was yesterday. The second best time is now.", author: nil, category: .general),
        MotivationalQuote(text: "Your future self will thank you for what you do today.", author: nil, category: .general),
        MotivationalQuote(text: "Motivation gets you started. Habit keeps you going.", author: nil, category: .general),
        MotivationalQuote(text: "You are one decision away from a completely different life.", author: nil, category: .general),
        
        // Streak motivation
        MotivationalQuote(text: "Your streak is your superpower. Don't break the chain!", author: nil, category: .streak),
        MotivationalQuote(text: "Every day you show up, you're building an unstoppable you.", author: nil, category: .streak),
        MotivationalQuote(text: "Consistency beats intensity. Keep showing up.", author: nil, category: .streak),
        
        // Level up
        MotivationalQuote(text: "You just leveled up! The game is getting good.", author: nil, category: .levelUp),
        MotivationalQuote(text: "Every level unlocks a better version of you.", author: nil, category: .levelUp),
        
        // Dimension-specific
        MotivationalQuote(text: "Love starts with how you treat yourself.", author: nil, category: .dimension(.love)),
        MotivationalQuote(text: "Money is a tool. Learn to use it, not fear it.", author: nil, category: .dimension(.money)),
        MotivationalQuote(text: "Your mind is your most powerful tool. Sharpen it daily.", author: nil, category: .dimension(.mind)),
        MotivationalQuote(text: "Life begins at the edge of your comfort zone.", author: nil, category: .dimension(.adventure)),
        
        // Time-based
        MotivationalQuote(text: "Good morning! Today is full of potential.", author: nil, category: .morning),
        MotivationalQuote(text: "Rise and shine. Make today count.", author: nil, category: .morning),
        MotivationalQuote(text: "End your day proud. Celebrate your wins.", author: nil, category: .evening),
        MotivationalQuote(text: "Rest well. Tomorrow is another chance to level up.", author: nil, category: .evening),
    ]
    
    init() {
        refreshQuote()
    }
    
    func refreshQuote(for category: MotivationalQuote.Category? = nil) {
        let filtered: [MotivationalQuote]
        
        if let category = category {
            filtered = quotes.filter { matchesCategory($0.category, category) }
        } else {
            let hour = Calendar.current.component(.hour, from: Date())
            if hour >= 5 && hour < 12 {
                filtered = quotes.filter { matchesCategory($0.category, .morning) || matchesCategory($0.category, .general) }
            } else if hour >= 20 || hour < 5 {
                filtered = quotes.filter { matchesCategory($0.category, .evening) || matchesCategory($0.category, .general) }
            } else {
                filtered = quotes.filter { matchesCategory($0.category, .general) }
            }
        }
        
        currentQuote = filtered.randomElement() ?? quotes.randomElement()
    }
    
    func quoteForStreak(_ streak: Int) -> MotivationalQuote? {
        quotes.filter { matchesCategory($0.category, .streak) }.randomElement()
    }
    
    func quoteForLevelUp() -> MotivationalQuote? {
        quotes.filter { matchesCategory($0.category, .levelUp) }.randomElement()
    }
    
    func quoteForDimension(_ dimension: LifeDimension) -> MotivationalQuote? {
        quotes.filter { matchesCategory($0.category, .dimension(dimension)) }.randomElement()
    }
    
    private func matchesCategory(_ a: MotivationalQuote.Category, _ b: MotivationalQuote.Category) -> Bool {
        switch (a, b) {
        case (.general, .general): return true
        case (.streak, .streak): return true
        case (.levelUp, .levelUp): return true
        case (.morning, .morning): return true
        case (.evening, .evening): return true
        case (.dimension(let d1), .dimension(let d2)): return d1 == d2
        default: return false
        }
    }
}

// MARK: - Quote Card View

struct QuoteCard: View {
    let quote: MotivationalQuote
    var onRefresh: (() -> Void)? = nil
    
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24))
                    .foregroundColor(BrandTheme.accent.opacity(0.5))
                
                Spacer()
                
                if let onRefresh = onRefresh {
                    Button(action: onRefresh) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
            }
            
            Text(quote.text)
                .font(DesignSystem.text.bodyLarge)
                .foregroundColor(BrandTheme.textPrimary)
                .italic()
            
            if let author = quote.author {
                Text("— \(author)")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Radii.lg, style: .continuous)
                .fill(BrandTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radii.lg, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [BrandTheme.accent.opacity(0.06), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radii.lg, style: .continuous)
                .strokeBorder(BrandTheme.accent.opacity(0.15), lineWidth: 1)
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35)) {
                appeared = true
            }
        }
    }
}

// MARK: - Ripple Effect (120fps)

struct RippleEffect: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var ripples: [RippleData] = []
    
    struct RippleData: Identifiable {
        let id = UUID()
        var scale: CGFloat = 0.3
        var opacity: Double = 0.45
        let position: CGPoint
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Canvas { context, size in
                    for ripple in ripples {
                        let radius = 35 * ripple.scale
                        let rect = CGRect(
                            x: ripple.position.x - radius,
                            y: ripple.position.y - radius,
                            width: radius * 2,
                            height: radius * 2
                        )
                        
                        context.opacity = ripple.opacity
                        context.stroke(Circle().path(in: rect), with: .color(BrandTheme.accent), lineWidth: 2.5)
                    }
                }
                .allowsHitTesting(false)
            )
            .onTapGesture { location in
                if !reduceMotion {
                    createRipple(at: location)
                }
            }
    }
    
    private func createRipple(at position: CGPoint) {
        let ripple = RippleData(position: position)
        ripples.append(ripple)
        
        withAnimation(.easeOut(duration: 0.4)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].scale = 2.2
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }
}

extension View {
    func rippleEffect() -> some View {
        modifier(RippleEffect())
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticsEngine.mediumImpact()
            action()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isPressed ? 0.92 : 1)
        .shadow(color: color.opacity(0.4), radius: isPressed ? 8 : 16, y: isPressed ? 4 : 8)
        .animation(SilkyAnimation.tap, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Skeleton Loading (120fps shimmer)

struct SkeletonView: View {
    var height: CGFloat = 20
    var cornerRadius: CGFloat = DesignSystem.Radii.sm

    var body: some View {
        AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
            let phase = computePhase(for: timeline.date)
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(BrandTheme.borderSubtle.opacity(0.5))
                .frame(height: height)
                .overlay(
                    GeometryReader { geo in
                        LinearGradient(
                            colors: [Color.clear, Color.white.opacity(0.3), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * 0.6)
                        .offset(x: phase * geo.size.width * 1.6 - geo.size.width * 0.3)
                    }
                    .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                )
        }
    }
    
    private func computePhase(for date: Date) -> CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = seconds.truncatingRemainder(dividingBy: 1.5)
        return CGFloat(cycle / 1.5)
    }
}

// MARK: - Card Skeleton

struct CardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.md) {
                SkeletonView(height: 48, cornerRadius: DesignSystem.Radii.md)
                    .frame(width: 48)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    SkeletonView(height: 16)
                        .frame(width: 120)
                    SkeletonView(height: 12)
                        .frame(width: 80)
                }
                
                Spacer()
            }
            
            SkeletonView(height: 8)
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                SkeletonView(height: 24)
                    .frame(width: 60)
                SkeletonView(height: 24)
                    .frame(width: 60)
                Spacer()
            }
        }
        .brandCard()
    }
}

// MARK: - Typewriter Effect

struct TypewriterText: View {
    let text: String
    var speed: Double = 0.04
    
    @State private var displayedText = ""
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        Text(displayedText)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                // Clean up timer when view disappears
                timer?.invalidate()
                timer = nil
            }
    }
    
    private func startTyping() {
        displayedText = ""
        currentIndex = 0
        
        // Invalidate any existing timer
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { t in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText += String(text[index])
                currentIndex += 1
            } else {
                t.invalidate()
                timer = nil
            }
        }
    }
}

// MARK: - Staggered Appear Animation

struct StaggeredAppearModifier: ViewModifier {
    let index: Int
    let baseDelay: Double
    let staggerDelay: Double
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : (reduceMotion ? 0 : 12))
            .onAppear {
                if reduceMotion {
                    appeared = true
                } else {
                    let cappedIndex = min(index, 6)
                    let delay = baseDelay + (Double(cappedIndex) * staggerDelay)
                    withAnimation(SilkyAnimation.smooth.delay(delay)) {
                        appeared = true
                    }
                }
            }
    }
}

extension View {
    func staggeredAppear(index: Int, baseDelay: Double = 0, staggerDelay: Double = 0.05) -> some View {
        modifier(StaggeredAppearModifier(index: index, baseDelay: baseDelay, staggerDelay: staggerDelay))
    }
}

// MARK: - Success Checkmark Animation

struct SuccessCheckmark: View {
    @Binding var isShowing: Bool
    var size: CGFloat = 80
    var color: Color = BrandTheme.success
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var circleProgress: CGFloat = 0
    @State private var checkProgress: CGFloat = 0
    @State private var scale: CGFloat = 0.85
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: circleProgress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            CheckmarkShape()
                .trim(from: 0, to: checkProgress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: size * 0.4, height: size * 0.4)
        }
        .scaleEffect(scale)
        .opacity(isShowing ? 1 : 0)
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                animate()
            } else {
                reset()
            }
        }
    }
    
    private func animate() {
        if reduceMotion {
            circleProgress = 1
            checkProgress = 1
            scale = 1
            return
        }
        
        withAnimation(.easeOut(duration: 0.3)) {
            circleProgress = 1
            scale = 1
        }
        
        withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
            checkProgress = 1
        }
        
        withAnimation(SilkyAnimation.bouncy.delay(0.4)) {
            scale = 1.08
        }
        
        withAnimation(SilkyAnimation.tap.delay(0.5)) {
            scale = 1
        }
    }
    
    private func reset() {
        circleProgress = 0
        checkProgress = 0
        scale = 0.85
    }
}

private struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let middle = CGPoint(x: rect.width * 0.35, y: rect.maxY)
        let end = CGPoint(x: rect.maxX, y: rect.minY)
        
        path.move(to: start)
        path.addLine(to: middle)
        path.addLine(to: end)
        
        return path
    }
}

// MARK: - Smooth Scale Button Style

struct SmoothScaleButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat = 0.96
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1)
            .animation(SilkyAnimation.tap, value: configuration.isPressed)
    }
}

// MARK: - Press Feedback Modifier

struct PressFeedbackModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1)
            .opacity(isPressed ? 0.9 : 1)
            .animation(SilkyAnimation.micro, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func pressFeedback() -> some View {
        modifier(PressFeedbackModifier())
    }
}
