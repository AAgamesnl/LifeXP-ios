import SwiftUI

// MARK: - Challenge View

struct ChallengeView: View {
    @Environment(AppModel.self) private var model

    private var board: (arc: Arc?, quests: [Quest]) {
        model.nextQuestBoard(limit: 3)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()

                ScrollView {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        // Challenge Header
                        ChallengeHeaderCard()
                        
                        // Arc Challenge
                        ArcChallengeSection(arc: board.arc, quests: board.quests)
                        
                        // Boss Fights
                        BossFightsSection()
                        
                        // Micro Wins
                        MicroWinsChallengeSection()
                        
                        // Recovery
                        RecoverySection()

                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
            }
            .navigationTitle("Weekend Challenge")
        }
    }
}

// MARK: - Challenge Header Card

struct ChallengeHeaderCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                IconContainer(systemName: "flag.checkered", color: BrandTheme.warning, size: .large, style: .gradient)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    Text("Fast Track to Momentum")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Mix of arc quests, boss fights, and micro wins curated for you")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Stats chips
            HStack(spacing: DesignSystem.spacing.md) {
                if model.currentStreak > 0 {
                    StreakChip(days: model.currentStreak, size: .medium)
                }
                
                XPChip(xp: model.totalXP, size: .medium)
                
                if let weakest = model.lowestDimension {
                    ChipView(
                        text: "Focus: \(weakest.label)",
                        icon: weakest.systemImage,
                        color: BrandTheme.dimensionColor(weakest),
                        size: .medium
                    )
                }
            }
            
            // Affirmation
            Text(model.dailyAffirmation)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.textSecondary)
                .italic()
                .padding(DesignSystem.spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(BrandTheme.accentMuted.opacity(0.5))
                )
        }
        .elevatedCard(accentColor: BrandTheme.warning)
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Arc Challenge Section

struct ArcChallengeSection: View {
    @Environment(AppModel.self) private var model
    let arc: Arc?
    let quests: [Quest]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "map.fill", color: BrandTheme.accent, size: .small, style: .soft)
                
                Text("Arc Focus")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                if arc != nil {
                    Text(model.arcProgressHeadline)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }

            if let arc = arc, !quests.isEmpty {
                let accent = Color(hex: arc.accentColorHex, default: BrandTheme.accent)
                
                // Arc info
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
                            AnimatedProgressBar(progress: model.arcProgress(arc), height: 6, color: accent)
                                .frame(maxWidth: 100)
                            
                            Text("\(Int(model.arcProgress(arc) * 100))%")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(accent)
                        }
                    }
                    
                    Spacer()
                }
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(accent.opacity(0.08))
                )
                
                Divider().background(BrandTheme.divider)
                
                // Quests
                ForEach(quests) { quest in
                    ChallengeQuestRow(quest: quest, accent: accent)
                }
            } else {
                // Empty state
                VStack(spacing: DesignSystem.spacing.md) {
                    IconContainer(systemName: "map", color: BrandTheme.mutedText, size: .large, style: .soft)
                    
                    Text("No Arc Selected")
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Open the Arcs hub and choose a story. We'll show your quests here automatically.")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: ArcsView()) {
                        Text("Go to Arcs")
                    }
                    .buttonStyle(SoftButtonStyle())
                }
                .padding(DesignSystem.spacing.xl)
            }
        }
        .brandCard()
    }
}

struct ChallengeQuestRow: View {
    @Environment(AppModel.self) private var model
    let quest: Quest
    let accent: Color
    
    @State private var isAnimating = false
    
    private var isCompleted: Bool { model.isCompleted(quest) }

    var body: some View {
        Button {
            let willComplete = !isCompleted
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = true
            }
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                model.toggle(quest)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isAnimating = false
                }
            }
            
            if willComplete {
                HapticsEngine.lightImpact()
            }
        } label: {
            HStack(spacing: DesignSystem.spacing.md) {
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isCompleted ? accent : BrandTheme.borderSubtle, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isCompleted {
                        Circle()
                            .fill(accent)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isAnimating ? 1.2 : 1)
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    Text(quest.title)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(isCompleted ? BrandTheme.mutedText : BrandTheme.textPrimary)
                        .strikethrough(isCompleted)
                    
                    if let detail = quest.detail {
                        Text(detail)
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: DesignSystem.spacing.sm) {
                        ChipView(text: quest.kind.label, icon: quest.kind.systemImage, color: accent, size: .small)
                        
                        if let minutes = quest.estimatedMinutes {
                            ChipView(text: "~\(minutes) min", icon: "clock", color: BrandTheme.mutedText, size: .small)
                        }
                    }
                }
                
                Spacer()
                
                XPChip(xp: quest.xp, size: .small)
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(isCompleted ? BrandTheme.cardBackgroundElevated.opacity(0.3) : BrandTheme.cardBackgroundElevated.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Boss Fights Section

struct BossFightsSection: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "bolt.circle.fill", color: BrandTheme.error, size: .small, style: .soft)
                
                Text("Boss Fights")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("Highest XP")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }

            if model.heroQuests.isEmpty {
                EmptyMiniState(
                    icon: "bolt.circle",
                    message: "Complete some basic quests first. Then we'll show you your boss fights."
                )
            } else {
                ForEach(model.heroQuests) { quest in
                    BossFightRow(item: quest)
                }
            }
        }
        .brandCard()
    }
}

struct BossFightRow: View {
    let item: ChecklistItem

    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(BrandTheme.error)

            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                Text(item.title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                if let detail = item.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(2)
                }
                
                HStack(spacing: DesignSystem.spacing.sm) {
                    ForEach(item.dimensions.prefix(2)) { dim in
                        ChipView(text: dim.label, color: BrandTheme.dimensionColor(dim), size: .small)
                    }
                }
            }

            Spacer()

            XPChip(xp: item.xp, size: .medium)
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.error.opacity(0.08))
        )
    }
}

// MARK: - Micro Wins Challenge Section

struct MicroWinsChallengeSection: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "bolt.fill", color: BrandTheme.warning, size: .small, style: .soft)
                
                Text("Micro Wins")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Text("Dopamine snacks")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }

            if model.microWins.isEmpty {
                EmptyMiniState(
                    icon: "checkmark.circle",
                    message: "All caught up! Pick an arc or boss fight for momentum."
                )
            } else {
                ForEach(model.microWins) { item in
                    MicroWinChallengeRow(item: item)
                }
            }
        }
        .brandCard()
    }
}

struct MicroWinChallengeRow: View {
    let item: ChecklistItem

    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BrandTheme.warning)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DesignSystem.text.labelSmall)
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

// MARK: - Recovery Section

struct RecoverySection: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "leaf.fill", color: BrandTheme.success, size: .small, style: .soft)
                
                Text("Recovery Mode")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
            }
            
            Text("Low energy? These gentle resets help you recharge.")
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)

            ForEach(model.recoveryPrompts.prefix(3), id: \.self) { prompt in
                HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(BrandTheme.success)
                        .padding(.top, 2)

                    Text(prompt)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                }
            }
        }
        .brandCard()
    }
}

struct EmptyMiniState: View {
    let icon: String
    let message: String

    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(BrandTheme.mutedText)
            
            Text(message)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
        }
        .padding(DesignSystem.spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Badges View

struct BadgesView: View {
    @Environment(AppModel.self) private var model
    
    @State private var selectedTab: BadgeTab = .unlocked

    enum BadgeTab: String, CaseIterable {
        case unlocked = "Unlocked"
        case locked = "Locked"
    }

    private var lockedBadges: [Badge] {
        badgeCatalog.filter { badge in
            !model.unlockedBadges.contains(where: { $0.id == badge.id })
        }
    }

    private var badgeCatalog: [Badge] {
        [
            Badge(id: "badge_getting_started", name: "Getting Started", description: "50+ XP collected", iconSystemName: "sparkles"),
            Badge(id: "badge_leveling_up", name: "Leveling Up", description: "200+ XP collected", iconSystemName: "arrow.up.circle.fill"),
            Badge(id: "badge_architect", name: "Life Architect", description: "500+ XP - you're designing your life", iconSystemName: "rectangle.3.group.fill"),
            Badge(id: "badge_legend", name: "Level 100 Vibes", description: "1000+ XP - legendary status", iconSystemName: "star.circle.fill"),
            Badge(id: "badge_soft_lover", name: "Soft Lover", description: "80+ Love XP", iconSystemName: "heart.circle.fill"),
            Badge(id: "badge_money_minded", name: "Money Minded", description: "80+ Money XP", iconSystemName: "banknote.fill"),
            Badge(id: "badge_inner_work", name: "Inner Work", description: "150+ Mind XP", iconSystemName: "brain"),
            Badge(id: "badge_explorer", name: "Explorer", description: "120+ Adventure XP", iconSystemName: "safari.fill"),
            Badge(id: "badge_streak_3", name: "On A Roll", description: "3+ day streak", iconSystemName: "flame.fill"),
            Badge(id: "badge_streak_7", name: "Consistency Era", description: "7+ day streak", iconSystemName: "calendar.badge.checkmark"),
            Badge(id: "badge_unstoppable", name: "Unstoppable", description: "21+ day streak", iconSystemName: "bolt.fill"),
            Badge(id: "badge_story_arc", name: "Story Arc", description: "Complete 1 arc", iconSystemName: "book.circle.fill"),
            Badge(id: "badge_arc_collector", name: "Arc Collector", description: "Complete 3 arcs", iconSystemName: "rectangle.stack.fill"),
            Badge(id: "badge_chapter_closer", name: "Chapter Closer", description: "Complete 3+ chapters", iconSystemName: "book.closed.fill"),
            Badge(id: "badge_balanced", name: "Balanced", description: "60%+ in all dimensions", iconSystemName: "circle.grid.cross"),
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackgroundStatic()

                VStack(spacing: 0) {
                    // Tab selector
                    HStack(spacing: DesignSystem.spacing.md) {
                        ForEach(BadgeTab.allCases, id: \.rawValue) { tab in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedTab = tab
                                }
                            } label: {
                                Text(tab.rawValue)
                                    .font(DesignSystem.text.labelMedium)
                                    .foregroundColor(selectedTab == tab ? .white : BrandTheme.textSecondary)
                                    .padding(.horizontal, DesignSystem.spacing.lg)
                                    .padding(.vertical, DesignSystem.spacing.sm)
                                    .background(
                                        Capsule()
                                            .fill(selectedTab == tab ? BrandTheme.accent : Color.clear)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(DesignSystem.spacing.md)
                    .background(BrandTheme.cardBackground.opacity(0.8))
                    
                    // Content
                    ScrollView {
                        VStack(spacing: DesignSystem.spacing.lg) {
                            // Stats
                            BadgeStatsCard()
                            
                            // Badges
                            if selectedTab == .unlocked {
                                UnlockedBadgesSection()
                            } else {
                                LockedBadgesSection(badges: lockedBadges)
                            }
                            
                            Color.clear.frame(height: DesignSystem.spacing.xxl)
                        }
                        .padding(.horizontal, DesignSystem.spacing.lg)
                    }
                }
            }
            .navigationTitle("Badges")
        }
    }
}

// MARK: - Badge Stats Card

struct BadgeStatsCard: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        HStack(spacing: DesignSystem.spacing.lg) {
            // Unlocked count
            VStack(spacing: DesignSystem.spacing.xs) {
                ZStack {
                    Circle()
                        .fill(BrandTheme.success.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Text("\(model.unlockedBadges.count)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(BrandTheme.success)
                }
                
                Text("Unlocked")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            // Total XP
            VStack(spacing: DesignSystem.spacing.xs) {
                ZStack {
                    Circle()
                        .fill(BrandTheme.warning.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Text("\(model.totalXP)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(BrandTheme.warning)
                }
                
                Text("Total XP")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            // Best streak
            VStack(spacing: DesignSystem.spacing.xs) {
                ZStack {
                    Circle()
                        .fill(BrandTheme.error.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text("\(model.bestStreak)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(BrandTheme.error)
                }
                
                Text("Best Streak")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            // Arcs completed
            VStack(spacing: DesignSystem.spacing.xs) {
                ZStack {
                    Circle()
                        .fill(BrandTheme.accent.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Text("\(model.completedArcs.count)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(BrandTheme.accent)
                }
                
                Text("Arcs Done")
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .brandCard()
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Unlocked Badges Section

struct UnlockedBadgesSection: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Your Achievements")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)

            if model.unlockedBadges.isEmpty {
                EmptyStateView(
                    icon: "rosette",
                    title: "No badges yet",
                    message: "Collect XP and build streaks to unlock badges!",
                    actionTitle: "Go to Home",
                    action: nil
                )
            } else {
                LazyVStack(spacing: DesignSystem.spacing.md) {
                    ForEach(model.unlockedBadges) { badge in
                        BadgeCard(badge: badge, unlocked: true)
                    }
                }
            }
        }
    }
}

// MARK: - Locked Badges Section

struct LockedBadgesSection: View {
    let badges: [Badge]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Goals to Unlock")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)

            if badges.isEmpty {
                VStack(spacing: DesignSystem.spacing.md) {
                    IconContainer(systemName: "trophy.fill", color: BrandTheme.warning, size: .hero, style: .soft)
                    
                    Text("All badges unlocked!")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("You've achieved everything. New badges coming soon!")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .multilineTextAlignment(.center)
                }
                .padding(DesignSystem.spacing.xxl)
            } else {
                LazyVStack(spacing: DesignSystem.spacing.md) {
                    ForEach(badges) { badge in
                        BadgeCard(badge: badge, unlocked: false)
                    }
                }
            }
        }
    }
}

// MARK: - Badge Card

struct BadgeCard: View {
    let badge: Badge
    var unlocked: Bool = true

    var body: some View {
        HStack(spacing: DesignSystem.spacing.lg) {
            // Icon
            ZStack {
                Circle()
                    .fill(unlocked ? BrandTheme.accent : BrandTheme.borderSubtle)
                    .frame(width: 56, height: 56)
                
                Image(systemName: badge.iconSystemName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(unlocked ? .white : BrandTheme.mutedText)
            }
            .shadow(color: unlocked ? BrandTheme.accent.opacity(0.4) : .clear, radius: 8, y: 4)

            // Content
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                HStack {
                    Text(badge.name)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if unlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(BrandTheme.success)
                    }
                }
                
                Text(badge.description)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
            }

            Spacer()

            // Status indicator
            if !unlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                .fill(unlocked ? BrandTheme.success.opacity(0.08) : BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                .strokeBorder(unlocked ? BrandTheme.success.opacity(0.2) : BrandTheme.borderSubtle.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Legacy Support

struct QuestSummaryRow: View {
    let quest: Quest
    let accent: Color

    var body: some View {
        ChallengeQuestRow(quest: quest, accent: accent)
    }
}

struct ChecklistSummaryRow: View {
    let item: ChecklistItem

    var body: some View {
        MicroWinChallengeRow(item: item)
    }
}

struct BadgeRow: View {
    let badge: Badge
    var unlocked: Bool = true

    var body: some View {
        BadgeRow2(badge: badge, unlocked: unlocked)
    }
}
