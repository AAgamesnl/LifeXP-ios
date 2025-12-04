import SwiftUI

struct BrandTheme {
    static let waveSky = Color(hex: "D8E6FF", default: .accentColor)
    static let waveMist = Color(hex: "D9D4FF", default: .accentColor)
    static let waveDeep = Color(hex: "A8BCFF", default: .accentColor)
    static let canvas = Color(hex: "F3F6FF", default: .systemBackground)
    static let accent = Color(hex: "2F5BFF", default: .accentColor)
    static let accentSoft = Color(hex: "4F72FF", default: .accentColor)
    static let accentLine = Color.white
    static let cardBackground = canvas
    static let textPrimary = Color(hex: "1F2A44", default: .primary)
    static let mutedText = Color(hex: "3E4B6A", default: .secondary)

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
            .overlay(
                LinearGradient(
                    colors: [BrandTheme.canvas.opacity(0.55), Color.white.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()

            WaveShape(amplitude: 48, waveLength: 280)
                .fill(
                    LinearGradient(
                        colors: [BrandTheme.waveDeep.opacity(0.6), BrandTheme.waveMist.opacity(0.65)],
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
                        colors: [BrandTheme.waveSky.opacity(0.75), BrandTheme.waveDeep.opacity(0.65)],
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
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(BrandTheme.cardBackground)
                    .overlay(
                        LinearGradient(
                            colors: [BrandTheme.waveMist.opacity(0.45), BrandTheme.waveSky.opacity(0.35)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(BrandTheme.accent.opacity(0.22), lineWidth: 1)
            )
            .shadow(color: BrandTheme.waveDeep.opacity(0.26), radius: 16, y: 10)
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
    func brandCard(cornerRadius: CGFloat = 24) -> some View {
        modifier(BrandCardModifier(cornerRadius: cornerRadius))
    }
}
