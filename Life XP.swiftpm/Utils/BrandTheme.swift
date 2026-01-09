import SwiftUI

// MARK: - Design System 2.0

/// Comprehensive design system with spacing, typography, colors, and components.
/// Provides consistent styling across the entire app with support for light/dark modes.
struct DesignSystem {
    // MARK: - Spacing Scale
    struct Spacing {
        let xxs: CGFloat = 2
        let xs: CGFloat = 4
        let sm: CGFloat = 8
        let md: CGFloat = 12
        let lg: CGFloat = 16
        let xl: CGFloat = 20
        let xxl: CGFloat = 24
        let xxxl: CGFloat = 32
        let huge: CGFloat = 48
        let massive: CGFloat = 64
    }

    // MARK: - Corner Radii
    struct Radii {
        let xs: CGFloat = 6
        let sm: CGFloat = 10
        let md: CGFloat = 14
        let lg: CGFloat = 20
        let xl: CGFloat = 26
        let xxl: CGFloat = 32
        let pill: CGFloat = 999
    }

    // MARK: - Shadow System
    struct Shadows {
        let subtle = Shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        let soft = Shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 6)
        let lifted = Shadow(color: Color.black.opacity(0.15), radius: 24, x: 0, y: 12)
        let floating = Shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 16)
        let glow = Shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 4)
        let coloredGlow: (Color) -> Shadow = { color in
            Shadow(color: color.opacity(0.35), radius: 16, x: 0, y: 6)
        }
    }

    // MARK: - Typography System
    struct TextStyles {
        // Display
        let heroTitle = Font.system(.largeTitle, design: .rounded).weight(.black)
        let displayLarge = Font.system(size: 48, weight: .black, design: .rounded)
        let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
        let displaySmall = Font.system(size: 28, weight: .bold, design: .rounded)
        
        // Headlines
        let headline = Font.system(.headline, design: .rounded).weight(.bold)
        let headlineLarge = Font.system(.title2, design: .rounded).weight(.bold)
        let headlineMedium = Font.system(.title3, design: .rounded).weight(.semibold)
        
        // Body
        let bodyLarge = Font.system(.body, design: .rounded).weight(.medium)
        let bodyMedium = Font.system(.callout, design: .rounded)
        let bodySmall = Font.system(.subheadline, design: .rounded)
        
        // Labels
        let labelLarge = Font.system(.subheadline, design: .rounded).weight(.semibold)
        let labelMedium = Font.system(.footnote, design: .rounded).weight(.semibold)
        let labelSmall = Font.system(.caption, design: .rounded).weight(.medium)
        
        // Captions
        let captionEmphasis = Font.caption.weight(.bold)
        let captionRegular = Font.caption
        let captionMini = Font.caption2
        
        // Special
        let sectionTitle = Font.system(.headline, design: .rounded).weight(.bold)
        let cardTitle = Font.system(.title3, design: .rounded).weight(.bold)
        let statNumber = Font.system(size: 64, weight: .black, design: .rounded)
        let xpCounter = Font.system(.title, design: .monospaced).weight(.bold)
    }

    // MARK: - Animation Durations
    struct Durations {
        let instant: Double = 0.1
        let fast: Double = 0.2
        let normal: Double = 0.3
        let slow: Double = 0.45
        let gentle: Double = 0.6
        let dramatic: Double = 0.8
    }

    // MARK: - Animation Curves (Optimized for 60fps smoothness)
    struct AnimationCurves {
        /// Bouncy spring for celebrations and emphasis
        let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.1)
        /// Smooth spring for general state changes
        let smooth = Animation.spring(response: 0.45, dampingFraction: 0.9, blendDuration: 0.12)
        /// Snappy spring for quick interactions
        let snappy = Animation.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 0.05)
        /// Gentle spring for subtle transitions
        let gentle = Animation.spring(response: 0.5, dampingFraction: 0.92, blendDuration: 0.15)
        /// Elastic spring for playful elements (use sparingly)
        let elastic = Animation.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.08)
        /// Quick ease for immediate feedback
        let quick = Animation.easeOut(duration: 0.2)
        /// Micro interaction for tap feedback
        let micro = Animation.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0.03)
    }

    // MARK: - Icon Sizes
    struct IconSizes {
        let xs: CGFloat = 12
        let sm: CGFloat = 16
        let md: CGFloat = 20
        let lg: CGFloat = 24
        let xl: CGFloat = 32
        let xxl: CGFloat = 48
        let hero: CGFloat = 64
    }

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    // MARK: - Singleton Accessors
    static let spacing = Spacing()
    static let radius = Radii()
    static let shadow = Shadows()
    static let text = TextStyles()
    static let duration = Durations()
    static let animation = AnimationCurves()
    static let iconSize = IconSizes()
}

// MARK: - Brand Theme 2.0

/// Comprehensive color and styling system with full light/dark mode support.
struct BrandTheme {
    // MARK: - Primary Palette
    static let primary = Color.dynamic(
        light: Color(hex: "4F46E5", default: .accentColor),
        dark: Color(hex: "818CF8", default: .accentColor)
    )
    
    static let primaryLight = Color.dynamic(
        light: Color(hex: "6366F1", default: .accentColor),
        dark: Color(hex: "A5B4FC", default: .accentColor)
    )
    
    static let primaryDark = Color.dynamic(
        light: Color(hex: "3730A3", default: .accentColor),
        dark: Color(hex: "6366F1", default: .accentColor)
    )
    
    // MARK: - Accent Colors
    static let accent = Color.dynamic(
        light: Color(hex: "6366F1", default: .accentColor),
        dark: Color(hex: "A5B4FC", default: .accentColor)
    )
    
    static let accentSoft = Color.dynamic(
        light: Color(hex: "818CF8", default: .accentColor),
        dark: Color(hex: "C7D2FE", default: .accentColor)
    )
    
    static let accentMuted = Color.dynamic(
        light: Color(hex: "E0E7FF", default: .accentColor),
        dark: Color(hex: "312E81", default: .accentColor)
    )
    
    // MARK: - Semantic Colors
    static let success = Color.dynamic(
        light: Color(hex: "10B981", default: .green),
        dark: Color(hex: "34D399", default: .green)
    )
    
    static let warning = Color.dynamic(
        light: Color(hex: "F59E0B", default: .orange),
        dark: Color(hex: "FBBF24", default: .orange)
    )
    
    static let error = Color.dynamic(
        light: Color(hex: "EF4444", default: .red),
        dark: Color(hex: "F87171", default: .red)
    )
    
    static let info = Color.dynamic(
        light: Color(hex: "3B82F6", default: .blue),
        dark: Color(hex: "60A5FA", default: .blue)
    )
    
    // MARK: - Dimension Colors
    static let love = Color.dynamic(
        light: Color(hex: "EC4899", default: .pink),
        dark: Color(hex: "F472B6", default: .pink)
    )
    
    static let money = Color.dynamic(
        light: Color(hex: "10B981", default: .green),
        dark: Color(hex: "34D399", default: .green)
    )
    
    static let mind = Color.dynamic(
        light: Color(hex: "8B5CF6", default: .purple),
        dark: Color(hex: "A78BFA", default: .purple)
    )
    
    static let adventure = Color.dynamic(
        light: Color(hex: "F59E0B", default: .orange),
        dark: Color(hex: "FBBF24", default: .orange)
    )
    
    static func dimensionColor(_ dimension: LifeDimension) -> Color {
        switch dimension {
        case .love: return love
        case .money: return money
        case .mind: return mind
        case .adventure: return adventure
        }
    }
    
    // MARK: - Background Gradients
    static let waveSky = Color.dynamic(
        light: Color(hex: "EEF2FF", default: .blue.opacity(0.1)),
        dark: Color(hex: "0F172A", default: .black)
    )
    
    static let waveMist = Color.dynamic(
        light: Color(hex: "E0E7FF", default: .purple.opacity(0.1)),
        dark: Color(hex: "1E1B4B", default: .purple.opacity(0.3))
    )
    
    static let waveDeep = Color.dynamic(
        light: Color(hex: "C7D2FE", default: .indigo.opacity(0.2)),
        dark: Color(hex: "312E81", default: .indigo.opacity(0.4))
    )
    
    // MARK: - Surface Colors
    static let cardBackground = Color.dynamic(
        light: .white,
        dark: Color(hex: "1E1B4B", default: .black)
    )
    
    static let cardBackgroundElevated = Color.dynamic(
        light: Color(hex: "FAFAFA", default: .white),
        dark: Color(hex: "262153", default: .gray)
    )
    
    static let surfaceOverlay = Color.dynamic(
        light: Color.white.opacity(0.9),
        dark: Color(hex: "1E1B4B", default: .black).opacity(0.95)
    )
    
    // MARK: - Text Colors
    static let textPrimary = Color.dynamic(
        light: Color(hex: "1E1B4B", default: .primary),
        dark: Color(hex: "F1F5F9", default: .white)
    )
    
    static let textSecondary = Color.dynamic(
        light: Color(hex: "475569", default: .secondary),
        dark: Color(hex: "94A3B8", default: .gray)
    )
    
    static let mutedText = Color.dynamic(
        light: Color(hex: "64748B", default: .secondary),
        dark: Color(hex: "94A3B8", default: .gray)
    )
    
    static let textTertiary = Color.dynamic(
        light: Color(hex: "94A3B8", default: .secondary),
        dark: Color(hex: "64748B", default: .gray)
    )
    
    // MARK: - Interactive Colors
    static let accentLine = Color.dynamic(
        light: .white,
        dark: Color(hex: "E0E7FF", default: .white)
    )
    
    static let divider = Color.dynamic(
        light: Color(hex: "E2E8F0", default: .gray.opacity(0.3)),
        dark: Color(hex: "334155", default: .gray.opacity(0.3))
    )
    
    static let borderSubtle = Color.dynamic(
        light: Color(hex: "E2E8F0", default: .gray.opacity(0.2)),
        dark: Color(hex: "475569", default: .gray.opacity(0.3))
    )
    
    // MARK: - Gradient Presets
    static let gradientPrimary = LinearGradient(
        colors: [primaryLight, primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientAccent = LinearGradient(
        colors: [accentSoft, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientBackground = LinearGradient(
        colors: [waveSky, waveMist, waveDeep],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCard = LinearGradient(
        colors: [waveMist.opacity(0.4), waveSky.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGlow = RadialGradient(
        colors: [accent.opacity(0.4), accent.opacity(0)],
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
    
    // MARK: - Legacy Compatibility
    static let gradientTop = waveSky
    static let gradientMiddle = waveMist
    static let gradientBottom = waveDeep
}

// MARK: - Brand Background 2.0

/// Animated, layered background with subtle motion and depth.
/// Optimized for performance with TimelineView instead of repeatForever.
struct BrandBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var animated: Bool = true
    var intensity: Double = 1.0
    
    var body: some View {
        if animated && !reduceMotion {
            // Use TimelineView for smoother, more controlled animations
            TimelineView(.animation(minimumInterval: 1.0/30, paused: false)) { timeline in
                AnimatedBackgroundContent(
                    date: timeline.date,
                    intensity: intensity
                )
            }
        } else {
            // Static version for better performance
            StaticBackgroundContent(intensity: intensity)
        }
    }
}

private struct AnimatedBackgroundContent: View {
    let date: Date
    let intensity: Double
    
    private var phase1: CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        return CGFloat((seconds / 25).truncatingRemainder(dividingBy: 1)) * .pi * 2
    }
    
    private var phase2: CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        return CGFloat((seconds / 30).truncatingRemainder(dividingBy: 1)) * .pi * 2
    }
    
    private var orbOffset: CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = sin(seconds / 10 * .pi)
        return CGFloat(cycle) * 25
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Base gradient - static for performance
                LinearGradient(
                    colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Single animated wave (reduced from 2)
                WaveShape(amplitude: 45 * intensity, waveLength: 280, phase: phase1)
                    .fill(
                        LinearGradient(
                            colors: [
                                BrandTheme.waveDeep.opacity(0.35 * intensity),
                                BrandTheme.waveMist.opacity(0.4 * intensity)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 350)
                    .offset(x: -40, y: -120)
                    .blur(radius: 25)
                
                // Subtle orb with gentle movement
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                BrandTheme.accent.opacity(0.2 * intensity),
                                BrandTheme.accent.opacity(0)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 180
                        )
                    )
                    .frame(width: 350, height: 350)
                    .offset(x: orbOffset, y: -orbOffset * 0.6)
                    .blur(radius: 50)
            }
            .drawingGroup() // GPU acceleration
        }
    }
}

private struct StaticBackgroundContent: View {
    let intensity: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Static decorative wave
                WaveShape(amplitude: 40 * intensity, waveLength: 280, phase: 0.5)
                    .fill(
                        LinearGradient(
                            colors: [
                                BrandTheme.waveDeep.opacity(0.3 * intensity),
                                BrandTheme.waveMist.opacity(0.35 * intensity)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 300)
                    .offset(x: -30, y: -100)
                    .blur(radius: 25)
                
                // Static orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                BrandTheme.accent.opacity(0.15 * intensity),
                                BrandTheme.accent.opacity(0)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 160
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: 20, y: -30)
                    .blur(radius: 45)
            }
            .drawingGroup()
        }
    }
}

/// Simplified static background for performance-critical views.
struct BrandBackgroundStatic: View {
    var body: some View {
        LinearGradient(
            colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Wave Shape

private struct WaveShape: Shape {
    var amplitude: CGFloat
    var waveLength: CGFloat
    var phase: CGFloat = 0
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))

        let steps = Int(rect.width / 6)
        for step in 0...steps {
            let x = CGFloat(step) / CGFloat(steps) * rect.width
            let relative = x / waveLength
            let sine = sin(relative * .pi * 2 + phase)
            let y = rect.midY + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Card Modifiers

/// Modern glassmorphic card style with optional glow.
private struct BrandCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.radius.lg
    var enableGlow: Bool = false
    var glowColor: Color = BrandTheme.accent
    var padding: CGFloat = DesignSystem.spacing.lg
    var shadowIntensity: Double = 1.0

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        BrandTheme.cardBackground.opacity(0.8),
                                        BrandTheme.cardBackground.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                                BrandTheme.accent.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: BrandTheme.waveDeep.opacity(0.2 * shadowIntensity),
                radius: DesignSystem.shadow.soft.radius,
                y: DesignSystem.shadow.soft.y
            )
            .background(
                Group {
                    if enableGlow {
                        RoundedRectangle(cornerRadius: cornerRadius + 4, style: .continuous)
                            .fill(glowColor.opacity(0.15))
                            .blur(radius: 12)
                            .offset(y: 4)
                    }
                }
            )
    }
}

/// Elevated card style for prominent content.
private struct ElevatedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.radius.xl
    var accentColor: Color = BrandTheme.accent
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.spacing.xl)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(BrandTheme.cardBackground)
                    
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.08),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(accentColor.opacity(0.2), lineWidth: 1.5)
            )
            .shadow(color: accentColor.opacity(0.2), radius: 20, y: 10)
            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
    }
}

/// Subtle card for secondary content.
private struct SubtleCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.radius.md
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(BrandTheme.cardBackgroundElevated.opacity(0.7))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(BrandTheme.borderSubtle.opacity(0.5), lineWidth: 0.5)
            )
    }
}

// MARK: - Interactive Button Styles

struct GlowButtonStyle: ButtonStyle {
    var color: Color = BrandTheme.accent
    var size: Size = .medium
    
    enum Size {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            case .large: return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .subheadline.weight(.semibold)
            case .medium: return .headline.weight(.semibold)
            case .large: return .title3.weight(.bold)
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundColor(.white)
            .padding(size.padding)
            .background(
                ZStack {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.9), color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Capsule()
                        .fill(Color.white.opacity(configuration.isPressed ? 0 : 0.2))
                        .padding(1)
                }
            )
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.4), radius: configuration.isPressed ? 4 : 12, y: configuration.isPressed ? 2 : 6)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SoftButtonStyle: ButtonStyle {
    var color: Color = BrandTheme.accent
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, DesignSystem.spacing.lg)
            .padding(.vertical, DesignSystem.spacing.md)
            .background(
                Capsule()
                    .fill(color.opacity(configuration.isPressed ? 0.2 : 0.12))
            )
            .overlay(
                Capsule()
                    .strokeBorder(color.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

struct GhostButtonStyle: ButtonStyle {
    var color: Color = BrandTheme.textPrimary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.medium))
            .foregroundColor(color.opacity(configuration.isPressed ? 0.6 : 1))
            .padding(.horizontal, DesignSystem.spacing.md)
            .padding(.vertical, DesignSystem.spacing.sm)
            .background(
                Capsule()
                    .fill(Color.clear)
                    .background(
                        Capsule()
                            .fill(color.opacity(configuration.isPressed ? 0.1 : 0))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Badge/Chip Styles

struct ChipView: View {
    let text: String
    var icon: String? = nil
    var color: Color = BrandTheme.accent
    var size: Size = .medium
    
    enum Size {
        case small, medium, large
        
        var font: Font {
            switch self {
            case .small: return .caption2.weight(.semibold)
            case .medium: return .caption.weight(.semibold)
            case .large: return .subheadline.weight(.semibold)
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6)
            case .medium: return EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            case .large: return EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(size.font)
            }
            Text(text)
                .font(size.font)
        }
        .foregroundColor(color)
        .padding(size.padding)
        .background(
            Capsule()
                .fill(color.opacity(0.12))
        )
        .overlay(
            Capsule()
                .strokeBorder(color.opacity(0.2), lineWidth: 0.5)
        )
    }
}

struct XPChip: View {
    let xp: Int
    var size: ChipView.Size = .medium
    
    var body: some View {
        ChipView(
            text: "\(xp) XP",
            icon: "star.fill",
            color: BrandTheme.warning,
            size: size
        )
    }
}

struct StreakChip: View {
    let days: Int
    var size: ChipView.Size = .medium
    
    var body: some View {
        ChipView(
            text: "\(days)d",
            icon: "flame.fill",
            color: BrandTheme.error,
            size: size
        )
    }
}

// MARK: - View Extensions

extension View {
    func brandCard(
        cornerRadius: CGFloat = DesignSystem.radius.lg,
        enableGlow: Bool = false,
        glowColor: Color = BrandTheme.accent,
        padding: CGFloat = DesignSystem.spacing.lg
    ) -> some View {
        modifier(BrandCardModifier(
            cornerRadius: cornerRadius,
            enableGlow: enableGlow,
            glowColor: glowColor,
            padding: padding
        ))
    }
    
    func elevatedCard(
        cornerRadius: CGFloat = DesignSystem.radius.xl,
        accentColor: Color = BrandTheme.accent
    ) -> some View {
        modifier(ElevatedCardModifier(cornerRadius: cornerRadius, accentColor: accentColor))
    }
    
    func subtleCard(cornerRadius: CGFloat = DesignSystem.radius.md) -> some View {
        modifier(SubtleCardModifier(cornerRadius: cornerRadius))
    }
    
    func brandShadow(_ shadow: DesignSystem.Shadow = DesignSystem.shadow.soft) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func glowShadow(_ color: Color = BrandTheme.accent, radius: CGFloat = 16) -> some View {
        self.shadow(color: color.opacity(0.4), radius: radius, y: 4)
    }
    
    /// Applies a shimmer/loading effect
    func shimmer(isActive: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isActive: isActive))
    }
    
    /// Applies a pulsing animation
    func pulse(isActive: Bool = true) -> some View {
        self.modifier(PulseModifier(isActive: isActive))
    }
    
    /// Applies a bounce animation on appear
    func bounceOnAppear(delay: Double = 0) -> some View {
        self.modifier(BounceOnAppearModifier(delay: delay))
    }
}

// MARK: - Animation Modifiers

private struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func body(content: Content) -> some View {
        if isActive && !reduceMotion {
            TimelineView(.animation(minimumInterval: 1.0/30, paused: false)) { timeline in
                let phase = computePhase(for: timeline.date)
                
                content
                    .overlay(
                        GeometryReader { geo in
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.25),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: geo.size.width * 1.5)
                            .offset(x: phase * geo.size.width * 2.5 - geo.size.width * 0.75)
                        }
                        .mask(content)
                    )
            }
        } else {
            content
        }
    }
    
    private func computePhase(for date: Date) -> CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = seconds.truncatingRemainder(dividingBy: 2.0)
        return CGFloat(cycle / 2.0)
    }
}

private struct PulseModifier: ViewModifier {
    let isActive: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func body(content: Content) -> some View {
        if isActive && !reduceMotion {
            TimelineView(.animation(minimumInterval: 1.0/20, paused: false)) { timeline in
                let scale = computeScale(for: timeline.date)
                
                content
                    .scaleEffect(scale)
            }
        } else {
            content
        }
    }
    
    private func computeScale(for date: Date) -> CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = sin(seconds * 2.5)
        return 1.0 + CGFloat(cycle) * 0.03 // Subtle 3% pulse
    }
}

private struct BounceOnAppearModifier: ViewModifier {
    let delay: Double
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1 : (reduceMotion ? 1 : 0.85))
            .opacity(appeared ? 1 : 0)
            .onAppear {
                if reduceMotion {
                    appeared = true
                } else {
                    // Cap delay to prevent excessive wait
                    let cappedDelay = min(delay, 0.5)
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.1).delay(cappedDelay)) {
                        appeared = true
                    }
                }
            }
    }
}

// MARK: - Progress Components

struct AnimatedProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 12
    var showPercentage: Bool = true
    var gradientColors: [Color] = [BrandTheme.accent, BrandTheme.accentSoft, BrandTheme.primaryLight]
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        let clamped = max(0, min(progress, 1))
        
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    BrandTheme.borderSubtle.opacity(0.3),
                    lineWidth: lineWidth
                )
            
            // Progress ring
            Circle()
                .trim(from: 0, to: CGFloat(animatedProgress))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Center content
            if showPercentage {
                VStack(spacing: 2) {
                    Text("\(Int(animatedProgress * 100))")
                        .font(DesignSystem.text.displaySmall)
                        .fontWeight(.black)
                        .foregroundColor(BrandTheme.textPrimary)
                        .contentTransition(.numericText())
                    Text("%")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
        }
        .onAppear {
            if reduceMotion {
                animatedProgress = clamped
            } else {
                // Smoother, optimized animation
                withAnimation(.spring(response: 0.9, dampingFraction: 0.85, blendDuration: 0.15)) {
                    animatedProgress = clamped
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            let newClamped = max(0, min(newValue, 1))
            if reduceMotion {
                animatedProgress = newClamped
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.1)) {
                    animatedProgress = newClamped
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(clamped * 100)) percent")
    }
}

struct AnimatedProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var cornerRadius: CGFloat = 4
    var color: Color = BrandTheme.accent
    var showGlow: Bool = false
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        let clamped = max(0, min(progress, 1))
        
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(BrandTheme.borderSubtle.opacity(0.3))
                
                // Progress
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(cornerRadius * 2, geo.size.width * CGFloat(animatedProgress)))
                    .shadow(color: showGlow ? color.opacity(0.4) : .clear, radius: 6, y: 2)
            }
        }
        .frame(height: height)
        .onAppear {
            if reduceMotion {
                animatedProgress = clamped
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.85, blendDuration: 0.1)) {
                    animatedProgress = clamped
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            let newClamped = max(0, min(newValue, 1))
            if reduceMotion {
                animatedProgress = newClamped
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.08)) {
                    animatedProgress = newClamped
                }
            }
        }
    }
}

// MARK: - Icon Container

struct IconContainer: View {
    let systemName: String
    var color: Color = BrandTheme.accent
    var size: Size = .medium
    var style: Style = .filled
    
    enum Size {
        case small, medium, large, hero
        
        var containerSize: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 48
            case .large: return 64
            case .hero: return 88
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 22
            case .large: return 30
            case .hero: return 40
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 14
            case .large: return 18
            case .hero: return 24
            }
        }
    }
    
    enum Style {
        case filled, soft, outlined, gradient
    }
    
    var body: some View {
        ZStack {
            switch style {
            case .filled:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .fill(color)
            case .soft:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .fill(color.opacity(0.12))
            case .outlined:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .strokeBorder(color, lineWidth: 2)
            case .gradient:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Image(systemName: systemName)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(style == .filled || style == .gradient ? .white : color)
        }
        .frame(width: size.containerSize, height: size.containerSize)
    }
}

// MARK: - Celebration Effects

struct ConfettiView: View {
    @Binding var isActive: Bool
    var particleCount: Int = 35 // Reduced for performance
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var particles: [(id: Int, x: CGFloat, y: CGFloat, scale: CGFloat, colorIndex: Int)] = []
    
    private let colors: [Color] = [BrandTheme.accent, BrandTheme.success, BrandTheme.warning, BrandTheme.love, BrandTheme.mind]
    
    var body: some View {
        GeometryReader { geo in
            // Use Canvas for GPU-accelerated rendering
            Canvas { context, size in
                for particle in particles {
                    let particleSize = 7 * particle.scale
                    let rect = CGRect(
                        x: particle.x - particleSize / 2,
                        y: particle.y - particleSize / 2,
                        width: particleSize,
                        height: particleSize
                    )
                    
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(colors[particle.colorIndex % colors.count])
                    )
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    if reduceMotion {
                        // Quick fade for reduced motion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isActive = false
                        }
                    } else {
                        triggerConfetti(in: geo.size)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func triggerConfetti(in size: CGSize) {
        particles = (0..<particleCount).map { i in
            (
                id: i,
                x: size.width / 2,
                y: size.height / 2,
                scale: CGFloat.random(in: 0.6...1.3),
                colorIndex: Int.random(in: 0..<colors.count)
            )
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            particles = particles.map { particle in
                var p = particle
                p.x = CGFloat.random(in: size.width * 0.1...size.width * 0.9)
                p.y = CGFloat.random(in: size.height * 0.1...size.height * 0.9)
                return p
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.4)) {
                particles = particles.map { particle in
                    var p = particle
                    p.scale = 0
                    return p
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isActive = false
                particles = []
            }
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            IconContainer(systemName: icon, color: BrandTheme.mutedText, size: .hero, style: .soft)
            
            VStack(spacing: DesignSystem.spacing.sm) {
                Text(title)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(message)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(GlowButtonStyle(size: .medium))
            }
        }
        .padding(DesignSystem.spacing.xxl)
    }
}

// MARK: - Loading State

struct LoadingView: View {
    var message: String = "Loading..."
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            if reduceMotion {
                // Static loading indicator for reduced motion
                ZStack {
                    Circle()
                        .stroke(BrandTheme.borderSubtle, lineWidth: 4)
                        .frame(width: 48, height: 48)
                    
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(BrandTheme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 48, height: 48)
                }
            } else {
                // Animated loading using TimelineView
                TimelineView(.animation(minimumInterval: 1.0/60, paused: false)) { timeline in
                    let rotation = computeRotation(for: timeline.date)
                    
                    ZStack {
                        Circle()
                            .stroke(BrandTheme.borderSubtle, lineWidth: 4)
                            .frame(width: 48, height: 48)
                        
                        Circle()
                            .trim(from: 0, to: 0.3)
                            .stroke(BrandTheme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 48, height: 48)
                            .rotationEffect(.degrees(rotation))
                    }
                }
            }
            
            Text(message)
                .font(DesignSystem.text.labelMedium)
                .foregroundColor(BrandTheme.mutedText)
        }
    }
    
    private func computeRotation(for date: Date) -> Double {
        let seconds = date.timeIntervalSinceReferenceDate
        return (seconds * 360).truncatingRemainder(dividingBy: 360)
    }
}
