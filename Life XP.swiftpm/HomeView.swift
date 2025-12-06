import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: AppModel
    @State private var showHeroCard = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                ScrollView {
                    let spacing: CGFloat = model.compactHomeLayout ? DesignSystem.spacing.xl : DesignSystem.spacing.xxl
                    VStack(spacing: spacing) {
                        // Life score + streak
                        VStack(spacing: DesignSystem.spacing.lg) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Life XP")
                                        .font(DesignSystem.text.captionEmphasis)
                                        .foregroundColor(BrandTheme.mutedText)

                                    Text("Your Life Checklist")
                                        .font(DesignSystem.text.heroTitle)
                                }

                                Spacer()

                                if model.showStreaks && model.currentStreak > 0 {
                                    HStack(spacing: 6) {
                                        Image(systemName: "flame.fill")
                                        Text("\(model.currentStreak)-day streak")
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule().fill(BrandTheme.accent.opacity(0.12))
                                    )
                                    .foregroundColor(BrandTheme.accent)
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("Current streak")
                                    .accessibilityValue("\(model.currentStreak) days")
                                }
                            }
                            
                            HStack(spacing: 20) {
                                ProgressRing(progress: model.globalProgress)
                                    .frame(width: 110, height: 110)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Life Score")
                                        .font(.headline)
                                    Text("\(Int(model.globalProgress * 100))% completed")
                                        .font(.title2.bold())
                                    
                                    Text("\(model.totalXP) XP earned")
                                        .font(.subheadline)
                                        .foregroundColor(BrandTheme.mutedText)
                                    
                                    if model.bestStreak > 0 {
                                        Text("Best streak: \(model.bestStreak) days")
                                            .font(.caption)
                                            .foregroundColor(BrandTheme.mutedText)
                                    }
                                }
                                
                                Spacer()
                            }

                            Text(model.coachMessage)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .brandCard()

                        if let arcPreview = model.highlightedArc, model.showHeroCards {
                            let board = model.nextQuestBoard(limit: model.questBoardLimit)
                            let next = board.arc?.id == arcPreview.id ? board.quests : model.nextQuests(in: arcPreview, limit: 2)
                            NavigationLink(destination: ArcDetailView(arc: arcPreview)) {
                                CurrentArcCard(
                                    arc: arcPreview,
                                    progress: model.arcProgress(arcPreview),
                                    nextQuests: next,
                                    isSuggestion: model.activeArc == nil
                                )
                            }
                            .buttonStyle(.plain)
                            .opacity(showHeroCard ? 1 : 0)
                            .scaleEffect(showHeroCard ? 1 : 0.98)
                            .animation(.easeOut(duration: 0.6).delay(0.05), value: showHeroCard)
                        } else if let arcPreview = model.highlightedArc {
                            CompactArcSummary(arc: arcPreview, progress: model.arcProgress(arcPreview), nextQuests: model.nextQuests(in: arcPreview, limit: 1))
                        }

                        DailyBriefingCard(
                            affirmation: model.dailyAffirmation,
                            ritual: model.ritualOfTheDay,
                            focusHeadline: model.focusHeadline,
                            nextUnlock: model.nextUnlockMessage,
                            streak: model.showStreaks ? model.currentStreak : 0,
                            defaultExpanded: model.expandHomeCardsByDefault
                        )
                        .environmentObject(model)

                        if model.showEnergyCard {
                            EnergyCheckCard(
                                headline: model.energyCheckIn,
                                prompts: model.recoveryPrompts,
                                remaining: model.remainingCount,
                                defaultExpanded: model.expandHomeCardsByDefault
                            )
                            .environmentObject(model)
                        }

                        LevelCard(
                            level: model.level,
                            progress: model.levelProgress,
                            xpToNext: model.xpToNextLevel,
                            nextUnlock: model.nextUnlockMessage
                        )
                        .environmentObject(model)

                        if let spotlight = model.seasonalSpotlight {
                            SeasonalSpotlightCard(theme: spotlight.theme, items: spotlight.items)
                        }

                        if model.settings.showProTeasers, let legendary = model.legendaryQuest, let pack = model.pack(for: legendary.id) {
                            LegendaryQuestCard(pack: pack, item: legendary)
                        }

                        WeeklyBlueprintCard(steps: model.weeklyBlueprint)

                        // Suggestion card
                        if let suggestion = model.suggestedItem {
                            NavigationLink(destination: PackDetailView(pack: suggestion.pack)) {
                                SuggestionCardView(pack: suggestion.pack, item: suggestion.item)
                            }
                            .buttonStyle(.plain)
                        }

                        if let dim = model.lowestDimension, !model.focusSuggestions.isEmpty {
                            FocusDimensionCard(dimension: dim, items: model.focusSuggestions)
                        }

                        if !model.focusPlaylist.isEmpty {
                            FocusPlaylistCard(items: model.focusPlaylist)
                        }

                        // Quick dimension bars
                        VStack(spacing: 16) {
                            HStack {
                                Text("Your balance")
                                    .font(.headline)
                                Spacer()
                            }

                            ForEach(LifeDimension.allCases) { dim in
                                DimensionRow(dimension: dim)
                            }
                        }
                        .brandCard(cornerRadius: 20)

                        if model.showMomentumGrid {
                            MomentumGrid(rankings: model.dimensionRankings)
                                .environmentObject(model)
                        }

                        if !model.boosterPacks.isEmpty {
                            BoosterCarousel(boosterPacks: model.boosterPacks)
                        }

                        // Quick links
                        if model.showQuickActions {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Quick actions")
                                        .font(.headline)
                                    Spacer()
                                }

                                NavigationLink(destination: ArcsView()) {
                                    QuickActionRow(
                                        icon: "map.fill",
                                        title: "Arcs hub",
                                        subtitle: "Zie je huidige arc, suggesties en quest board."
                                    )
                                }
                                .buttonStyle(.plain)

                                NavigationLink(destination: ChallengeView()) {
                                    QuickActionRow(
                                        icon: "flag.checkered",
                                        title: "Weekend Challenge",
                                        subtitle: "Laat Life XP een challenge voor je samenstellen."
                                    )
                                }
                                .buttonStyle(.plain)

                                if !model.microWins.isEmpty {
                                    MicroWinsCard(items: model.microWins)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    showHeroCard = true
                }
            }
        }
    }
}

struct CurrentArcCard: View {
    let arc: Arc
    let progress: Double
    let nextQuests: [Quest]
    let isSuggestion: Bool

    var body: some View {
        let accent = Color(hex: arc.accentColorHex, default: .accentColor)

        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Label(isSuggestion ? "Suggested arc" : "Current arc", systemImage: "map.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(BrandTheme.mutedText)
                    Text(arc.title)
                        .font(.headline)
                    Text(arc.subtitle)
                        .font(.subheadline)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: arc.iconSystemName)
                    .font(.title2.weight(.bold))
                    .foregroundColor(accent)
                    .padding(12)
                    .background(Circle().fill(accent.opacity(0.14)))
            }

            ProgressView(value: progress) {
                Text("\(Int(progress * 100))% • \(arc.questCount) quests")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            .tint(accent)
            .animation(.easeInOut(duration: 0.6), value: progress)

            if !nextQuests.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Next up")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(BrandTheme.mutedText)
                    ForEach(nextQuests) { quest in
                        HStack(spacing: 6) {
                            Image(systemName: quest.kind.systemImage)
                                .foregroundColor(accent)
                            Text(quest.title)
                                .font(.subheadline)
                            Spacer()
                            Text("\(quest.xp) XP")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                }
            }
        }
        .brandCard(cornerRadius: 22)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Arc: \(arc.title)")
        .accessibilityHint(isSuggestion ? "Suggested arc with \(Int(progress * 100)) percent complete" : "Current arc with \(Int(progress * 100)) percent complete")
    }
}

struct CompactArcSummary: View {
    let arc: Arc
    let progress: Double
    let nextQuests: [Quest]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Arc", systemImage: "map")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption2.weight(.bold))
            }

            Text(arc.title)
                .font(.subheadline.weight(.semibold))
            Text(arc.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)

            if !nextQuests.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Volgende quest")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text(nextQuests.first?.title ?? "")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Daily Briefing

struct DailyBriefingCard: View {
    @EnvironmentObject var model: AppModel
    let affirmation: String
    let ritual: String
    let focusHeadline: String
    let nextUnlock: String
    let streak: Int
    let defaultExpanded: Bool

    @State private var isExpanded: Bool

    init(affirmation: String, ritual: String, focusHeadline: String, nextUnlock: String, streak: Int, defaultExpanded: Bool) {
        self.affirmation = affirmation
        self.ritual = ritual
        self.focusHeadline = focusHeadline
        self.nextUnlock = nextUnlock
        self.streak = streak
        self.defaultExpanded = defaultExpanded
        _isExpanded = State(initialValue: defaultExpanded)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Briefing")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text(affirmation)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Circle().fill(Color(.systemGray6)))
                }
                .buttonStyle(.plain)
            }

            if streak > 0 {
                HStack(spacing: 10) {
                    Image(systemName: "flame")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak) day streak")
                            .font(.caption.weight(.medium))
                        Text(focusHeadline)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }

            if isExpanded {
                Divider()

                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Ritual van vandaag", systemImage: "sparkles")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                        Text(ritual)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Volgende unlock", systemImage: "lock.open")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                        Text(nextUnlock)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                if let weakest = model.lowestDimension {
                    Divider()
                    HStack(spacing: 10) {
                        Image(systemName: weakest.systemImage)
                            .foregroundColor(.accentColor)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Focus drop: \(weakest.label)")
                                .font(.subheadline.weight(.semibold))
                            Text("Pak één quest uit deze stat voor snelle XP.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .brandCard(cornerRadius: 22)
    }
}

// MARK: - Suggestion Card

struct SuggestionCardView: View {
    let pack: CategoryPack
    let item: ChecklistItem
    
    var body: some View {
        let accent = Color(hex: pack.accentColorHex, default: .accentColor)
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("Today’s focus")
                    .font(.subheadline.weight(.semibold))
                Image(systemName: "arrow.right")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accent.opacity(0.18))
                    Image(systemName: pack.iconSystemName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(accent)
                }
                .frame(width: 56, height: 56)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                    
                    if let detail = item.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    
                    HStack(spacing: 8) {
                        Text(pack.title)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(accent.opacity(0.14))
                            )
                            .foregroundColor(accent)
                        
                        Text("\(item.xp) XP")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(Color(.systemGray6))
                            )
                        
                        if item.isPremium {
                            Text("PRO")
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule().fill(Color.yellow.opacity(0.18))
                                )
                        }
                    }
                }
                
                Spacer()
            }
            
            Text("Tap om deze task in de pack te openen.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .brandCard(cornerRadius: 22)
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    let progress: Double

    var body: some View {
        let clamped = max(0, min(progress, 1))
        ZStack {
            Circle()
                .stroke(
                    Color(.systemGray5),
                    lineWidth: 14
                )

            Circle()
                .trim(from: 0, to: CGFloat(clamped))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            BrandTheme.accent,
                            BrandTheme.accentSoft,
                            BrandTheme.waveDeep,
                            BrandTheme.accent
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)
            
            VStack(spacing: 4) {
                Text("\(Int(clamped * 100))")
                    .font(.title.bold())
                Text("%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(clamped * 100))% complete")
    }
}

// MARK: - Dimension Row

struct DimensionRow: View {
    @EnvironmentObject var model: AppModel
    let dimension: LifeDimension
    
    private var ratio: Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label {
                    Text(dimension.label)
                        .font(.subheadline.weight(.medium))
                } icon: {
                    Image(systemName: dimension.systemImage)
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(model.xp(for: dimension)) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(BrandTheme.waveDeep.opacity(0.28))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                BrandTheme.accent,
                                BrandTheme.accentSoft.opacity(0.75)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, ratio)))))
                        .animation(.easeInOut(duration: 0.6), value: ratio)
                }
            }
            .frame(height: 10)
        }
    }
}

// MARK: - Quick Action row

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(BrandTheme.accent.opacity(0.14))
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(BrandTheme.accent)
            }
            .frame(width: 52, height: 52)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(BrandTheme.accent.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

// MARK: - Momentum Grid & Micro Wins

struct MomentumGrid: View {
    @EnvironmentObject var model: AppModel
    let rankings: [(dimension: LifeDimension, ratio: Double, earned: Int, total: Int)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Momentum board")
                    .font(.headline)
                Spacer()
                if model.dimensionBalanceScore > 0 {
                    Label("\(model.dimensionBalanceScore)% balance", systemImage: "gyroscope")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.accentColor.opacity(0.12)))
                }
            }

            Text("Zie in één oogopslag welke stats dominant zijn en waar je XP laat liggen.")
                .font(.caption)
                .foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(rankings, id: \.dimension) { entry in
                    MomentumTile(entry: entry)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct MomentumTile: View {
    let entry: (dimension: LifeDimension, ratio: Double, earned: Int, total: Int)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(entry.dimension.label, systemImage: entry.dimension.systemImage)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(entry.ratio * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.accentColor)
            }

            ProgressView(value: entry.ratio)
                .progressViewStyle(.linear)

            HStack {
                Text("\(entry.earned) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(entry.total) max")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct EnergyCheckCard: View {
    @EnvironmentObject var model: AppModel
    let headline: String
    let prompts: [String]
    let remaining: Int
    let defaultExpanded: Bool

    @State private var isExpanded: Bool

    init(headline: String, prompts: [String], remaining: Int, defaultExpanded: Bool) {
        self.headline = headline
        self.prompts = prompts
        self.remaining = remaining
        self.defaultExpanded = defaultExpanded
        _isExpanded = State(initialValue: defaultExpanded)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Energy check-in")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text(headline)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.accentColor)
                        .padding(8)
                        .background(Circle().fill(Color(.systemGray6)))
                }
                .buttonStyle(.plain)
            }

            if isExpanded {
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Snelle resets")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)

                    ForEach(prompts.prefix(3), id: \.self) { prompt in
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle.magnifyingglass")
                                .foregroundColor(.accentColor)
                            Text(prompt)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                if !model.microWins.isEmpty {
                    Divider()
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                        Text("Micro win klaarstaan: \(model.microWins.first?.title ?? "Pak de kleinste taak")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }

            HStack {
                Label("\(remaining) open quests", systemImage: "list.star")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.accentColor)
                Spacer()
                Text(isExpanded ? "Klap in" : "Bekijk prompts")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 8, y: 3)
        .onAppear {
            isExpanded = model.expandHomeCardsByDefault
        }
    }
}

struct WeeklyBlueprintCard: View {
    let steps: [AppModel.BlueprintStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly blueprint")
                    .font(.headline)
                Spacer()
                Text("Tiny rituals")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.accentColor.opacity(0.14)))
            }

            Text("Gebruik deze 3 micro moves om momentum te starten.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(steps) { step in
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.accentColor.opacity(0.12))
                            Image(systemName: step.icon)
                                .foregroundColor(.accentColor)
                        }
                        .frame(width: 44, height: 44)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.title)
                                .font(.subheadline.weight(.semibold))
                            Text(step.detail)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct FocusPlaylistCard: View {
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Focus playlist")
                    .font(.headline)
                Spacer()
                Text("4 quests")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.accentColor.opacity(0.14)))
            }

            Text("Snelle selectie om vandaag doorheen te tikken.")
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(items) { item in
                HStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                        if let detail = item.detail {
                            Text(detail)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    Spacer()
                    Text("\(item.xp) XP")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color(.systemGray6)))
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}

struct BoosterCarousel: View {
    let boosterPacks: [(pack: CategoryPack, remaining: Int, progress: Double)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Booster packs")
                    .font(.headline)
                Spacer()
                Text("Sluit een pack af voor dopamine")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(boosterPacks.prefix(4)).indices, id: \.self) { index in
                        let entry = boosterPacks[index]
                        let accent = Color(hex: entry.pack.accentColorHex, default: .accentColor)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: entry.pack.iconSystemName)
                                    .foregroundColor(accent)
                                Text(entry.pack.title)
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                            }

                            HStack {
                                Text("\(Int(entry.progress * 100))%")
                                    .font(.caption.weight(.medium))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(accent.opacity(0.16)))
                                    .foregroundColor(accent)
                                Text("Nog \(entry.remaining) quests")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(accent)
                                        .frame(width: max(10, geo.size.width * CGFloat(min(1, max(0, entry.progress)))))
                                }
                            }
                            .frame(height: 10)
                        }
                        .padding()
                        .frame(width: 220)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct MicroWinsCard: View {
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Micro wins")
                    .font(.headline)
                Spacer()
                Text("Snelle dopamine hits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Pak iets kleins en claim momentum binnen 5 minuten.")
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(items) { item in
                MicroWinRow(item: item)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}

struct MicroWinRow: View {
    let item: ChecklistItem

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bolt.fill")
                .foregroundColor(.yellow)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                if let detail = item.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Text("\(item.xp) XP")
                .font(.caption.weight(.medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color(.systemGray6)))
        }
    }
}

// MARK: - Level + Focus Cards

struct LevelCard: View {
    @EnvironmentObject var model: AppModel
    let level: Int
    let progress: Double
    let xpToNext: Int
    let nextUnlock: String

    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(level)")
                        .font(.headline)
                    Text("XP to next: \(xpToNext)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
                        .foregroundColor(.accentColor)
                        .padding(10)
                        .background(Circle().fill(Color(.systemGray6)))
                }
                .buttonStyle(.plain)
            }

            if isExpanded {
                ProgressRing(progress: progress)
                    .frame(width: 80, height: 80)

                Text(nextUnlock)
                    .font(.footnote)
                    .foregroundColor(.secondary)

                if model.currentStreak > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "flame")
                        Text("Momentum: \(model.currentStreak)-day streak")
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}

struct FocusDimensionCard: View {
    let dimension: LifeDimension
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(dimension.label, systemImage: dimension.systemImage)
                    .font(.headline)
                Spacer()
                Text("Focus drop")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Je zwakste stat. Pak 1 ding en claim die XP.")
                .font(.footnote)
                .foregroundColor(.secondary)

            ForEach(items) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 10, height: 10)
                        .padding(.top, 6)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))

                        if let detail = item.detail {
                            Text(detail)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }

                    Spacer()

                    Text("\(item.xp) XP")
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(Color(.systemGray6))
                        )
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct SeasonalSpotlightCard: View {
    let theme: SpotlightTheme
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: theme.iconSystemName)
                    .font(.headline)
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.title)
                        .font(.headline)
                    Text(theme.description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("Season drop")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.accentColor.opacity(0.16)))
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(items) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.accentColor)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.subheadline.weight(.semibold))
                            if let detail = item.detail {
                                Text(detail)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        Spacer()
                        Text("\(item.xp) XP")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color(.systemGray6)))
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 10, y: 4)
    }
}

struct LegendaryQuestCard: View {
    let pack: CategoryPack
    let item: ChecklistItem

    var body: some View {
        let accent = Color(hex: pack.accentColorHex, default: .accentColor)

        VStack(alignment: .leading, spacing: 10) {
            HStack { 
                Label("Boss fight", systemImage: "bolt.circle.fill")
                    .font(.headline)
                Spacer()
                Text("High XP")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange.opacity(0.15)))
                    .foregroundColor(.orange)
            }

            Text(item.title)
                .font(.title3.weight(.semibold))
            if let detail = item.detail {
                Text(detail)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: pack.iconSystemName)
                    Text(pack.title)
                        .font(.caption.weight(.semibold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(accent.opacity(0.16)))
                .foregroundColor(accent)

                Text("\(item.xp) XP")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(.systemGray6)))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}
