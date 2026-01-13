import SwiftUI
import UIKit
import UniformTypeIdentifiers

// MARK: - Stats View

struct StatsView: View {
    @Environment(AppModel.self) private var model
    @State private var selectedTimeframe: Timeframe = .allTime
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case allTime = "All Time"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()

                ScrollView {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        // Level Hero Card
                        LevelHeroCard()
                        
                        // Progress Snapshot
                        ProgressSnapshotCard2()
                        
                        // Arc Focus
                        if let arc = model.highlightedArc {
                            ArcFocusCard(arc: arc)
                        }
                        
                        // Overall Progress
                        OverallProgressCard()
                        
                        // Insights Card
                        InsightsCard2()
                        
                        // Dimension Stats
                        DimensionStatsCard()
                        
                        // Arc Progress
                        ArcProgressCard()
                        
                        // Badges Preview
                        if !model.unlockedBadges.isEmpty {
                            BadgesPreviewCard()
                        }
                        
                        // Share Card
                        ShareEntryCard2()
                        
                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
                .trackScrollActivity()
            }
            .navigationTitle("Stats")
        }
    }
}

// MARK: - Level Hero Card

struct LevelHeroCard: View {
    @Environment(AppModel.self) private var model
    @State private var animatePulse = false
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.xl) {
            // Level badge
            ZStack {
                // Glow
                Circle()
                    .fill(BrandTheme.accent.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animatePulse ? 1.1 : 1)
                
                // Ring
                Circle()
                    .stroke(BrandTheme.accent.opacity(0.3), lineWidth: 4)
                    .frame(width: 100, height: 100)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: model.levelProgress)
                    .stroke(BrandTheme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                // Level number
                VStack(spacing: 0) {
                    Text("LEVEL")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Text("\(model.level)")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(BrandTheme.textPrimary)
                }
            }
            
            // Stats
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total XP")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Text("\(model.totalXP)")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                }
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack {
                        Text("\(Int(model.levelProgress * 100))%")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.accent)
                        
                        Text("to Level \(model.level + 1)")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                    
                    AnimatedProgressBar(progress: model.levelProgress, height: 8, color: BrandTheme.accent)
                    
                    Text("\(model.xpToNextLevel) XP remaining")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            Spacer()
        }
        .elevatedCard(accentColor: BrandTheme.accent)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animatePulse = true
            }
        }
    }
}

// MARK: - Progress Snapshot Card 2.0

struct ProgressSnapshotCard2: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Momentum Snapshot")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                if model.dimensionBalanceScore > 0 {
                    ChipView(text: "Balance \(model.dimensionBalanceScore)%", icon: "circle.grid.cross", color: balanceColor, size: .small)
                }
            }
            
            HStack(spacing: DesignSystem.spacing.md) {
                SnapshotTile2(
                    icon: "checkmark.circle.fill",
                    value: "\(model.completedCount)",
                    label: "Completed",
                    color: BrandTheme.success
                )
                
                SnapshotTile2(
                    icon: "target",
                    value: "\(model.remainingCount)",
                    label: "Remaining",
                    color: BrandTheme.warning
                )
                
                if model.showStreaks {
                    SnapshotTile2(
                        icon: "flame.fill",
                        value: "\(model.currentStreak)d",
                        label: "Streak",
                        color: BrandTheme.error
                    )
                }
            }
        }
        .brandCard()
    }
    
    private var balanceColor: Color {
        if model.dimensionBalanceScore >= 70 {
            return BrandTheme.success
        } else if model.dimensionBalanceScore >= 40 {
            return BrandTheme.warning
        } else {
            return BrandTheme.error
        }
    }
}

struct SnapshotTile2: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Arc Focus Card

struct ArcFocusCard: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    
    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Arc Focus")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                if let day = model.arcDay(for: arc) {
                    ChipView(text: "Day \(day)", icon: "calendar", color: BrandTheme.mutedText, size: .small)
                }
            }
            
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: arc.iconSystemName, color: accent, size: .medium, style: .soft)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    Text(arc.title)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(arc.subtitle)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(1)
                    
                    HStack(spacing: DesignSystem.spacing.sm) {
                        AnimatedProgressBar(progress: progress, height: 6, color: accent)
                            .frame(maxWidth: 120)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(accent)
                    }
                }
                
                Spacer()
            }
            
            // Next quests
            let nextQuests = model.nextQuestBoard(limit: 2).quests
            if !nextQuests.isEmpty {
                Divider().background(BrandTheme.divider)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Next quests")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    ForEach(nextQuests) { quest in
                        HStack(spacing: DesignSystem.spacing.sm) {
                            Image(systemName: quest.kind.systemImage)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(accent)
                            
                            Text(quest.title)
                                .font(DesignSystem.text.labelSmall)
                                .foregroundColor(BrandTheme.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(quest.xp) XP")
                                .font(.caption2)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Overall Progress Card

struct OverallProgressCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Overall Progress")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            HStack(spacing: DesignSystem.spacing.xl) {
                AnimatedProgressRing(
                    progress: model.globalProgress,
                    lineWidth: 14,
                    showPercentage: true
                )
                .frame(width: 140, height: 140)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Life Score")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.mutedText)
                        
                        Text("\(Int(model.globalProgress * 100))%")
                            .font(DesignSystem.text.displaySmall)
                            .foregroundColor(BrandTheme.textPrimary)
                    }
                    
                    if model.showStreaks && model.currentStreak > 0 {
                        HStack(spacing: DesignSystem.spacing.xs) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(BrandTheme.error)
                            Text("\(model.currentStreak) day streak")
                                .font(DesignSystem.text.labelSmall)
                                .foregroundColor(BrandTheme.textPrimary)
                        }
                    }
                    
                    if model.showStreaks && model.bestStreak > 0 {
                        Text("Best: \(model.bestStreak) days")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
                
                Spacer()
            }
        }
        .brandCard()
    }
}

// MARK: - Insights Card 2.0

struct InsightsCard2: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Insights")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
            }
            
            // Focus headline
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: "lightbulb.fill", color: BrandTheme.warning, size: .small, style: .soft)
                
                Text(model.focusHeadline)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.textSecondary)
            }
            
            // Daily ritual
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: "sparkles", color: BrandTheme.accent, size: .small, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ritual of the Day")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                    Text(model.ritualOfTheDay)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                }
            }
            
            // Hero quests
            if !model.heroQuests.isEmpty {
                Divider().background(BrandTheme.divider)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    HStack {
                        Text("High Impact")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("Top XP quests")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                    
                    ForEach(model.heroQuests.prefix(3)) { quest in
                        HStack(spacing: DesignSystem.spacing.md) {
                            Image(systemName: "bolt.circle.fill")
                                .foregroundColor(BrandTheme.warning)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(quest.title)
                                    .font(DesignSystem.text.labelSmall)
                                    .foregroundColor(BrandTheme.textPrimary)
                                    .lineLimit(1)
                                
                                if let detail = quest.detail {
                                    Text(detail)
                                        .font(.caption2)
                                        .foregroundColor(BrandTheme.mutedText)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                            
                            XPChip(xp: quest.xp, size: .small)
                        }
                    }
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Dimension Stats Card

struct DimensionStatsCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Dimensions")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            ForEach(LifeDimension.allCases) { dim in
                DimensionStatRow(dimension: dim)
            }
        }
        .brandCard()
    }
}

struct DimensionStatRow: View {
    @Environment(AppModel.self) private var model
    let dimension: LifeDimension
    
    private var earned: Int { model.xp(for: dimension) }
    private var total: Int { model.maxXP(for: dimension) }
    private var ratio: Double {
        guard total > 0 else { return 0 }
        return Double(earned) / Double(total)
    }
    private var color: Color { BrandTheme.dimensionColor(dimension) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            HStack {
                Label {
                    Text(dimension.label)
                        .font(DesignSystem.text.labelMedium)
                } icon: {
                    Image(systemName: dimension.systemImage)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(color)
                
                Spacer()
                
                Text("\(earned) / \(total) XP")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            AnimatedProgressBar(progress: ratio, height: 10, cornerRadius: 5, color: color)
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.08))
        )
    }
}

// MARK: - Arc Progress Card

struct ArcProgressCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Arcs")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("\(model.completedArcs.count) completed")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            ForEach(model.visibleArcs) { arc in
                ArcProgressRow2(arc: arc)
            }
        }
        .brandCard()
    }
}

struct ArcProgressRow2: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    
    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var completedQuests: Int {
        arc.chapters.flatMap { $0.quests }.filter { model.isCompleted($0) }.count
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: arc.iconSystemName, color: accent, size: .small, style: progress >= 1 ? .gradient : .soft)
            
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                HStack {
                    Text(arc.title)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if progress >= 1 {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(BrandTheme.success)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(accent)
                }
                
                AnimatedProgressBar(progress: progress, height: 6, color: accent)
                
                Text("\(completedQuests)/\(arc.questCount) quests")
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .padding(DesignSystem.spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Badges Preview Card

struct BadgesPreviewCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Badges")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: BadgesView()) {
                    Text("View all")
                        .font(.caption.weight(.medium))
                        .foregroundColor(BrandTheme.accent)
                }
            }
            
            ForEach(model.unlockedBadges.prefix(3)) { badge in
                BadgeRow2(badge: badge, unlocked: true)
            }
        }
        .brandCard()
    }
}

struct BadgeRow2: View {
    let badge: Badge
    var unlocked: Bool = true
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(
                systemName: badge.iconSystemName,
                color: unlocked ? BrandTheme.accent : BrandTheme.mutedText,
                size: .medium,
                style: unlocked ? .soft : .outlined
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(badge.name)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(badge.description)
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(BrandTheme.success)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .padding(DesignSystem.spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                .fill(unlocked ? BrandTheme.success.opacity(0.08) : BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Share Entry Card 2.0

struct ShareEntryCard2: View {
    @Environment(AppModel.self) private var model
    @State private var shareCard: ShareCardImage?
    @State private var isRendering = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: "square.and.arrow.up", color: BrandTheme.accent, size: .medium, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Share Your Progress")
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Generate a beautiful card to share your stats")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
            }
            
            if let card = shareCard {
                ShareLink(item: card, preview: SharePreview("Life XP Card", image: card.preview)) {
                    HStack {
                        Spacer()
                        Label("Share Now", systemImage: "arrow.up.right.square")
                            .font(DesignSystem.text.labelMedium)
                        Spacer()
                    }
                }
                .buttonStyle(GlowButtonStyle(size: .medium))
            } else {
                Button(action: prepareShareCard) {
                    HStack {
                        Spacer()
                        Label(isRendering ? "Preparing..." : "Generate Card", systemImage: "wand.and.rays")
                            .font(DesignSystem.text.labelMedium)
                        Spacer()
                    }
                }
                .buttonStyle(SoftButtonStyle())
                .disabled(isRendering)
            }
            
            NavigationLink(destination: SharePreviewView()) {
                Text("Preview card first")
                    .font(.caption)
                    .foregroundColor(BrandTheme.accent)
            }
            
            if isRendering {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Rendering...")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
        }
        .brandCard()
        .task { await ensureShareCardPrepared() }
    }

    private func prepareShareCard() {
        guard !isRendering else { return }
        isRendering = true

        Task {
            let rendered = await MainActor.run { renderShareCard(for: model) }
            await MainActor.run {
                shareCard = rendered
                isRendering = false
            }
        }
    }

    private func ensureShareCardPrepared() async {
        guard shareCard == nil else { return }
        await MainActor.run { isRendering = true }
        let rendered = await MainActor.run { renderShareCard(for: model) }
        await MainActor.run {
            shareCard = rendered
            isRendering = false
        }
    }
}

// MARK: - Share Views

struct ShareCardImage: Transferable {
    let image: UIImage

    var preview: Image { Image(uiImage: image) }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.image.pngData() ?? Data()
        }
    }
}

struct SharePreviewView: View {
    @Environment(AppModel.self) private var model
    @State private var shareCard: ShareCardImage?
    @State private var isRendering = false

    var body: some View {
        ZStack {
            BrandBackground(animated: false)

            VStack(spacing: DesignSystem.spacing.lg) {
                ShareCardView()
                    .frame(maxWidth: 360)

                if let card = shareCard {
                    ShareLink(item: card, preview: SharePreview("Life XP Card", image: card.preview)) {
                        Text("Share Card")
                    }
                    .buttonStyle(GlowButtonStyle(size: .large))
                } else {
                    Button(action: prepareShareCard) {
                        Text(isRendering ? "Loading..." : "Generate")
                    }
                    .buttonStyle(SoftButtonStyle())
                    .disabled(isRendering)
                }

                Text("Share your Life XP card as an image")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            .padding()
        }
        .navigationTitle("Share Card")
        .navigationBarTitleDisplayMode(.inline)
        .task { await ensureShareCardPrepared() }
    }

    private func prepareShareCard() {
        guard !isRendering else { return }
        isRendering = true

        Task {
            let rendered = await MainActor.run { renderShareCard(for: model) }
            await MainActor.run {
                shareCard = rendered
                isRendering = false
            }
        }
    }

    private func ensureShareCardPrepared() async {
        guard shareCard == nil else { return }
        await MainActor.run { isRendering = true }
        let rendered = await MainActor.run { renderShareCard(for: model) }
        await MainActor.run {
            shareCard = rendered
            isRendering = false
        }
    }
}

struct ShareCardView: View {
    @Environment(AppModel.self) private var model

    private func ratio(for dimension: LifeDimension) -> Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [BrandTheme.waveSky, BrandTheme.waveMist, BrandTheme.waveDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative orbs
                Circle()
                    .fill(BrandTheme.accent.opacity(0.2))
                    .blur(radius: 60)
                    .scaleEffect(1.3)
                    .offset(x: -80, y: -120)

                Circle()
                    .fill(BrandTheme.accentSoft.opacity(0.15))
                    .blur(radius: 60)
                    .scaleEffect(1.2)
                    .offset(x: 100, y: 150)

                // Border
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(BrandTheme.accent.opacity(0.2), lineWidth: 1)
                    .padding(8)

                // Content
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Logo
                    VStack(spacing: DesignSystem.spacing.sm) {
                        ZStack {
                            Circle()
                                .fill(BrandTheme.accent.opacity(0.2))
                                .frame(width: 72, height: 72)
                            
                            Circle()
                                .fill(BrandTheme.accent)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text("Life XP")
                            .font(.headline)
                            .foregroundColor(BrandTheme.accent)
                    }

                    // Progress ring
                    AnimatedProgressRing(
                        progress: model.globalProgress,
                        lineWidth: 12,
                        showPercentage: true
                    )
                    .frame(width: 130, height: 130)

                    // Stats
                    VStack(spacing: DesignSystem.spacing.xs) {
                        Text("\(model.totalXP) XP")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)

                        if model.showStreaks && model.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(BrandTheme.error)
                                Text("\(model.currentStreak) day streak")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(BrandTheme.textSecondary)
                        }
                    }

                    // Arc progress
                    if model.showArcProgressOnShare, let arc = model.highlightedArc {
                        VStack(spacing: 2) {
                            Text("\(arc.title) • \(Int(model.arcProgress(arc) * 100))%")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }

                    // Dimension bars
                    VStack(spacing: DesignSystem.spacing.sm) {
                        ForEach(LifeDimension.allCases) { dim in
                            HStack(spacing: DesignSystem.spacing.sm) {
                                Image(systemName: dim.systemImage)
                                    .font(.system(size: 12))
                                    .foregroundColor(BrandTheme.dimensionColor(dim))
                                    .frame(width: 16)
                                
                                Text(dim.label)
                                    .font(.caption2)
                                    .foregroundColor(BrandTheme.textSecondary)
                                    .frame(width: 60, alignment: .leading)

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(BrandTheme.borderSubtle.opacity(0.3))
                                        Capsule()
                                            .fill(BrandTheme.dimensionColor(dim))
                                            .frame(width: max(4, geo.size.width * ratio(for: dim)))
                                    }
                                }
                                .frame(height: 6)

                                Text("\(model.xp(for: dim))")
                                    .font(.caption2)
                                    .foregroundColor(BrandTheme.mutedText)
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)

                    // Footer
                    VStack(spacing: 2) {
                        Text("Soft steps, bold wins")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                        Text("Life XP App")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(BrandTheme.accent)
                    }
                }
                .padding(DesignSystem.spacing.xl)
            }
        }
        .aspectRatio(9/16, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
    }
}

@MainActor
private func renderShareCard(for model: AppModel, size: CGSize = CGSize(width: 360, height: 640)) -> ShareCardImage? {
    let card = ShareCardView()
        .environment(model)
        .frame(width: size.width, height: size.height)

    let renderer = ImageRenderer(content: card)
    renderer.scale = UIScreen.main.scale

    guard let uiImage = renderer.uiImage else { return nil }
    return ShareCardImage(image: uiImage)
}

// MARK: - Legacy Support

struct StatsDimensionCard: View {
    @Environment(AppModel.self) private var model
    let dimension: LifeDimension
    
    var body: some View {
        DimensionStatRow(dimension: dimension)
            .environment(model)
    }
}

struct InsightsCard: View {
    let balanceScore: Int
    let focusHeadline: String
    let ritual: String
    let heroQuests: [ChecklistItem]
    
    var body: some View {
        EmptyView() // Replaced by InsightsCard2
    }
}

struct LevelSummaryCard: View {
    let level: Int
    let progress: Double
    let xpToNext: Int
    let nextUnlock: String
    
    var body: some View {
        EmptyView() // Replaced by LevelHeroCard
    }
}

struct ArcProgressRow: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    
    var body: some View {
        ArcProgressRow2(arc: arc)
            .environment(model)
    }
}

struct ProgressSnapshotCard: View {
    let completed: Int
    let remaining: Int
    let balanceScore: Int
    let streak: Int
    
    var body: some View {
        EmptyView() // Replaced by ProgressSnapshotCard2
    }
}

struct ArcSnapshotCard: View {
    let arc: Arc
    let progress: Double
    let day: Int?
    let nextQuests: [Quest]
    
    var body: some View {
        EmptyView() // Replaced by ArcFocusCard
    }
}

struct ShareEntryCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        ShareEntryCard2()
            .environment(model)
    }
}
