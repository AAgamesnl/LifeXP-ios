import SwiftUI

// MARK: - Design System 3.0 - Premium Visual Experience

/// Comprehensive design system with spacing, typography, colors, and components.
/// Optimized for smooth 120fps animations and modern visual aesthetics.
struct DesignSystem {
    // MARK: - Spacing Scale
    struct Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let huge: CGFloat = 48
        static let massive: CGFloat = 64
    }

    // MARK: - Corner Radii
    struct Radii {
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 36
        static let pill: CGFloat = 999
    }

    // MARK: - Shadow System
    struct Shadows {
        static let subtle = Shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        static let soft = Shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 6)
        static let lifted = Shadow(color: Color.black.opacity(0.15), radius: 24, x: 0, y: 12)
        static let floating = Shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 16)
        static let glow = Shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 4)
        static func coloredGlow(_ color: Color) -> Shadow {
            Shadow(color: color.opacity(0.4), radius: 20, x: 0, y: 8)
        }
    }

    // MARK: - Typography System
    struct TextStyles {
        // Display
        static let heroTitle = Font.system(.largeTitle, design: .rounded).weight(.black)
        static let displayLarge = Font.system(size: 48, weight: .black, design: .rounded)
        static let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
        static let displaySmall = Font.system(size: 28, weight: .bold, design: .rounded)
        
        // Headlines
        static let headline = Font.system(.headline, design: .rounded).weight(.bold)
        static let headlineLarge = Font.system(.title2, design: .rounded).weight(.bold)
        static let headlineMedium = Font.system(.title3, design: .rounded).weight(.semibold)
        
        // Body
        static let bodyLarge = Font.system(.body, design: .rounded).weight(.medium)
        static let bodyMedium = Font.system(.callout, design: .rounded)
        static let bodySmall = Font.system(.subheadline, design: .rounded)
        
        // Labels
        static let labelLarge = Font.system(.subheadline, design: .rounded).weight(.semibold)
        static let labelMedium = Font.system(.footnote, design: .rounded).weight(.semibold)
        static let labelSmall = Font.system(.caption, design: .rounded).weight(.medium)
        
        // Captions
        static let captionEmphasis = Font.caption.weight(.bold)
        static let captionRegular = Font.caption
        static let captionMini = Font.caption2
        
        // Special
        static let sectionTitle = Font.system(.headline, design: .rounded).weight(.bold)
        static let cardTitle = Font.system(.title3, design: .rounded).weight(.bold)
        static let statNumber = Font.system(size: 64, weight: .black, design: .rounded)
        static let xpCounter = Font.system(.title, design: .monospaced).weight(.bold)
    }

    // MARK: - Animation Durations
    struct Durations {
        static let instant: Double = 0.1
        static let fast: Double = 0.2
        static let normal: Double = 0.3
        static let slow: Double = 0.45
        static let gentle: Double = 0.6
        static let dramatic: Double = 0.8
    }

    // MARK: - 120fps Optimized Animation Curves
    struct AnimationCurves {
        /// Ultra-fast micro-interaction (button taps)
        static let micro = Animation.spring(response: 0.22, dampingFraction: 0.92)
        /// Quick response for immediate feedback
        static let quick = Animation.spring(response: 0.28, dampingFraction: 0.88)
        /// Snappy spring for interactions
        static let snappy = Animation.spring(response: 0.32, dampingFraction: 0.84)
        /// Smooth spring for state changes
        static let smooth = Animation.spring(response: 0.48, dampingFraction: 0.88)
        /// Gentle spring for subtle transitions
        static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.92)
        /// Bouncy spring for celebrations
        static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.68)
        /// Linear for continuous animations
        static let linear = Animation.linear(duration: 0.35)
    }

    // MARK: - Icon Sizes
    struct IconSizes {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let hero: CGFloat = 64
    }

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    // MARK: - Legacy Singleton Accessors (for compatibility)
    static let spacing = SpacingLegacy()
    static let radius = RadiiLegacy()
    static let shadow = ShadowsLegacy()
    static let text = TextStylesLegacy()
    static let duration = DurationsLegacy()
    static let animation = AnimationCurvesLegacy()
    static let iconSize = IconSizesLegacy()
    
    struct SpacingLegacy {
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
    
    struct RadiiLegacy {
        let xs: CGFloat = 8
        let sm: CGFloat = 12
        let md: CGFloat = 16
        let lg: CGFloat = 20
        let xl: CGFloat = 28
        let xxl: CGFloat = 36
        let pill: CGFloat = 999
    }
    
    struct ShadowsLegacy {
        let subtle = Shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        let soft = Shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 6)
        let lifted = Shadow(color: Color.black.opacity(0.15), radius: 24, x: 0, y: 12)
        let floating = Shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 16)
        let glow = Shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 4)
        func coloredGlow(_ color: Color) -> Shadow {
            Shadow(color: color.opacity(0.4), radius: 20, x: 0, y: 8)
        }
    }
    
    struct TextStylesLegacy {
        let heroTitle = Font.system(.largeTitle, design: .rounded).weight(.black)
        let displayLarge = Font.system(size: 48, weight: .black, design: .rounded)
        let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
        let displaySmall = Font.system(size: 28, weight: .bold, design: .rounded)
        let headline = Font.system(.headline, design: .rounded).weight(.bold)
        let headlineLarge = Font.system(.title2, design: .rounded).weight(.bold)
        let headlineMedium = Font.system(.title3, design: .rounded).weight(.semibold)
        let bodyLarge = Font.system(.body, design: .rounded).weight(.medium)
        let bodyMedium = Font.system(.callout, design: .rounded)
        let bodySmall = Font.system(.subheadline, design: .rounded)
        let labelLarge = Font.system(.subheadline, design: .rounded).weight(.semibold)
        let labelMedium = Font.system(.footnote, design: .rounded).weight(.semibold)
        let labelSmall = Font.system(.caption, design: .rounded).weight(.medium)
        let captionEmphasis = Font.caption.weight(.bold)
        let captionRegular = Font.caption
        let captionMini = Font.caption2
        let sectionTitle = Font.system(.headline, design: .rounded).weight(.bold)
        let cardTitle = Font.system(.title3, design: .rounded).weight(.bold)
        let statNumber = Font.system(size: 64, weight: .black, design: .rounded)
        let xpCounter = Font.system(.title, design: .monospaced).weight(.bold)
    }
    
    struct DurationsLegacy {
        let instant: Double = 0.1
        let fast: Double = 0.2
        let normal: Double = 0.3
        let slow: Double = 0.45
        let gentle: Double = 0.6
        let dramatic: Double = 0.8
    }
    
    struct AnimationCurvesLegacy {
        let micro = Animation.spring(response: 0.2, dampingFraction: 0.9)
        let quick = Animation.spring(response: 0.25, dampingFraction: 0.85)
        let snappy = Animation.spring(response: 0.3, dampingFraction: 0.8)
        let smooth = Animation.spring(response: 0.4, dampingFraction: 0.85)
        let gentle = Animation.spring(response: 0.5, dampingFraction: 0.9)
        let bouncy = Animation.spring(response: 0.45, dampingFraction: 0.65)
        let elastic = Animation.spring(response: 0.45, dampingFraction: 0.65)
    }
    
    struct IconSizesLegacy {
        let xs: CGFloat = 12
        let sm: CGFloat = 16
        let md: CGFloat = 20
        let lg: CGFloat = 24
        let xl: CGFloat = 32
        let xxl: CGFloat = 48
        let hero: CGFloat = 64
    }
}

// MARK: - Brand Theme 3.0 - Vibrant Modern Colors

/// Premium color system with vibrant gradients and full light/dark mode support.
struct BrandTheme {
    // MARK: - Primary Palette (Vibrant Purple-Blue)
    static let primary = Color.dynamic(
        light: Color(hex: "6366F1", default: .indigo),
        dark: Color(hex: "818CF8", default: .indigo)
    )
    
    static let primaryLight = Color.dynamic(
        light: Color(hex: "818CF8", default: .indigo),
        dark: Color(hex: "A5B4FC", default: .indigo)
    )
    
    static let primaryDark = Color.dynamic(
        light: Color(hex: "4F46E5", default: .indigo),
        dark: Color(hex: "6366F1", default: .indigo)
    )
    
    // MARK: - Accent Colors (Electric Violet)
    static let accent = Color.dynamic(
        light: Color(hex: "7C3AED", default: .purple),
        dark: Color(hex: "A78BFA", default: .purple)
    )
    
    static let accentSoft = Color.dynamic(
        light: Color(hex: "A78BFA", default: .purple),
        dark: Color(hex: "C4B5FD", default: .purple)
    )
    
    static let accentMuted = Color.dynamic(
        light: Color(hex: "EDE9FE", default: .purple.opacity(0.2)),
        dark: Color(hex: "3B2D5A", default: .purple.opacity(0.3))
    )
    
    // MARK: - Semantic Colors (Vibrant)
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
        light: Color(hex: "0EA5E9", default: .cyan),
        dark: Color(hex: "38BDF8", default: .cyan)
    )
    
    // MARK: - Dimension Colors (Rich & Vibrant)
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
    
    // MARK: - Background Colors (Rich Depth)
    static let backgroundTop = Color.dynamic(
        light: Color(hex: "F8FAFC", default: .white),
        dark: Color(hex: "121225", default: .black)
    )
    
    static let backgroundMiddle = Color.dynamic(
        light: Color(hex: "EEF2FF", default: .indigo.opacity(0.1)),
        dark: Color(hex: "1B1B35", default: .indigo.opacity(0.2))
    )
    
    static let backgroundBottom = Color.dynamic(
        light: Color(hex: "E0E7FF", default: .indigo.opacity(0.15)),
        dark: Color(hex: "19192F", default: .indigo.opacity(0.3))
    )
    
    // Legacy aliases
    static let waveSky = backgroundTop
    static let waveMist = backgroundMiddle
    static let waveDeep = backgroundBottom
    
    // MARK: - Surface Colors
    static let cardBackground = Color.dynamic(
        light: .white,
        dark: Color(hex: "1E1E32", default: .black)
    )
    
    static let cardBackgroundElevated = Color.dynamic(
        light: Color(hex: "FAFAFA", default: .white),
        dark: Color(hex: "252540", default: .gray)
    )
    
    static let surfaceOverlay = Color.dynamic(
        light: Color.white.opacity(0.95),
        dark: Color(hex: "1E1E32", default: .black).opacity(0.98)
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
    
    // MARK: - Premium Gradient Presets
    static let gradientPrimary = LinearGradient(
        colors: [
            Color(hex: "7C3AED", default: .purple),
            Color(hex: "6366F1", default: .indigo),
            Color(hex: "0EA5E9", default: .cyan)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientAccent = LinearGradient(
        colors: [
            Color(hex: "A78BFA", default: .purple),
            Color(hex: "7C3AED", default: .purple)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientBackground = LinearGradient(
        colors: [backgroundTop, backgroundMiddle, backgroundBottom],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let gradientCard = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGlow = RadialGradient(
        colors: [accent.opacity(0.5), accent.opacity(0)],
        center: .center,
        startRadius: 0,
        endRadius: 120
    )
    
    static let gradientSunrise = LinearGradient(
        colors: [
            Color(hex: "F472B6", default: .pink),
            Color(hex: "F59E0B", default: .orange),
            Color(hex: "FBBF24", default: .yellow)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientOcean = LinearGradient(
        colors: [
            Color(hex: "0EA5E9", default: .cyan),
            Color(hex: "6366F1", default: .indigo),
            Color(hex: "7C3AED", default: .purple)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Legacy aliases
    static let gradientTop = backgroundTop
    static let gradientMiddle = backgroundMiddle
    static let gradientBottom = backgroundBottom
}

// MARK: - Premium Animated Background

/// Beautiful mesh-gradient inspired background with silky smooth 120fps animations.
struct BrandBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var animated: Bool = true
    var intensity: Double = 1.0
    
    var body: some View {
        if animated && !reduceMotion {
            AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
                PremiumBackgroundCanvas(
                    time: timeline.date.timeIntervalSinceReferenceDate,
                    intensity: intensity,
                    isDark: colorScheme == .dark
                )
            }
        } else {
            StaticPremiumBackground(intensity: intensity)
        }
    }
}

/// GPU-accelerated premium background using Canvas
private struct PremiumBackgroundCanvas: View {
    let time: TimeInterval
    let intensity: Double
    let isDark: Bool
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                // Base gradient
                let baseGradient = Gradient(colors: isDark ? [
                    BrandTheme.backgroundTop,
                    BrandTheme.backgroundMiddle,
                    BrandTheme.backgroundBottom
                ] : [
                    BrandTheme.backgroundTop,
                    BrandTheme.backgroundMiddle,
                    BrandTheme.backgroundBottom
                ])
                
                let baseRect = CGRect(origin: .zero, size: size)
                context.fill(
                    Path(baseRect),
                    with: .linearGradient(
                        baseGradient,
                        startPoint: .zero,
                        endPoint: CGPoint(x: 0, y: size.height)
                    )
                )
                
                // Animated orbs
                let orb1X = size.width * 0.3 + sin(time * 0.3) * 50 * intensity
                let orb1Y = size.height * 0.2 + cos(time * 0.25) * 30 * intensity
                
                let orb2X = size.width * 0.7 + cos(time * 0.35) * 40 * intensity
                let orb2Y = size.height * 0.6 + sin(time * 0.3) * 35 * intensity
                
                let orb3X = size.width * 0.5 + sin(time * 0.4) * 30 * intensity
                let orb3Y = size.height * 0.85 + cos(time * 0.28) * 25 * intensity
                
                // Orb 1 - Purple/Violet
                let orb1Colors = isDark ? [
                    Color(hex: "7C3AED", default: .purple).opacity(0.25 * intensity),
                    Color(hex: "7C3AED", default: .purple).opacity(0)
                ] : [
                    Color(hex: "7C3AED", default: .purple).opacity(0.15 * intensity),
                    Color(hex: "7C3AED", default: .purple).opacity(0)
                ]
                
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 60))
                    ctx.fill(
                        Circle().path(in: CGRect(x: orb1X - 150, y: orb1Y - 150, width: 300, height: 300)),
                        with: .radialGradient(
                            Gradient(colors: orb1Colors),
                            center: CGPoint(x: orb1X, y: orb1Y),
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                }
                
                // Orb 2 - Cyan/Blue
                let orb2Colors = isDark ? [
                    Color(hex: "0EA5E9", default: .cyan).opacity(0.2 * intensity),
                    Color(hex: "0EA5E9", default: .cyan).opacity(0)
                ] : [
                    Color(hex: "0EA5E9", default: .cyan).opacity(0.12 * intensity),
                    Color(hex: "0EA5E9", default: .cyan).opacity(0)
                ]
                
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 70))
                    ctx.fill(
                        Circle().path(in: CGRect(x: orb2X - 180, y: orb2Y - 180, width: 360, height: 360)),
                        with: .radialGradient(
                            Gradient(colors: orb2Colors),
                            center: CGPoint(x: orb2X, y: orb2Y),
                            startRadius: 0,
                            endRadius: 180
                        )
                    )
                }
                
                // Orb 3 - Pink/Magenta
                let orb3Colors = isDark ? [
                    Color(hex: "EC4899", default: .pink).opacity(0.18 * intensity),
                    Color(hex: "EC4899", default: .pink).opacity(0)
                ] : [
                    Color(hex: "EC4899", default: .pink).opacity(0.1 * intensity),
                    Color(hex: "EC4899", default: .pink).opacity(0)
                ]
                
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 55))
                    ctx.fill(
                        Circle().path(in: CGRect(x: orb3X - 120, y: orb3Y - 120, width: 240, height: 240)),
                        with: .radialGradient(
                            Gradient(colors: orb3Colors),
                            center: CGPoint(x: orb3X, y: orb3Y),
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                }
            }
            .ignoresSafeArea()
            .drawingGroup()
        }
    }
}

/// Static premium background for reduced motion
private struct StaticPremiumBackground: View {
    let intensity: Double
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [BrandTheme.backgroundTop, BrandTheme.backgroundMiddle, BrandTheme.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Static orb 1
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "7C3AED", default: .purple).opacity(colorScheme == .dark ? 0.2 : 0.12),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: -50, y: -100)
                .blur(radius: 50)
            
            // Static orb 2
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "0EA5E9", default: .cyan).opacity(colorScheme == .dark ? 0.15 : 0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 180
                    )
                )
                .frame(width: 360, height: 360)
                .offset(x: 80, y: 150)
                .blur(radius: 60)
        }
        .ignoresSafeArea()
    }
}

/// Simplified static background for performance-critical views
struct BrandBackgroundStatic: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [BrandTheme.backgroundTop, BrandTheme.backgroundMiddle, BrandTheme.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Subtle accent glow
            RadialGradient(
                colors: [
                    Color(hex: "7C3AED", default: .purple).opacity(colorScheme == .dark ? 0.08 : 0.05),
                    Color.clear
                ],
                center: UnitPoint(x: 0.3, y: 0.2),
                startRadius: 0,
                endRadius: 400
            )

            // Secondary ambient glow for depth
            RadialGradient(
                colors: [
                    Color(hex: "0EA5E9", default: .cyan).opacity(colorScheme == .dark ? 0.06 : 0.04),
                    Color.clear
                ],
                center: UnitPoint(x: 0.85, y: 0.8),
                startRadius: 0,
                endRadius: 520
            )

            // Soft vignette to keep contrast intentional in dark mode
            LinearGradient(
                colors: colorScheme == .dark ? [
                    Color.black.opacity(0.18),
                    Color.clear,
                    Color.black.opacity(0.28)
                ] : [
                    Color.black.opacity(0.04),
                    Color.clear,
                    Color.black.opacity(0.06)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Card Modifiers

/// Modern glassmorphic card style
struct BrandCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.Radii.lg
    var enableGlow: Bool = false
    var glowColor: Color = BrandTheme.accent
    var padding: CGFloat = DesignSystem.Spacing.lg
    var shadowIntensity: Double = 1.0
    
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(colorScheme == .dark ? 
                          Color(hex: "1E1E32", default: .black).opacity(0.9) :
                          Color.white.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.15 : 0.5),
                                Color.white.opacity(colorScheme == .dark ? 0.05 : 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.08),
                radius: 16 * shadowIntensity,
                y: 8 * shadowIntensity
            )
            .background(
                Group {
                    if enableGlow {
                        RoundedRectangle(cornerRadius: cornerRadius + 4, style: .continuous)
                            .fill(glowColor.opacity(0.2))
                            .blur(radius: 15)
                            .offset(y: 5)
                    }
                }
            )
    }
}

/// Elevated card style for prominent content
private struct ElevatedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.Radii.xl
    var accentColor: Color = BrandTheme.accent
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.Spacing.xl)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(colorScheme == .dark ?
                              Color(hex: "1E1E32", default: .black) :
                              Color.white)
                    
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.1),
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
                    .strokeBorder(accentColor.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: accentColor.opacity(0.25), radius: 24, y: 12)
            .shadow(color: Color.black.opacity(0.1), radius: 12, y: 6)
    }
}

/// Subtle card for secondary content
private struct SubtleCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.Radii.md
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(colorScheme == .dark ?
                          Color.white.opacity(0.05) :
                          Color.black.opacity(0.03))
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
            case .small: return EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
            case .medium: return EdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 28)
            case .large: return EdgeInsets(top: 18, leading: 36, bottom: 18, trailing: 36)
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .subheadline.weight(.semibold)
            case .medium: return .headline.weight(.bold)
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
                                colors: [color.opacity(0.95), color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Capsule()
                        .fill(Color.white.opacity(configuration.isPressed ? 0 : 0.25))
                        .padding(1)
                }
            )
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.5), radius: configuration.isPressed ? 6 : 16, y: configuration.isPressed ? 3 : 8)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SoftButtonStyle: ButtonStyle {
    var color: Color = BrandTheme.accent
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                Capsule()
                    .fill(color.opacity(configuration.isPressed ? 0.2 : 0.12))
            )
            .overlay(
                Capsule()
                    .strokeBorder(color.opacity(0.25), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

struct GhostButtonStyle: ButtonStyle {
    var color: Color = BrandTheme.textPrimary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.medium))
            .foregroundColor(color.opacity(configuration.isPressed ? 0.6 : 1))
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                Capsule()
                    .fill(color.opacity(configuration.isPressed ? 0.1 : 0))
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.15, dampingFraction: 0.9), value: configuration.isPressed)
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
            case .small: return .caption2.weight(.bold)
            case .medium: return .caption.weight(.bold)
            case .large: return .subheadline.weight(.bold)
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
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
                .fill(color.opacity(0.15))
        )
        .overlay(
            Capsule()
                .strokeBorder(color.opacity(0.25), lineWidth: 1)
        )
    }
}

struct XPChip: View {
    let xp: Int
    var size: ChipView.Size = .medium
    
    var body: some View {
        ChipView(
            text: "+\(xp) XP",
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
        cornerRadius: CGFloat = DesignSystem.Radii.lg,
        enableGlow: Bool = false,
        glowColor: Color = BrandTheme.accent,
        padding: CGFloat = DesignSystem.Spacing.lg
    ) -> some View {
        modifier(BrandCardModifier(
            cornerRadius: cornerRadius,
            enableGlow: enableGlow,
            glowColor: glowColor,
            padding: padding
        ))
    }
    
    func elevatedCard(
        cornerRadius: CGFloat = DesignSystem.Radii.xl,
        accentColor: Color = BrandTheme.accent
    ) -> some View {
        modifier(ElevatedCardModifier(cornerRadius: cornerRadius, accentColor: accentColor))
    }
    
    func subtleCard(cornerRadius: CGFloat = DesignSystem.Radii.md) -> some View {
        modifier(SubtleCardModifier(cornerRadius: cornerRadius))
    }
    
    func brandShadow(_ shadow: DesignSystem.Shadow = DesignSystem.Shadows.soft) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func glowShadow(_ color: Color = BrandTheme.accent, radius: CGFloat = 20) -> some View {
        self.shadow(color: color.opacity(0.45), radius: radius, y: 6)
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

// MARK: - 120fps Animation Modifiers

private struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func body(content: Content) -> some View {
        if isActive && !reduceMotion {
            AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
                let phase = computePhase(for: timeline.date)
                
                content
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
        let cycle = seconds.truncatingRemainder(dividingBy: 1.5)
        return CGFloat(cycle / 1.5)
    }
}

private struct PulseModifier: ViewModifier {
    let isActive: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func body(content: Content) -> some View {
        if isActive && !reduceMotion {
            AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
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
        let cycle = sin(seconds * 3)
        return 1.0 + CGFloat(cycle) * 0.02
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
                    let cappedDelay = min(delay, 0.4)
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75).delay(cappedDelay)) {
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
                .stroke(BrandTheme.borderSubtle.opacity(0.4), lineWidth: lineWidth)
            
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
                        .font(DesignSystem.TextStyles.displaySmall)
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
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animatedProgress = clamped
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            let newClamped = max(0, min(newValue, 1))
            if reduceMotion {
                animatedProgress = newClamped
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
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
                    .fill(BrandTheme.borderSubtle.opacity(0.4))
                
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
                    .shadow(color: showGlow ? color.opacity(0.5) : .clear, radius: 8, y: 3)
            }
        }
        .frame(height: height)
        .onAppear {
            if reduceMotion {
                animatedProgress = clamped
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    animatedProgress = clamped
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            let newClamped = max(0, min(newValue, 1))
            if reduceMotion {
                animatedProgress = newClamped
            } else {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
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
            case .small: return 40
            case .medium: return 52
            case .large: return 68
            case .hero: return 92
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 18
            case .medium: return 24
            case .large: return 32
            case .hero: return 44
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            case .hero: return 28
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
                    .fill(color.opacity(0.15))
            case .outlined:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .strokeBorder(color, lineWidth: 2)
            case .gradient:
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.75)],
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
    var particleCount: Int = 40
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var particles: [(id: Int, x: CGFloat, y: CGFloat, scale: CGFloat, rotation: Double, colorIndex: Int)] = []
    
    private let colors: [Color] = [
        BrandTheme.accent,
        BrandTheme.success,
        BrandTheme.warning,
        BrandTheme.love,
        BrandTheme.mind,
        BrandTheme.info
    ]
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for particle in particles {
                    let particleSize = 8 * particle.scale
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                scale: CGFloat.random(in: 0.5...1.4),
                rotation: Double.random(in: 0...360),
                colorIndex: Int.random(in: 0..<colors.count)
            )
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            particles = particles.map { particle in
                var p = particle
                p.x = CGFloat.random(in: size.width * 0.05...size.width * 0.95)
                p.y = CGFloat.random(in: size.height * 0.05...size.height * 0.95)
                return p
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.35)) {
                particles = particles.map { particle in
                    var p = particle
                    p.scale = 0
                    return p
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
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
        VStack(spacing: DesignSystem.Spacing.lg) {
            IconContainer(systemName: icon, color: BrandTheme.mutedText, size: .hero, style: .soft)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.TextStyles.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(message)
                    .font(DesignSystem.TextStyles.bodySmall)
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
        .padding(DesignSystem.Spacing.xxl)
    }
}

// MARK: - Loading State

struct LoadingView: View {
    var message: String = "Loading..."
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            if reduceMotion {
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
                AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
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
                .font(DesignSystem.TextStyles.labelMedium)
                .foregroundColor(BrandTheme.mutedText)
        }
    }
    
    private func computeRotation(for date: Date) -> Double {
        let seconds = date.timeIntervalSinceReferenceDate
        return (seconds * 360).truncatingRemainder(dividingBy: 360)
    }
}
