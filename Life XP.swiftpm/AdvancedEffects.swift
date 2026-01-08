import SwiftUI

// MARK: - Advanced Visual Effects & Animations
// Premium-quality visual effects that elevate the app experience

// MARK: - Particle System for Completions

struct CompletionParticles: View {
    @Binding var isActive: Bool
    var color: Color = BrandTheme.success
    var particleCount: Int = 20
    
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var rotation: Double
        var opacity: Double
        let velocityX: CGFloat
        let velocityY: CGFloat
        let shape: ParticleShape
        
        enum ParticleShape: CaseIterable {
            case circle, star, sparkle
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(particle: particle, color: color)
                        .position(x: particle.x, y: particle.y)
                        .scaleEffect(particle.scale)
                        .rotationEffect(.degrees(particle.rotation))
                        .opacity(particle.opacity)
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    emitParticles(in: geo.size)
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func emitParticles(in size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        particles = (0..<particleCount).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let velocity = CGFloat.random(in: 3...8)
            
            return Particle(
                x: centerX,
                y: centerY,
                scale: CGFloat.random(in: 0.3...1.0),
                rotation: Double.random(in: 0...360),
                opacity: 1,
                velocityX: cos(angle) * velocity,
                velocityY: sin(angle) * velocity,
                shape: Particle.ParticleShape.allCases.randomElement()!
            )
        }
        
        // Animate particles outward
        withAnimation(.easeOut(duration: 0.8)) {
            particles = particles.map { particle in
                var p = particle
                p.x += particle.velocityX * 60
                p.y += particle.velocityY * 60
                p.rotation += Double.random(in: 180...360)
                p.scale *= 0.3
                p.opacity = 0
                return p
            }
        }
        
        // Clean up
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isActive = false
            particles = []
        }
    }
}

private struct ParticleView: View {
    let particle: CompletionParticles.Particle
    let color: Color
    
    var body: some View {
        Group {
            switch particle.shape {
            case .circle:
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            case .star:
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(color)
            case .sparkle:
                Image(systemName: "sparkle")
                    .font(.system(size: 10))
                    .foregroundColor(color)
            }
        }
    }
}

// MARK: - Firework Effect

struct FireworkEffect: View {
    @Binding var isActive: Bool
    var colors: [Color] = [BrandTheme.accent, BrandTheme.success, BrandTheme.warning, BrandTheme.love]
    
    @State private var bursts: [Burst] = []
    
    struct Burst: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var particles: [FireworkParticle]
    }
    
    struct FireworkParticle: Identifiable {
        let id = UUID()
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var scale: CGFloat = 1
        var opacity: Double = 1
        let angle: Double
        let color: Color
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(bursts) { burst in
                    ZStack {
                        ForEach(burst.particles) { particle in
                            Circle()
                                .fill(particle.color)
                                .frame(width: 6, height: 6)
                                .offset(x: particle.offsetX, y: particle.offsetY)
                                .scaleEffect(particle.scale)
                                .opacity(particle.opacity)
                        }
                    }
                    .position(x: burst.x, y: burst.y)
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    createFirework(in: geo.size)
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createFirework(in size: CGSize) {
        // Create multiple bursts
        for _ in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.3)) {
                let x = CGFloat.random(in: size.width * 0.2...size.width * 0.8)
                let y = CGFloat.random(in: size.height * 0.2...size.height * 0.6)
                
                let particleCount = Int.random(in: 12...20)
                let particles = (0..<particleCount).map { i in
                    let angle = Double(i) / Double(particleCount) * 2 * .pi
                    return FireworkParticle(
                        angle: angle,
                        color: colors.randomElement()!
                    )
                }
                
                var burst = Burst(x: x, y: y, particles: particles)
                bursts.append(burst)
                
                // Animate expansion
                withAnimation(.easeOut(duration: 0.6)) {
                    if let index = bursts.firstIndex(where: { $0.id == burst.id }) {
                        bursts[index].particles = bursts[index].particles.map { p in
                            var particle = p
                            let distance = CGFloat.random(in: 40...80)
                            particle.offsetX = cos(p.angle) * distance
                            particle.offsetY = sin(p.angle) * distance
                            return particle
                        }
                    }
                }
                
                // Fade out
                withAnimation(.easeOut(duration: 0.4).delay(0.4)) {
                    if let index = bursts.firstIndex(where: { $0.id == burst.id }) {
                        bursts[index].particles = bursts[index].particles.map { p in
                            var particle = p
                            particle.opacity = 0
                            particle.scale = 0.3
                            return particle
                        }
                    }
                }
            }
        }
        
        // Clean up
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isActive = false
            bursts = []
        }
    }
}

// MARK: - Glow Pulse Effect

struct GlowPulseEffect: ViewModifier {
    let color: Color
    let isActive: Bool
    
    @State private var glowOpacity: Double = 0
    @State private var glowRadius: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(color.opacity(glowOpacity))
                    .blur(radius: glowRadius)
                    .scaleEffect(1.1)
            )
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    triggerGlow()
                }
            }
    }
    
    private func triggerGlow() {
        withAnimation(.easeIn(duration: 0.2)) {
            glowOpacity = 0.5
            glowRadius = 20
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
            glowOpacity = 0
            glowRadius = 40
        }
    }
}

extension View {
    func glowPulse(color: Color, isActive: Bool) -> some View {
        modifier(GlowPulseEffect(color: color, isActive: isActive))
    }
}

// MARK: - Number Counter Animation

struct AnimatedCounter: View {
    let value: Int
    let font: Font
    let color: Color
    
    @State private var displayValue: Int = 0
    
    var body: some View {
        Text("\(displayValue)")
            .font(font)
            .foregroundColor(color)
            .contentTransition(.numericText(value: displayValue))
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    displayValue = value
                }
            }
            .onChange(of: value) { _, newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    displayValue = newValue
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
        MotivationalQuote(text: "Discipline is choosing between what you want now and what you want most.", author: "Abraham Lincoln", category: .general),
        MotivationalQuote(text: "Motivation gets you started. Habit keeps you going.", author: nil, category: .general),
        MotivationalQuote(text: "You are one decision away from a completely different life.", author: nil, category: .general),
        
        // Streak motivation
        MotivationalQuote(text: "Your streak is your superpower. Don't break the chain!", author: nil, category: .streak),
        MotivationalQuote(text: "Every day you show up, you're building an unstoppable you.", author: nil, category: .streak),
        MotivationalQuote(text: "Consistency beats intensity. Keep showing up.", author: nil, category: .streak),
        MotivationalQuote(text: "Your streak proves you can commit. That's a rare skill.", author: nil, category: .streak),
        
        // Level up
        MotivationalQuote(text: "You just leveled up! The game is getting good.", author: nil, category: .levelUp),
        MotivationalQuote(text: "Every level unlocks a better version of you.", author: nil, category: .levelUp),
        MotivationalQuote(text: "Level up achieved! What's your next quest?", author: nil, category: .levelUp),
        
        // Dimension-specific
        MotivationalQuote(text: "Love starts with how you treat yourself.", author: nil, category: .dimension(.love)),
        MotivationalQuote(text: "Connection is the antidote to almost everything.", author: nil, category: .dimension(.love)),
        MotivationalQuote(text: "Money is a tool. Learn to use it, not fear it.", author: nil, category: .dimension(.money)),
        MotivationalQuote(text: "Financial freedom is bought with discipline, paid in time.", author: nil, category: .dimension(.money)),
        MotivationalQuote(text: "Your mind is your most powerful tool. Sharpen it daily.", author: nil, category: .dimension(.mind)),
        MotivationalQuote(text: "Mental health is not a destination but a journey.", author: nil, category: .dimension(.mind)),
        MotivationalQuote(text: "Life begins at the edge of your comfort zone.", author: nil, category: .dimension(.adventure)),
        MotivationalQuote(text: "Adventure is worthwhile in itself.", author: "Amelia Earhart", category: .dimension(.adventure)),
        
        // Time-based
        MotivationalQuote(text: "Good morning! Today is full of potential. What will you make of it?", author: nil, category: .morning),
        MotivationalQuote(text: "Rise and grind. Or rise and flow. Either way, rise.", author: nil, category: .morning),
        MotivationalQuote(text: "Morning reflection: What matters most today?", author: nil, category: .morning),
        MotivationalQuote(text: "End your day proud. What did you accomplish?", author: nil, category: .evening),
        MotivationalQuote(text: "Rest well. Tomorrow is another chance to level up.", author: nil, category: .evening),
        MotivationalQuote(text: "Before you sleep, celebrate your wins—big or small.", author: nil, category: .evening),
    ]
    
    init() {
        refreshQuote()
    }
    
    func refreshQuote(for category: MotivationalQuote.Category? = nil) {
        let filtered: [MotivationalQuote]
        
        if let category = category {
            filtered = quotes.filter { matchesCategory($0.category, category) }
        } else {
            // Pick based on time of day
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
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24))
                    .foregroundColor(BrandTheme.accent.opacity(0.5))
                
                Spacer()
                
                if let onRefresh = onRefresh {
                    Button {
                        onRefresh()
                    } label: {
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
        .padding(DesignSystem.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                .fill(BrandTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    BrandTheme.accent.opacity(0.05),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                .strokeBorder(BrandTheme.accent.opacity(0.1), lineWidth: 1)
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                appeared = true
            }
        }
    }
}

// MARK: - Ripple Effect

struct RippleEffect: ViewModifier {
    @State private var ripples: [RippleData] = []
    
    struct RippleData: Identifiable {
        let id = UUID()
        var scale: CGFloat = 0
        var opacity: Double = 0.5
        let position: CGPoint
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    ZStack {
                        ForEach(ripples) { ripple in
                            Circle()
                                .stroke(BrandTheme.accent.opacity(ripple.opacity), lineWidth: 2)
                                .scaleEffect(ripple.scale)
                                .position(ripple.position)
                        }
                    }
                }
            )
            .onTapGesture { location in
                createRipple(at: location)
            }
    }
    
    private func createRipple(at position: CGPoint) {
        var ripple = RippleData(position: position)
        ripples.append(ripple)
        
        withAnimation(.easeOut(duration: 0.6)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].scale = 2
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
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
    @State private var showRipple = false
    
    var body: some View {
        Button(action: {
            HapticsEngine.mediumImpact()
            showRipple = true
            action()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1)
        .shadow(color: color.opacity(0.4), radius: isPressed ? 8 : 16, y: isPressed ? 4 : 8)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Skeleton Loading View

struct SkeletonView: View {
    var height: CGFloat = 20
    var cornerRadius: CGFloat = DesignSystem.radius.sm
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(BrandTheme.borderSubtle.opacity(0.5))
            .frame(height: height)
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.5)
                    .offset(x: phase * geo.size.width * 1.5 - geo.size.width * 0.25)
                }
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// MARK: - Card Skeleton

struct CardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                SkeletonView(height: 48, cornerRadius: DesignSystem.radius.md)
                    .frame(width: 48)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    SkeletonView(height: 16)
                        .frame(width: 120)
                    SkeletonView(height: 12)
                        .frame(width: 80)
                }
                
                Spacer()
            }
            
            SkeletonView(height: 8)
            
            HStack(spacing: DesignSystem.spacing.sm) {
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
    var speed: Double = 0.05
    
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    var body: some View {
        Text(displayedText)
            .onAppear {
                startTyping()
            }
    }
    
    private func startTyping() {
        displayedText = ""
        currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText += String(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Staggered Grid Animation

struct StaggeredAppearModifier: ViewModifier {
    let index: Int
    let baseDelay: Double
    let staggerDelay: Double
    
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
            .onAppear {
                let delay = baseDelay + (Double(index) * staggerDelay)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                    appeared = true
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
    
    @State private var circleProgress: CGFloat = 0
    @State private var checkProgress: CGFloat = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            // Circle
            Circle()
                .trim(from: 0, to: circleProgress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Checkmark
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
        // Circle animation
        withAnimation(.easeOut(duration: 0.4)) {
            circleProgress = 1
            scale = 1
        }
        
        // Checkmark animation
        withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
            checkProgress = 1
        }
        
        // Bounce
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.5)) {
            scale = 1.1
        }
        
        withAnimation(.spring(response: 0.2, dampingFraction: 0.7).delay(0.6)) {
            scale = 1
        }
    }
    
    private func reset() {
        circleProgress = 0
        checkProgress = 0
        scale = 0.8
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
