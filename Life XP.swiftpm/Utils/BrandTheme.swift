import SwiftUI

struct BrandTheme {
    static let gradientTop = Color(hex: "DCD7FF", default: .accentColor)
    static let gradientMiddle = Color(hex: "B7A9FF", default: .accentColor)
    static let gradientBottom = Color(hex: "7E6BFF", default: .accentColor)
    static let accent = Color(hex: "7A6BFF", default: .accentColor)
    static let highlight = Color(hex: "9F8CFF", default: .accentColor)
    static let surface = Color.white.opacity(0.18)
}

struct BrandBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [BrandTheme.gradientTop, BrandTheme.gradientMiddle, BrandTheme.gradientBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(BrandTheme.highlight.opacity(0.35))
                .blur(radius: 140)
                .offset(x: -120, y: -200)

            Circle()
                .fill(BrandTheme.accent.opacity(0.25))
                .blur(radius: 160)
                .offset(x: 180, y: 220)
        }
    }
}

private struct BrandCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                LiquidGlassBackground(cornerRadius: cornerRadius)
            )
    }
}

private struct LiquidGlassBackground: View {
    var cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                LiquidGlassHighlight(cornerRadius: cornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(BrandTheme.accent.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: BrandTheme.accent.opacity(0.15), radius: 16, y: 8)
    }
}

private struct LiquidGlassHighlight: View {
    var cornerRadius: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let offset = CGFloat(sin(time / 2.8) * 36)
            let hue = Double(sin(time / 3.4) * 10)

            LinearGradient(
                colors: [
                    BrandTheme.gradientTop.opacity(0.6),
                    BrandTheme.highlight.opacity(0.55),
                    BrandTheme.gradientBottom.opacity(0.65)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(hue))
            .blur(radius: 30)
            .opacity(0.38)
            .scaleEffect(1.2)
            .offset(x: offset, y: -offset * 0.6)
            .mask(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
        }
    }
}

extension View {
    func brandCard(cornerRadius: CGFloat = 24) -> some View {
        modifier(BrandCardModifier(cornerRadius: cornerRadius))
    }
}
