import SwiftUI

struct PacksView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Life Packs")
                                .font(.largeTitle.bold())
                                .foregroundColor(BrandTheme.textPrimary)

                            Text("Curated checklists that match the new soft-wave aesthetic.")
                                .font(.subheadline)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                        .padding(.horizontal)

                        LazyVStack(spacing: 18) {
                            ForEach(model.packs) { pack in
                                NavigationLink(destination: PackDetailView(pack: pack)) {
                                    PackCardView(pack: pack)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct PackCardView: View {
    @EnvironmentObject var model: AppModel
    let pack: CategoryPack

    private var accent: Color { BrandTheme.accent }
    private var accentSecondary: Color { BrandTheme.accentSoft }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.22), accentSecondary.opacity(0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .fill(BrandTheme.waveDeep.opacity(0.28))
                            .scaleEffect(0.9)
                            .offset(x: -6, y: -6)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(BrandTheme.accent.opacity(0.24), lineWidth: 1)
                    )

                Image(systemName: pack.iconSystemName)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: accent.opacity(0.35), radius: 6, y: 4)
            }
            .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(pack.title)
                        .font(.headline)
                        .foregroundColor(BrandTheme.textPrimary)

                    if pack.isPremium {
                        ProBadge()
                    }
                }

                Text(pack.subtitle)
                    .font(.subheadline)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(2)

                ProgressView(value: model.progress(for: pack), total: 1)
                    .tint(accent)

                Text("\(Int(model.progress(for: pack) * 100))% completed")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(BrandTheme.mutedText)
        }
        .brandCard(cornerRadius: 22)
    }
}

struct PackDetailView: View {
    @EnvironmentObject var model: AppModel
    let pack: CategoryPack

    var items: [ChecklistItem] {
        model.items(for: pack)
    }

    var body: some View {
        ZStack {
            BrandBackground()

            ScrollView {
                VStack(spacing: 16) {
                    PackHeroView(pack: pack, progress: model.progress(for: pack))

                    ForEach(items) { item in
                        ChecklistRow(item: item, accent: BrandTheme.accent)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(pack.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChecklistRow: View {
    @EnvironmentObject var model: AppModel
    let item: ChecklistItem
    let accent: Color

    @State private var showPaywall = false

    var body: some View {
        let isCompleted = model.isCompleted(item)

        Button {
            if item.isPremium && !model.premiumUnlocked {
                showPaywall = true
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    model.toggle(item)
                }
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [accent.opacity(0.9), BrandTheme.accentSoft],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: accent.opacity(0.3), radius: 6, y: 3)

                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: accent.opacity(0.45), radius: 4, y: 2)
                }
                .padding(.top, 2)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(BrandTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)

                        if item.isPremium {
                            ProBadge()
                        }
                    }

                    if let detail = item.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(BrandTheme.mutedText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack(spacing: 8) {
                        Text("\(item.xp) XP")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(BrandTheme.accent.opacity(0.12))
                            )
                            .foregroundColor(accent)

                        ForEach(item.dimensions) { dim in
                            HStack(spacing: 4) {
                                Image(systemName: dim.systemImage)
                                Text(dim.label)
                            }
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(
                                Capsule().fill(BrandTheme.waveDeep.opacity(0.18))
                            )
                            .foregroundColor(BrandTheme.textPrimary)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .brandCard(cornerRadius: 18)
        .alert("Life XP PRO", isPresented: $showPaywall) {
            Button("Later", role: .cancel) { }
        } message: {
            Text("Deze task hoort bij Life XP PRO.\n\nIn de echte app kun je PRO ontgrendelen via een eenmalige in-app aankoop. Voor nu kun je PRO testen via de dev toggle in Settings.")
        }
    }
}

private struct PackHeroView: View {
    let pack: CategoryPack
    let progress: Double

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [BrandTheme.accent, BrandTheme.accentSoft],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .fill(BrandTheme.waveSky.opacity(0.4))
                            .scaleEffect(0.9)
                            .offset(x: -10, y: -6)
                    )

                Image(systemName: pack.iconSystemName)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
            }
            .frame(width: 86, height: 86)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Text(pack.title)
                        .font(.title3.bold())
                        .foregroundColor(BrandTheme.textPrimary)

                    if pack.isPremium {
                        ProBadge()
                    }
                }

                Text(pack.subtitle)
                    .font(.subheadline)
                    .foregroundColor(BrandTheme.mutedText)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 6) {
                    ProgressView(value: progress)
                        .tint(BrandTheme.accent)

                    Text("\(Int(progress * 100))% completed")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }

            Spacer()
        }
        .brandCard()
    }
}

private struct ProBadge: View {
    var body: some View {
        Text("PRO")
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(BrandTheme.accent.opacity(0.16))
            )
            .overlay(
                Capsule().strokeBorder(BrandTheme.accent.opacity(0.8), lineWidth: 1)
            )
            .foregroundColor(BrandTheme.textPrimary)
    }
}

struct PacksView_Previews: PreviewProvider {
    static var previews: some View {
        PacksView()
            .environmentObject(AppModel())
    }
}
