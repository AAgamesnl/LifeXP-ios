import SwiftUI

struct StatsView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                ScrollView {
                    VStack(spacing: 24) {
                    LevelSummaryCard(
                        level: model.level,
                        progress: model.levelProgress,
                        xpToNext: model.xpToNextLevel,
                        nextUnlock: model.nextUnlockMessage
                    )

                    ProgressSnapshotCard(
                        completed: model.completedCount,
                        remaining: model.remainingCount,
                        balanceScore: model.dimensionBalanceScore,
                        streak: model.showStreaks ? model.currentStreak : 0
                    )

                    if let arc = model.highlightedArc {
                        ArcSnapshotCard(
                            arc: arc,
                            progress: model.arcProgress(arc),
                            day: model.arcDay(for: arc),
                            nextQuests: model.nextQuestBoard(limit: model.questBoardLimit).quests
                        )
                    }

                    // Overall card
                    VStack(spacing: 8) {
                        Text("Overall")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .center, spacing: 20) {
                            ProgressRing(progress: model.globalProgress)
                                .frame(width: 120, height: 120)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Life Score")
                                    .font(.headline)
                                Text("\(Int(model.globalProgress * 100))% completed")
                                    .font(.title2.bold())
                                Text("\(model.totalXP) XP total")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if model.showStreaks && model.currentStreak > 0 {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                        Text("Current streak: \(model.currentStreak) days")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                }

                                if model.showStreaks && model.bestStreak > 0 {
                                    Text("Best streak: \(model.bestStreak) days")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Overall progress")
                        .accessibilityValue("\(Int(model.globalProgress * 100)) percent complete, total \(model.totalXP) XP")
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 10, y: 5)

                    InsightsCard(
                        balanceScore: model.dimensionBalanceScore,
                        focusHeadline: model.focusHeadline,
                        ritual: model.ritualOfTheDay,
                        heroQuests: model.heroQuests
                    )

                    // Dimensions
                    VStack(spacing: 16) {
                        HStack {
                            Text("Dimensions")
                                .font(.headline)
                            Spacer()
                        }

                        ForEach(LifeDimension.allCases) { dim in
                            StatsDimensionCard(dimension: dim)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    VStack(spacing: 12) {
                        HStack {
                            Text("Arcs")
                                .font(.headline)
                            Spacer()
                            Text("\(model.completedArcs.count) completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        ForEach(model.visibleArcs) { arc in
                            ArcProgressRow(arc: arc)
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 6, y: 3)

                    // Badges quick view
                    if !model.unlockedBadges.isEmpty {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Badges")
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: BadgesView()) {
                                    Text("View all")
                                        .font(.caption)
                                }
                            }
                            
                            ForEach(model.unlockedBadges.prefix(3)) { badge in
                                BadgeRow(badge: badge)
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(radius: 6, y: 3)
                    }

                        ShareEntryCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Stats")
        }
    }
}

struct StatsDimensionCard: View {
    @EnvironmentObject var model: AppModel
    let dimension: LifeDimension
    
    private var ratio: Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: dimension.systemImage)
                Text(dimension.label)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(model.xp(for: dimension)) / \(model.maxXP(for: dimension)) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.accentColor.opacity(0.9),
                                Color.accentColor.opacity(0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: max(10, geo.size.width * CGFloat(min(1, max(0, ratio)))))
                }
            }
            .frame(height: 12)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

struct InsightsCard: View {
    let balanceScore: Int
    let focusHeadline: String
    let ritual: String
    let heroQuests: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Insights")
                    .font(.headline)
                Spacer()
                if balanceScore > 0 {
                    Text("Balance \(balanceScore)%")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.accentColor.opacity(0.12)))
                }
            }

            Text(focusHeadline)
                .font(.subheadline)
            Text(ritual)
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("High impact")
                        .font(.caption.weight(.semibold))
                    Spacer()
                    Text("Top XP quests")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                if heroQuests.isEmpty {
                    Text("Claim eerst wat basis XP, dan droppen we je boss fights.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(heroQuests) { quest in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "bolt.circle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(quest.title)
                                    .font(.subheadline.weight(.semibold))
                                if let detail = quest.detail {
                                    Text(detail)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                            Text("\(quest.xp) XP")
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color(.systemGray6)))
                        }
                    }
                }
            }
        }
        .brandCard(cornerRadius: 20)
    }
}

struct LevelSummaryCard: View {
    let level: Int
    let progress: Double
    let xpToNext: Int
    let nextUnlock: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(level)")
                        .font(.title3.bold())
                    Text("Nog \(xpToNext) XP tot level \(level + 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                ProgressRing(progress: progress)
                    .frame(width: 90, height: 90)
            }

            Text(nextUnlock)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
}

struct ArcProgressRow: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc

    var body: some View {
        let accent = Color(hex: arc.accentColorHex, default: .accentColor)
        let progress = model.arcProgress(arc)
        let totalQuests = arc.questCount
        let completed = arc.chapters.flatMap { $0.quests }.filter { model.isCompleted($0) }.count

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: arc.iconSystemName)
                    .foregroundColor(accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(arc.title)
                        .font(.subheadline.weight(.semibold))
                    Text(arc.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(progress * 100))%")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(accent.opacity(0.18)))
                    Text("\(completed)/\(totalQuests) quests")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accent)
                        .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, progress)))))
                }
            }
            .frame(height: 10)
        }
        .padding(.vertical, 4)
    }
}

struct ProgressSnapshotCard: View {
    let completed: Int
    let remaining: Int
    let balanceScore: Int
    let streak: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Momentum snapshot")
                    .font(.headline)
                Spacer()
                if balanceScore > 0 {
                    Label("Balance \(balanceScore)%", systemImage: "circle.grid.cross")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.accentColor.opacity(0.12)))
                }
            }

            HStack(spacing: 14) {
                SnapshotTile(title: "Completed", value: "\(completed)", subtitle: "quests done", icon: "checkmark.circle.fill", tint: .green)
                SnapshotTile(title: "Remaining", value: "\(remaining)", subtitle: "nog te gaan", icon: "target", tint: .orange)
                SnapshotTile(title: "Streak", value: "\(streak)d", subtitle: "lopende reeks", icon: "flame.fill", tint: .red)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct ArcSnapshotCard: View {
    let arc: Arc
    let progress: Double
    let day: Int?
    let nextQuests: [Quest]

    var body: some View {
        let accent = Color(hex: arc.accentColorHex, default: .accentColor)

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Arc focus")
                    .font(.headline)
                Spacer()
                if let day = day {
                    Text("Dag \(day)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 12) {
                Image(systemName: arc.iconSystemName)
                    .foregroundColor(accent)
                    .padding(10)
                    .background(Circle().fill(accent.opacity(0.12)))

                VStack(alignment: .leading, spacing: 4) {
                    Text(arc.title)
                        .font(.subheadline.weight(.semibold))
                    Text(arc.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ProgressView(value: progress) {
                        Text("\(Int(progress * 100))% • \(arc.questCount) quests")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .tint(accent)
                }
            }

            if !nextQuests.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Volgende quests")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    ForEach(nextQuests) { quest in
                        HStack(spacing: 8) {
                            Image(systemName: quest.kind.systemImage)
                                .foregroundColor(accent)
                            Text(quest.title)
                                .font(.subheadline)
                                .lineLimit(1)
                            Spacer()
                            Text("\(quest.xp) XP")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 3)
    }
}

private struct SnapshotTile: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundColor(tint)

            Text(value)
                .font(.title3.bold())

            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
    }
}

// MARK: - Share Views

struct SharePreviewView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        ZStack {
            BrandBackground()

            VStack(spacing: 20) {
                Text("Screenshot deze kaart en deel ’m in je story ✨")
                    .font(.footnote)
                    .foregroundColor(BrandTheme.mutedText)

                ShareCardView()
                    .frame(maxWidth: 360)

                Text("Tip: zet je camera op full-screen, maak een screenshot en tag je app-naam.")
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
                    .multilineTextAlignment(.center)

                ShareLink(item: "Mijn Life XP progress: \(Int(model.globalProgress * 100))% compleet!") {
                    HStack {
                        Spacer()
                        Label("Deel deze kaart", systemImage: "arrow.up.right.square")
                            .font(.callout.bold())
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.12)))
                }
            }
            .padding()
        }
        .navigationTitle("Share card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShareEntryCard: View {
    @EnvironmentObject var model: AppModel

    private var shareText: String {
        let arcLine: String
        if model.showArcProgressOnShare, let arc = model.highlightedArc {
            let progress = Int(model.arcProgress(arc) * 100)
            arcLine = " Arc ‘\(arc.title)’ staat op \(progress)% en levert \(arc.totalXP) XP."
        } else {
            arcLine = ""
        }

        let streakLine = (model.showStreaks && model.currentStreak > 0) ? " Streak: \(model.currentStreak)d." : ""
        return "Ik heb \(Int(model.globalProgress * 100))% van mijn Life XP checklist unlocked en \(model.totalXP) XP verzameld." + arcLine + streakLine + " Pak jouw kaart in de app!"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(BrandTheme.accent.opacity(0.14))
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(BrandTheme.accent)
                }
                .frame(width: 54, height: 54)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Deel je progress")
                        .font(.subheadline.weight(.semibold))
                    Text("Story-ready kaart met jouw streak, XP en stats.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            ShareLink(item: shareText) {
                HStack {
                    Spacer()
                    Label("Deel nu", systemImage: "arrow.up.right.square")
                        .font(.footnote.bold())
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(BrandTheme.accent.opacity(0.12)))
            }

            NavigationLink(destination: SharePreviewView()) {
                Text("Bekijk de kaart eerst")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 6, y: 3)
    }
}

struct ShareCardView: View {
    @EnvironmentObject var model: AppModel

    private func ratio(for dimension: LifeDimension) -> Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(BrandTheme.accent.opacity(0.2))
                    .blur(radius: 80)
                    .scaleEffect(1.4)
                    .offset(x: -100, y: -160)

                Circle()
                    .fill(BrandTheme.accentSoft.opacity(0.18))
                    .blur(radius: 80)
                    .scaleEffect(1.3)
                    .offset(x: 120, y: 180)

                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(BrandTheme.accent.opacity(0.18), lineWidth: 1)
                    .padding(10)

                VStack(spacing: 18) {
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(BrandTheme.accent.opacity(0.22))
                                .frame(width: 86, height: 86)
                            Circle()
                                .fill(BrandTheme.accent)
                                .frame(width: 64, height: 64)
                            Image(systemName: "checkmark")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(.white)
                        }

                        Text("My Life Checklist")
                            .font(.headline)
                            .foregroundColor(BrandTheme.accent)
                        Text("Soft waves, steady wins")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }

                    ProgressRing(progress: model.globalProgress)
                        .frame(width: 150, height: 150)
                        .padding(.top, 4)

                    Text("\(model.totalXP) XP collected")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(BrandTheme.accent)

                    if model.showStreaks && model.currentStreak > 0 {
                        Text("Streak: \(model.currentStreak) days")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(BrandTheme.accent.opacity(0.12)))
                            .foregroundColor(BrandTheme.accent)
                    }

                    if model.showArcProgressOnShare, let arc = model.highlightedArc {
                        VStack(spacing: 4) {
                            Text("Arc: \(arc.title) • \(Int(model.arcProgress(arc) * 100))%")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                            Text("\(arc.questCount) quests • \(arc.totalXP) XP")
                                .font(.caption2)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }

                    VStack(spacing: 12) {
                        ForEach(LifeDimension.allCases) { dim in
                            HStack(spacing: 10) {
                                Image(systemName: dim.systemImage)
                                    .foregroundColor(BrandTheme.accent)
                                Text(dim.label)
                                    .font(.footnote.weight(.medium))
                                    .foregroundColor(.primary)

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(BrandTheme.waveDeep.opacity(0.35))
                                        Capsule()
                                            .fill(BrandTheme.accent)
                                            .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, ratio(for: dim))))))
                                    }
                                }
                                .frame(height: 8)

                                Text("\(model.xp(for: dim))")
                                    .font(.caption2)
                                    .foregroundColor(BrandTheme.mutedText)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    VStack(spacing: 4) {
                        Text("Soft steps, bold wins")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)

                        Text("Search: Life XP")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(BrandTheme.accent)
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
            }
        }
        .aspectRatio(9/16, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(radius: 24, y: 10)
    }
}
