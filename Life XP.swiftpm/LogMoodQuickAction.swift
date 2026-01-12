import SwiftUI

// MARK: - Log Mood Quick Action

struct LogMoodFloatingButton: View {
    @Binding var showingLogMood: Bool

    var body: some View {
        Button {
            showingLogMood = true
            HapticsEngine.lightImpact()
        } label: {
            Image(systemName: "face.smiling")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(BrandTheme.accent)
                        .shadow(color: BrandTheme.accent.opacity(0.3), radius: 10, x: 0, y: 6)
                )
                .accessibilityLabel(Text(L10n.actionLogMoodTitle))
        }
        .buttonStyle(.plain)
    }
}

struct LogMoodSheet: View {
    @ObservedObject var manager: JournalManager

    var body: some View {
        QuickMoodSheet(manager: manager)
    }
}

#Preview {
    LogMoodFloatingButton(showingLogMood: .constant(false))
}
