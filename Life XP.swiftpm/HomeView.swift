import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var model: AppModel
    @State private var showHeroCard = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showQuickAdd = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Scroll content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: model.compactHomeLayout ? DesignSystem.spacing.lg : DesignSystem.spacing.xl) {
                        // Hero Section with Time-of-Day Greeting
                        HeroSection()
                            .opacity(showHeroCard ? 1 : 0)
                            .offset(y: showHeroCard ? 0 : 20)
                        
                        // Daily Briefing
                        DailyBriefingCard2()
                        
                        // Life Checklist Entry
                        if let lifeChecklist = model.packs.first(where: { $0.id == "life_checklist_classic" }) {
                            NavigationLink(destination: PackDetailView(pack: lifeChecklist)) {
                                LifeChecklistCard2(
                                    pack: lifeChecklist,
                                    progress: model.progress(for: lifeChecklist)
                                )
                            }
                            .buttonStyle(CardButtonStyle())
                        }
                        
                        // Level Progress
                        LevelProgressCard()
                        
                        // Dimension Balance
                        DimensionBalanceCard()
                        
                        // Momentum Section
                        if model.showMomentumGrid {
                            MomentumSection()
                        }
                        
                        // Micro Wins
                        if !model.microWins.isEmpty {
                            MicroWinsSection()
                        }
                        
                        // Arc Preview
                        if let arcPreview = model.highlightedArc, model.showHeroCards {
                            ArcPreviewCard(arc: arcPreview)
                        }
                        
                        // Booster Packs
                        if !model.boosterPacks.isEmpty {
                            BoosterPacksSection()
                        }
                        
                        // Quick Actions
                        if model.showQuickActions {
                            QuickActionsSection()
                        }
                        
                        // Optional Cards
                        OptionalCardsSection()
                        
                        // Bottom padding
                        Color.clear.frame(height: 20)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.top, DesignSystem.spacing.md)
                }
            }
            .navigationTitle("Life XP")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    QuickHelpButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BadgesView()) {
                        BadgeCountButton(count: model.unlockedBadges.count)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showHeroCard = true
                }
            }
        }
    }
}

// MARK: - Card Button Style

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.95 : 1)
            // Faster, more responsive animation
            .animation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 0.05), value: configuration.isPressed)
    }
}

// MARK: - Badge Count Button

struct BadgeCountButton: View {
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "rosette")
                .font(.system(size: 16, weight: .semibold))
            if count > 0 {
                Text("\(count)")
                    .font(.caption.weight(.bold))
            }
        }
        .foregroundColor(BrandTheme.accent)
        .padding(.horizontal, DesignSystem.spacing.sm)
        .padding(.vertical, DesignSystem.spacing.xs)
        .background(
            Capsule()
                .fill(BrandTheme.accent.opacity(0.12))
        )
    }
}

// MARK: - Hero Section

struct HeroSection: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            // Header with streak
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Life Checklist")
                        .font(DesignSystem.text.headlineLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(greeting)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                if model.showStreaks && model.currentStreak > 0 {
                    StreakBadge(days: model.currentStreak, bestStreak: model.bestStreak)
                }
            }
            
            // Progress Overview
            HStack(spacing: DesignSystem.spacing.xl) {
                // Ring
                AnimatedProgressRing(
                    progress: model.globalProgress,
                    lineWidth: 14,
                    showPercentage: true
                )
                .frame(width: 120, height: 120)
                
                // Stats
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    StatRow(
                        icon: "star.fill",
                        label: "Total XP",
                        value: "\(model.totalXP)",
                        color: BrandTheme.warning
                    )
                    
                    StatRow(
                        icon: "checkmark.circle.fill",
                        label: "Completed",
                        value: "\(model.completedCount)",
                        color: BrandTheme.success
                    )
                    
                    StatRow(
                        icon: "target",
                        label: "Remaining",
                        value: "\(model.remainingCount)",
                        color: BrandTheme.info
                    )
                }
                
                Spacer()
            }
            
            // Coach message
            Text(model.coachMessage)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(BrandTheme.accentMuted.opacity(0.5))
                )
        }
        .brandCard()
    }
    
    private var greeting: String {
        let timeOfDay = TimeOfDay.current
        return "\(timeOfDay.greeting) \(timeOfDay.suggestion)"
    }
}

// MARK: - Streak Badge

struct StreakBadge: View {
    let days: Int
    let bestStreak: Int
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: 2) {
            if reduceMotion {
                // Static version for reduced motion
                StaticStreakContent(days: days)
            } else {
                // Animated version using TimelineView for smooth performance
                TimelineView(.animation(minimumInterval: 1.0/120, paused: false)) { timeline in
                    let scale = computeGlowScale(for: timeline.date)
                    
                    ZStack {
                        // Glow - animated smoothly
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [BrandTheme.warning.opacity(0.35), .clear],
                                    center: .center,
                                    startRadius: 12,
                                    endRadius: 38
                                )
                            )
                            .frame(width: 75, height: 75)
                            .scaleEffect(scale)
                        
                        // Badge - static
                        VStack(spacing: 0) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(days)")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [BrandTheme.warning, BrandTheme.error],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: BrandTheme.warning.opacity(0.4), radius: 6, y: 3)
                    }
                }
            }
            
            Text("day streak")
                .font(.caption2.weight(.medium))
                .foregroundColor(BrandTheme.mutedText)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(days) day streak")
    }
    
    private func computeGlowScale(for date: Date) -> CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = sin(seconds * 1.5) // Gentle 1.5 second cycle
        return 1.0 + CGFloat(cycle) * 0.08 // 8% scale variation
    }
}

private struct StaticStreakContent: View {
    let days: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [BrandTheme.warning.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 12,
                        endRadius: 35
                    )
                )
                .frame(width: 70, height: 70)
            
            VStack(spacing: 0) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("\(days)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(width: 52, height: 52)
            .background(
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [BrandTheme.warning, BrandTheme.error],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: BrandTheme.warning.opacity(0.4), radius: 6, y: 3)
        }
    }
}

// MARK: - Stat Row

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    var color: Color = BrandTheme.accent
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
    }
}

// MARK: - Daily Briefing Card 2.0

struct DailyBriefingCard2: View {
    @EnvironmentObject var model: AppModel
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            // Header
            HStack {
                IconContainer(systemName: "sun.max.fill", color: BrandTheme.warning, size: .small, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Briefing")
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                Button {
                    // Smooth, responsive expand/collapse
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.1)) {
                        isExpanded.toggle()
                    }
                    HapticsEngine.lightImpact()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(BrandTheme.mutedText)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(BrandTheme.borderSubtle.opacity(0.5)))
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
                .buttonStyle(.plain)
            }
            
            // Affirmation
            Text(model.dailyAffirmation)
                .font(DesignSystem.text.bodyMedium)
                .foregroundColor(BrandTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            if isExpanded {
                Divider()
                    .background(BrandTheme.divider)
                
                // Focus area
                if let weakest = model.lowestDimension {
                    HStack(spacing: DesignSystem.spacing.md) {
                        Image(systemName: weakest.systemImage)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(BrandTheme.dimensionColor(weakest))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Focus: \(weakest.label)")
                                .font(DesignSystem.text.labelMedium)
                                .foregroundColor(BrandTheme.textPrimary)
                            Text(model.focusHeadline)
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                        
                        Spacer()
                    }
                    .padding(DesignSystem.spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                            .fill(BrandTheme.dimensionColor(weakest).opacity(0.1))
                    )
                }
                
                // Daily ritual
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(BrandTheme.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ritual van vandaag")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                        Text(model.ritualOfTheDay)
                            .font(.caption)
                            .foregroundColor(BrandTheme.textSecondary)
                    }
                    
                    Spacer()
                }
                
                // Next unlock
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "lock.open.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(BrandTheme.success)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Volgende unlock")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                        Text(model.nextUnlockMessage)
                            .font(.caption)
                            .foregroundColor(BrandTheme.textSecondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .brandCard()
        .onAppear {
            isExpanded = model.expandHomeCardsByDefault
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter.string(from: Date())
    }
}

// MARK: - Life Checklist Card 2.0

struct LifeChecklistCard2: View {
    let pack: CategoryPack
    let progress: Double
    
    var body: some View {
        let accent = Color(hex: pack.accentColorHex, default: BrandTheme.accent)
        
        HStack(spacing: DesignSystem.spacing.lg) {
            // Icon
            IconContainer(systemName: pack.iconSystemName, color: accent, size: .large, style: .gradient)
            
            // Content
            VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                HStack {
                    Text("Life Checklist")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    ChipView(text: "Hero", icon: "crown.fill", color: accent, size: .small)
                }
                
                Text(pack.subtitle)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(2)
                
                // Progress
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    AnimatedProgressBar(progress: progress, height: 8, color: accent, showGlow: true)
                    
                    HStack {
                        Text("\(Int(progress * 100))% complete")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
            }
        }
        .elevatedCard(accentColor: accent)
    }
}

// MARK: - Level Progress Card

struct LevelProgressCard: View {
    @EnvironmentObject var model: AppModel
    @State private var showDetails = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(model.level)")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    Text("\(model.xpToNextLevel) XP to next level")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                // Level badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [BrandTheme.accent, BrandTheme.primaryDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Text("\(model.level)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                .shadow(color: BrandTheme.accent.opacity(0.4), radius: 8, y: 4)
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                AnimatedProgressBar(
                    progress: model.levelProgress,
                    height: 10,
                    cornerRadius: 5,
                    color: BrandTheme.accent,
                    showGlow: true
                )
                
                HStack {
                    Text("\(Int(model.levelProgress * 100))%")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(BrandTheme.accent)
                    
                    Spacer()
                    
                    Text("\(model.totalXP) / \(model.level * 120) XP")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Next unlock hint
            if showDetails {
                Text(model.nextUnlockMessage)
                    .font(.caption)
                    .foregroundColor(BrandTheme.textSecondary)
                    .padding(DesignSystem.spacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                            .fill(BrandTheme.accentMuted.opacity(0.5))
                    )
            }
        }
        .brandCard()
    }
}

// MARK: - Dimension Balance Card

struct DimensionBalanceCard: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            // Header
            HStack {
                Text("Life Balance")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                if model.dimensionBalanceScore > 0 {
                    ChipView(
                        text: "\(model.dimensionBalanceScore)%",
                        icon: "circle.grid.cross",
                        color: balanceColor,
                        size: .small
                    )
                }
            }
            
            // Dimension bars
            ForEach(LifeDimension.allCases) { dim in
                DimensionBar(dimension: dim)
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

struct DimensionBar: View {
    @EnvironmentObject var model: AppModel
    let dimension: LifeDimension
    
    private var ratio: Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }
    
    private var color: Color {
        BrandTheme.dimensionColor(dimension)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack {
                Label {
                    Text(dimension.label)
                        .font(DesignSystem.text.labelSmall)
                } icon: {
                    Image(systemName: dimension.systemImage)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(color)
                
                Spacer()
                
                Text("\(model.xp(for: dimension)) XP")
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            AnimatedProgressBar(progress: ratio, height: 6, color: color)
        }
    }
}

// MARK: - Momentum Section

struct MomentumSection: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Momentum Board")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("Track your balance")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.spacing.md) {
                ForEach(model.dimensionRankings, id: \.dimension) { entry in
                    MomentumTile2(entry: entry)
                }
            }
        }
        .brandCard()
    }
}

struct MomentumTile2: View {
    let entry: (dimension: LifeDimension, ratio: Double, earned: Int, total: Int)
    
    private var color: Color {
        BrandTheme.dimensionColor(entry.dimension)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            HStack {
                Image(systemName: entry.dimension.systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(Int(entry.ratio * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(color)
            }
            
            Text(entry.dimension.label)
                .font(DesignSystem.text.labelSmall)
                .foregroundColor(BrandTheme.textPrimary)
            
            AnimatedProgressBar(progress: entry.ratio, height: 4, color: color)
            
            Text("\(entry.earned) / \(entry.total) XP")
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
        }
        .subtleCard()
    }
}

// MARK: - Micro Wins Section

struct MicroWinsSection: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "bolt.fill", color: BrandTheme.warning, size: .small, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Micro Wins")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    Text("Quick dopamine hits")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
            }
            
            ForEach(model.microWins.prefix(4)) { item in
                MicroWinRow2(item: item)
            }
        }
        .brandCard()
    }
}

struct MicroWinRow2: View {
    let item: ChecklistItem
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BrandTheme.warning)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                    .lineLimit(1)
                
                if let detail = item.detail {
                    Text(detail)
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            XPChip(xp: item.xp, size: .small)
        }
        .padding(DesignSystem.spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Arc Preview Card

struct ArcPreviewCard: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc
    
    private var accent: Color {
        Color(hex: arc.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        let progress = model.arcProgress(arc)
        let nextQuests = model.nextQuests(in: arc, limit: 2)
        let isSuggestion = model.activeArc == nil
        
        NavigationLink(destination: ArcDetailView(arc: arc)) {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                        HStack(spacing: DesignSystem.spacing.sm) {
                            ChipView(
                                text: isSuggestion ? "Suggested" : "Current Arc",
                                icon: "map.fill",
                                color: accent,
                                size: .small
                            )
                            
                            if let day = model.arcDay(for: arc) {
                                ChipView(text: "Day \(day)", icon: "clock", color: BrandTheme.mutedText, size: .small)
                            }
                        }
                        
                        Text(arc.title)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text(arc.subtitle)
                            .font(DesignSystem.text.bodySmall)
                            .foregroundColor(BrandTheme.mutedText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    IconContainer(systemName: arc.iconSystemName, color: accent, size: .medium, style: .soft)
                }
                
                // Progress
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    AnimatedProgressBar(progress: progress, height: 8, color: accent)
                    
                    HStack {
                        Text("\(Int(progress * 100))% complete")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                        
                        Spacer()
                        
                        Text("\(arc.questCount) quests")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
                
                // Next quests
                if !nextQuests.isEmpty {
                    Divider().background(BrandTheme.divider)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Next up")
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
            .elevatedCard(accentColor: accent)
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Booster Packs Section

struct BoosterPacksSection: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Booster Packs")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("Close a pack for dopamine")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.spacing.md) {
                    ForEach(Array(model.boosterPacks.prefix(4).enumerated()), id: \.offset) { index, entry in
                        NavigationLink(destination: PackDetailView(pack: entry.pack)) {
                            BoosterCard2(entry: entry)
                        }
                        .buttonStyle(CardButtonStyle())
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.vertical, DesignSystem.spacing.sm)
    }
}

struct BoosterCard2: View {
    let entry: (pack: CategoryPack, remaining: Int, progress: Double)
    
    private var accent: Color {
        Color(hex: entry.pack.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            // Header
            HStack(spacing: DesignSystem.spacing.sm) {
                IconContainer(systemName: entry.pack.iconSystemName, color: accent, size: .small, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.pack.title)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(entry.remaining) remaining")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Progress
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                AnimatedProgressBar(progress: entry.progress, height: 6, color: accent)
                
                Text("\(Int(entry.progress * 100))%")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(accent)
            }
        }
        .frame(width: 180)
        .subtleCard()
    }
}

// MARK: - Quick Actions Section

struct QuickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Quick Actions")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            VStack(spacing: DesignSystem.spacing.sm) {
                NavigationLink(destination: ArcsView()) {
                    QuickActionRow2(
                        icon: "map.fill",
                        title: "Arcs Hub",
                        subtitle: "View your arc progress and quests",
                        color: BrandTheme.accent
                    )
                }
                .buttonStyle(CardButtonStyle())
                
                NavigationLink(destination: ChallengeView()) {
                    QuickActionRow2(
                        icon: "flag.checkered",
                        title: "Weekend Challenge",
                        subtitle: "Get a curated challenge",
                        color: BrandTheme.warning
                    )
                }
                .buttonStyle(CardButtonStyle())
            }
        }
    }
}

struct QuickActionRow2: View {
    let icon: String
    let title: String
    let subtitle: String
    var color: Color = BrandTheme.accent
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: icon, color: color, size: .medium, style: .soft)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BrandTheme.mutedText)
        }
        .subtleCard()
    }
}

// MARK: - Optional Cards Section

struct OptionalCardsSection: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            // Energy Card
            if model.showEnergyCard {
                EnergyCheckCard2()
                    .bounceOnAppear(delay: 0.55)
            }
            
            // Weekly Blueprint
            if model.showWeeklyBlueprint {
                WeeklyBlueprintCard2()
                    .bounceOnAppear(delay: 0.6)
            }
            
            // Legendary Quest
            if model.showLegendaryQuestCard,
               model.settings.showProTeasers,
               let legendary = model.legendaryQuest,
               let pack = model.pack(for: legendary.id) {
                LegendaryQuestCard2(pack: pack, item: legendary)
                    .bounceOnAppear(delay: 0.65)
            }
            
            // Seasonal Spotlight
            if model.showSeasonalSpotlight, let spotlight = model.seasonalSpotlight {
                SeasonalSpotlightCard2(theme: spotlight.theme, items: spotlight.items)
                    .bounceOnAppear(delay: 0.7)
            }
            
            // Suggestion Card
            if model.showSuggestionCard, let suggestion = model.suggestedItem {
                NavigationLink(destination: PackDetailView(pack: suggestion.pack)) {
                    SuggestionCard2(pack: suggestion.pack, item: suggestion.item)
                }
                .buttonStyle(CardButtonStyle())
                .bounceOnAppear(delay: 0.75)
            }
            
            // Focus Dimension Card
            if model.showFocusDimensionCard, let dim = model.lowestDimension, !model.focusSuggestions.isEmpty {
                FocusDimensionCard2(dimension: dim, items: model.focusSuggestions)
                    .bounceOnAppear(delay: 0.8)
            }
            
            // Focus Playlist Card
            if model.showFocusPlaylistCard, !model.focusPlaylist.isEmpty {
                FocusPlaylistCard2(items: model.focusPlaylist)
                    .bounceOnAppear(delay: 0.85)
            }
        }
    }
}

// MARK: - Energy Check Card 2.0

struct EnergyCheckCard2: View {
    @EnvironmentObject var model: AppModel
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "battery.75", color: BrandTheme.success, size: .small, style: .soft)
                
                Text("Energy Check-in")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.1)) {
                        isExpanded.toggle()
                    }
                    HapticsEngine.lightImpact()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(BrandTheme.mutedText)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(BrandTheme.borderSubtle.opacity(0.5)))
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
                .buttonStyle(.plain)
            }
            
            Text(model.energyCheckIn)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.textSecondary)
            
            if isExpanded {
                Divider().background(BrandTheme.divider)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Quick resets")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    ForEach(model.recoveryPrompts.prefix(3), id: \.self) { prompt in
                        HStack(alignment: .top, spacing: DesignSystem.spacing.sm) {
                            Image(systemName: "sparkle")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(BrandTheme.accent)
                            
                            Text(prompt)
                                .font(.caption)
                                .foregroundColor(BrandTheme.textSecondary)
                        }
                    }
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Weekly Blueprint Card 2.0

struct WeeklyBlueprintCard2: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Weekly Blueprint")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                ChipView(text: "Tiny rituals", color: BrandTheme.accent, size: .small)
            }
            
            Text("3 micro moves to start your momentum")
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
            
            ForEach(model.weeklyBlueprint) { step in
                HStack(spacing: DesignSystem.spacing.md) {
                    IconContainer(systemName: step.icon, color: BrandTheme.accent, size: .small, style: .soft)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text(step.detail)
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Legendary Quest Card 2.0

struct LegendaryQuestCard2: View {
    let pack: CategoryPack
    let item: ChecklistItem
    
    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "bolt.circle.fill", color: BrandTheme.warning, size: .small, style: .filled)
                
                Text("Boss Fight")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                ChipView(text: "High XP", color: BrandTheme.warning, size: .small)
            }
            
            Text(item.title)
                .font(DesignSystem.text.cardTitle)
                .foregroundColor(BrandTheme.textPrimary)
            
            if let detail = item.detail {
                Text(detail)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(2)
            }
            
            HStack(spacing: DesignSystem.spacing.sm) {
                ChipView(text: pack.title, icon: pack.iconSystemName, color: accent, size: .small)
                XPChip(xp: item.xp, size: .small)
            }
        }
        .elevatedCard(accentColor: BrandTheme.warning)
    }
}

// MARK: - Seasonal Spotlight Card 2.0

struct SeasonalSpotlightCard2: View {
    let theme: SpotlightTheme
    let items: [ChecklistItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: theme.iconSystemName, color: BrandTheme.dimensionColor(theme.focus), size: .medium, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(theme.title)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(theme.description)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                ChipView(text: "Season", color: BrandTheme.dimensionColor(theme.focus), size: .small)
            }
            
            ForEach(items) { item in
                HStack(spacing: DesignSystem.spacing.sm) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(BrandTheme.accent)
                    
                    Text(item.title)
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(item.xp) XP")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Suggestion Card 2.0

struct SuggestionCard2: View {
    let pack: CategoryPack
    let item: ChecklistItem
    
    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: pack.iconSystemName, color: accent, size: .medium, style: .soft)
            
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                Text("Today's focus")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
                
                Text(item.title)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                    .lineLimit(2)
                
                HStack(spacing: DesignSystem.spacing.sm) {
                    ChipView(text: pack.title, color: accent, size: .small)
                    XPChip(xp: item.xp, size: .small)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BrandTheme.mutedText)
        }
        .brandCard()
    }
}

// MARK: - Focus Dimension Card 2.0

struct FocusDimensionCard2: View {
    let dimension: LifeDimension
    let items: [ChecklistItem]
    
    private var color: Color {
        BrandTheme.dimensionColor(dimension)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: dimension.systemImage, color: color, size: .small, style: .soft)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(dimension.label)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Your weakest stat - pick one for quick XP")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                ChipView(text: "Focus", color: color, size: .small)
            }
            
            ForEach(items) { item in
                HStack(spacing: DesignSystem.spacing.sm) {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    Text(item.title)
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(item.xp) XP")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
        }
        .brandCard(enableGlow: true, glowColor: color)
    }
}

// MARK: - Focus Playlist Card 2.0

struct FocusPlaylistCard2: View {
    let items: [ChecklistItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text("Focus Playlist")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                ChipView(text: "\(items.count) quests", color: BrandTheme.accent, size: .small)
            }
            
            Text("Quick selection to tick through today")
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
            
            ForEach(items) { item in
                HStack(spacing: DesignSystem.spacing.sm) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(BrandTheme.accent)
                    
                    Text(item.title)
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    XPChip(xp: item.xp, size: .small)
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Legacy Support (ProgressRing)

struct ProgressRing: View {
    let progress: Double
    
    var body: some View {
        AnimatedProgressRing(progress: progress, lineWidth: 14, showPercentage: true)
    }
}
