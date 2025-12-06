import SwiftUI

struct DesignSystem {
    struct Spacing {
        let xs: CGFloat = 4
        let sm: CGFloat = 8
        let md: CGFloat = 12
        let lg: CGFloat = 16
        let xl: CGFloat = 20
        let xxl: CGFloat = 24
    }

    struct Radii {
        let sm: CGFloat = 12
        let md: CGFloat = 16
        let lg: CGFloat = 22
        let xl: CGFloat = 28
    }

    struct Shadows {
        let soft = Shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
        let lifted = Shadow(color: Color.black.opacity(0.18), radius: 22, x: 0, y: 12)
    }

    struct TextStyles {
        let heroTitle = Font.system(.title2, design: .rounded).weight(.bold)
        let sectionTitle = Font.system(.headline, design: .rounded).weight(.semibold)
        let captionEmphasis = Font.caption.weight(.semibold)
    }

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    static let spacing = Spacing()
    static let radius = Radii()
    static let shadow = Shadows()
    static let text = TextStyles()
}

struct BrandTheme {
    static let waveSky = Color.dynamic(
        light: Color(hex: "E9F2FF", default: .accentColor),
        dark: Color(hex: "0F1A2F", default: .accentColor)
    )
    static let waveMist = Color.dynamic(
        light: Color(hex: "EAE6FF", default: .accentColor),
        dark: Color(hex: "182743", default: .accentColor)
    )
    static let waveDeep = Color.dynamic(
        light: Color(hex: "C7D8FF", default: .accentColor),
        dark: Color(hex: "23385E", default: .accentColor)
    )
    static let accent = Color.dynamic(
        light: Color(hex: "5E7BFF", default: .accentColor),
        dark: Color(hex: "8DB2FF", default: .accentColor)
    )
    static let accentSoft = Color.dynamic(
        light: Color(hex: "6D8CFF", default: .accentColor),
        dark: Color(hex: "ABC6FF", default: .accentColor)
    )
    static let accentLine = Color.dynamic(
        light: .white,
        dark: Color(hex: "E9EEFF", default: .white)
    )
    static let cardBackground = Color.dynamic(
        light: .white,
        dark: Color(hex: "111A2E", default: .black)
    )
    static let textPrimary = Color.dynamic(
        light: Color(hex: "1E2B4D", default: .primary),
        dark: Color(hex: "EEF2FF", default: .primary)
    )
    static let mutedText = Color.dynamic(
        light: Color(hex: "7A88A6", default: .secondary),
        dark: Color(hex: "AAB5D6", default: .secondary)
    )

    // Legacy names kept for compatibility across views
    static let gradientTop = waveSky
    static let gradientMiddle = waveMist
    static let gradientBottom = waveDeep
}

struct BrandBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            WaveShape(amplitude: 48, waveLength: 280)
                .fill(
                    LinearGradient(
                        colors: [BrandTheme.waveDeep.opacity(0.45), BrandTheme.waveMist.opacity(0.55)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 360)
                .offset(x: -40, y: -120)
                .blur(radius: 14)

            WaveShape(amplitude: 60, waveLength: 240)
                .fill(
                    LinearGradient(
                        colors: [BrandTheme.waveSky.opacity(0.7), BrandTheme.waveDeep.opacity(0.5)],
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                )
                .frame(height: 420)
                .offset(x: 60, y: 240)
                .blur(radius: 18)
        }
    }
}

private struct BrandCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.radius.lg

    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(BrandTheme.cardBackground.opacity(0.96))
                    .overlay(
                        LinearGradient(
                            colors: [BrandTheme.waveMist.opacity(0.35), BrandTheme.waveSky.opacity(0.25)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(BrandTheme.accent.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: BrandTheme.waveDeep.opacity(0.22), radius: DesignSystem.shadow.soft.radius, y: DesignSystem.shadow.soft.y)
    }
}

private struct WaveShape: Shape {
    var amplitude: CGFloat
    var waveLength: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))

        let steps = Int(rect.width / 8)
        for step in 0...steps {
            let x = CGFloat(step) / CGFloat(steps) * rect.width
            let relative = x / waveLength
            let sine = sin(relative * .pi * 2)
            let y = rect.midY + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

extension View {
    func brandCard(cornerRadius: CGFloat = DesignSystem.radius.lg) -> some View {
        modifier(BrandCardModifier(cornerRadius: cornerRadius))
    }

    func brandShadow(_ shadow: DesignSystem.Shadow = DesignSystem.shadow.soft) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
