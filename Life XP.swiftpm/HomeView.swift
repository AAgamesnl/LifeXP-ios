import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @Environment(AppModel.self) private var model
    @State private var showLogMood = false
    
    private var dailyQuest: DailyChallenge? {
        model.dailyChallengeManager.todaysChallenges.first
    }

    private var primaryCTA: HubCTA {
        if let activeArc = model.activeArc {
            return .continueArc(activeArc)
        }

        if model.dailyChallengeManager.allChallengesCompleted {
            return .claimReward
        }

        if let item = (model.focusSuggestions.first ?? model.microWins.first),
           let pack = model.pack(for: item.id) {
            return .startAdventure(pack)
        }

        return .exploreArcs
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        HubDailyQuestCard(challenge: dailyQuest)
                            .opacity(model.showHeroCards ? 1 : 0)
                            .offset(y: model.showHeroCards ? 0 : 16)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: model.showHeroCards)

                        HubProgressSummaryCard()

                        HubPrimaryCTA(cta: primaryCTA)

                        HubModeSwitcher()

                        HubCheckInCard(showLogMood: $showLogMood)

                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.top, DesignSystem.spacing.md)
                }
            }
            .navigationTitle(L10n.hubTitle)
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
            .sheet(isPresented: $showLogMood) {
                LogMoodSheet(manager: model.journalManager)
            }
        }
    }
}

// MARK: - Hub CTA Model

struct HubCTA {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let icon: String
    let color: Color
    let destination: AnyView

    static func continueArc(_ arc: Arc) -> HubCTA {
        HubCTA(
            title: L10n.hubCTAContinueArc,
            subtitle: LocalizedStringKey(arc.title),
            icon: "book.fill",
            color: Color(hex: arc.accentColorHex, default: BrandTheme.accent),
            destination: AnyView(ArcDetailView(arc: arc))
        )
    }

    static func startAdventure(_ pack: CategoryPack) -> HubCTA {
        HubCTA(
            title: L10n.hubCTAStartAdventure,
            subtitle: LocalizedStringKey(pack.title),
            icon: pack.iconSystemName,
            color: Color(hex: pack.accentColorHex, default: BrandTheme.accent),
            destination: AnyView(PackDetailView(pack: pack))
        )
    }

    static var claimReward: HubCTA {
        HubCTA(
            title: L10n.hubCTAClaimReward,
            subtitle: L10n.hubCTAClaimSubtitle,
            icon: "trophy.fill",
            color: BrandTheme.warning,
            destination: AnyView(BadgesView())
        )
    }

    static var exploreArcs: HubCTA {
        HubCTA(
            title: L10n.hubCTAExploreArcs,
            subtitle: L10n.hubCTAExploreSubtitle,
            icon: "map.fill",
            color: BrandTheme.accent,
            destination: AnyView(ArcsView())
        )
    }
}

// MARK: - Hub Daily Quest Card

struct HubDailyQuestCard: View {
    @Environment(AppModel.self) private var model
    let challenge: DailyChallenge?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: "sparkles", color: BrandTheme.accent, size: .medium, style: .gradient)

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.hubDailyQuestTitle)
                        .font(DesignSystem.text.headlineLarge)
                        .foregroundColor(BrandTheme.textPrimary)

                    Text(L10n.hubDailyQuestSubtitle)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }

                Spacer()

                XPChip(xp: model.dailyChallengeManager.totalBonusXPAvailable, size: .small)
            }

            if let challenge {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    HStack {
                        Text(challenge.title)
                            .font(DesignSystem.text.labelLarge)
                            .foregroundColor(BrandTheme.textPrimary)

                        Spacer()

                        Text("\(challenge.progress)/\(challenge.targetCount)")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                    }

                    Text(challenge.description)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                        .lineLimit(2)

                    AnimatedProgressBar(
                        progress: challenge.progressRatio,
                        height: 10,
                        color: challenge.isCompleted ? BrandTheme.success : BrandTheme.accent,
                        showGlow: true
                    )

                    if challenge.isCompleted {
                        ChipView(text: String(localized: "hub.dailyQuest.completed", bundle: .module), icon: "checkmark.seal.fill", color: BrandTheme.success, size: .small)
                    }
                }
            } else {
                Text(L10n.hubDailyQuestEmpty)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.textSecondary)
            }
        }
        .elevatedCard(accentColor: BrandTheme.accent)
    }
}

// MARK: - Hub Progress Summary

struct HubProgressSummaryCard: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            HStack {
                Text(L10n.hubProgressTitle)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)

                Spacer()

                ChipView(
                    text: String(format: String(localized: "hub.progress.level", bundle: .module), model.level),
                    icon: "star.fill",
                    color: BrandTheme.accent,
                    size: .small
                )
            }

            HStack(spacing: DesignSystem.spacing.xl) {
                AnimatedProgressRing(
                    progress: model.levelProgress,
                    lineWidth: 12,
                    showPercentage: true
                )
                .frame(width: 96, height: 96)

                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    StatRow(
                        icon: "star.fill",
                        label: String(localized: "hub.progress.totalXp", bundle: .module),
                        value: "\(model.totalXP)",
                        color: BrandTheme.warning
                    )

                    StatRow(
                        icon: "bolt.fill",
                        label: String(localized: "hub.progress.nextLevel", bundle: .module),
                        value: String(format: String(localized: "hub.progress.xpRemaining", bundle: .module), model.xpToNextLevel),
                        color: BrandTheme.accent
                    )

                    StatRow(
                        icon: "flame.fill",
                        label: String(localized: "hub.progress.streak", bundle: .module),
                        value: String(format: String(localized: "hub.progress.streakDays", bundle: .module), model.currentStreak),
                        color: BrandTheme.success
                    )
                }

                Spacer()
            }
        }
        .brandCard()
    }
}

// MARK: - Hub Primary CTA

struct HubPrimaryCTA: View {
    let cta: HubCTA

    var body: some View {
        NavigationLink(destination: cta.destination) {
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: cta.icon, color: cta.color, size: .medium, style: .soft)

                VStack(alignment: .leading, spacing: 4) {
                    Text(cta.title)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)

                    if let subtitle = cta.subtitle {
                        Text(subtitle)
                            .font(DesignSystem.text.bodySmall)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(cta.color)
            }
            .padding(DesignSystem.spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackgroundElevated.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(cta.color.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hub Mode Switcher

struct HubModeSwitcher: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text(L10n.hubModesTitle)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.spacing.md) {
                    NavigationLink(destination: ArcsView()) {
                        HubModeCard(
                            title: L10n.hubModeStoryTitle,
                            subtitle: L10n.hubModeStorySubtitle,
                            icon: "book.fill",
                            color: BrandTheme.love
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: PacksView()) {
                        HubModeCard(
                            title: L10n.hubModeTrainingTitle,
                            subtitle: L10n.hubModeTrainingSubtitle,
                            icon: "rectangle.stack.fill",
                            color: BrandTheme.success
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: JournalView(manager: model.journalManager)) {
                        HubModeCard(
                            title: L10n.hubModeReflectionTitle,
                            subtitle: L10n.hubModeReflectionSubtitle,
                            icon: "quote.bubble.fill",
                            color: BrandTheme.mind
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

struct HubModeCard: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: icon, color: color, size: .small, style: .gradient)

            Text(title)
                .font(DesignSystem.text.headlineSmall)
                .foregroundColor(BrandTheme.textPrimary)

            Text(subtitle)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
                .lineLimit(2)
        }
        .frame(width: 210, alignment: .leading)
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackground.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Hub Check-in Card

struct HubCheckInCard: View {
    @Environment(AppModel.self) private var model
    @Binding var showLogMood: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "heart.circle.fill", color: BrandTheme.adventure, size: .small, style: .soft)

                Text(L10n.reflectionCheckInTitle)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)

                Spacer()
            }

            Text(model.dailyAffirmation)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.textSecondary)

            Button {
                showLogMood = true
            } label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text(L10n.actionLogMoodTitle)
                }
            }
            .buttonStyle(GlowButtonStyle(size: .medium))
        }
        .brandCard()
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
    @Environment(AppModel.self) private var model
    
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
                AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
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
    @Environment(AppModel.self) private var model
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
    @Environment(AppModel.self) private var model
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
    @Environment(AppModel.self) private var model
    
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
    @Environment(AppModel.self) private var model
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
    @Environment(AppModel.self) private var model
    
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

// MARK: - Arc Preview Card

struct ArcPreviewCard: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    
    private var accent: Color {
        Color(hex: arc.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        let progress = model.arcProgress(arc)
        let nextQuests = model.nextQuests(in: arc, limit: 2)
        
        NavigationLink(destination: ArcDetailView(arc: arc)) {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                        HStack(spacing: DesignSystem.spacing.sm) {
                            ChipView(text: "Current Arc", icon: "map.fill", color: accent, size: .small)
                            
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

// MARK: - Start Arc Card

struct StartArcCard: View {
    var body: some View {
        NavigationLink(destination: ArcsView()) {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                HStack {
                    IconContainer(systemName: "map.fill", color: BrandTheme.accent, size: .medium, style: .soft)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.startArcTitle)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text(L10n.startArcSubtitle)
                            .font(DesignSystem.text.bodySmall)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            .brandCard()
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Featured Packs Section

struct FeaturedPacksSection: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text(L10n.packsTitle)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text(L10n.packsSubtitle)
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.spacing.md) {
                    ForEach(Array(model.featuredPacks.prefix(4).enumerated()), id: \.offset) { index, entry in
                        NavigationLink(destination: PackDetailView(pack: entry.pack)) {
                            FeaturedPackCard(entry: entry)
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

struct FeaturedPackCard: View {
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
    @Binding var showLogMood: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text(L10n.quickActionsTitle)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            VStack(spacing: DesignSystem.spacing.sm) {
                Button {
                    showLogMood = true
                } label: {
                    QuickActionRow2(
                        icon: "face.smiling",
                        title: String(localized: "action.logMood.title"),
                        subtitle: String(localized: "action.logMood.subtitle"),
                        color: BrandTheme.success
                    )
                }
                .buttonStyle(CardButtonStyle())

                NavigationLink(destination: ArcsView()) {
                    QuickActionRow2(
                        icon: "map.fill",
                        title: String(localized: "action.arcs.title"),
                        subtitle: String(localized: "action.arcs.subtitle"),
                        color: BrandTheme.accent
                    )
                }
                .buttonStyle(CardButtonStyle())

                NavigationLink(destination: PacksView()) {
                    QuickActionRow2(
                        icon: "checklist",
                        title: String(localized: "action.packs.title"),
                        subtitle: String(localized: "action.packs.subtitle"),
                        color: BrandTheme.info
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
    @Environment(AppModel.self) private var model
    
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
    @Environment(AppModel.self) private var model
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
    @Environment(AppModel.self) private var model
    
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
