import SwiftUI

struct BrandTheme {
    static let waveSky = Color(hex: "E9F2FF", default: .accentColor)
    static let waveMist = Color(hex: "EAE6FF", default: .accentColor)
    static let waveDeep = Color(hex: "C7D8FF", default: .accentColor)
    static let accent = Color(hex: "5E7BFF", default: .accentColor)
    static let accentSoft = Color(hex: "6D8CFF", default: .accentColor)
    static let accentLine = Color.white
    static let cardBackground = Color.white
    static let mutedText = Color(hex: "7A88A6", default: .secondary)

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
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding()
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
            .shadow(color: BrandTheme.waveDeep.opacity(0.22), radius: 16, y: 8)
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
