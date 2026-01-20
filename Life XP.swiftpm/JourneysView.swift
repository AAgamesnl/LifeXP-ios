import SwiftUI

// MARK: - Arcs View

struct ArcsView: View {
    @Environment(AppModel.self) private var model
    @State private var showHero = false
    @State private var pendingArcToStart: Arc?
    @State private var showArcLimitDialog = false

    private var currentArc: Arc? { model.activeArc }
    private var activeArcs: [Arc] { model.activeArcs }
    private var suggestions: [Arc] { model.suggestedArcs }
    private var questBoard: (arc: Arc?, quests: [Quest]) { model.nextQuestBoard(limit: model.questBoardLimit) }

    private func attemptStartArc(_ arc: Arc) {
        let wasActive = model.arcStartDates[arc.id] != nil
        if model.startArcIfNeeded(arc), !wasActive {
            HapticsEngine.softCelebrate()
            model.soundManager.play(.celebration)
        } else if !wasActive && model.remainingArcSlots == 0 {
            pendingArcToStart = arc
            showArcLimitDialog = true
        }
    }

    private func swapArc(_ arcToStop: Arc, with arcToStart: Arc) {
        model.resetArcStart(arcToStop)
        if model.startArcIfNeeded(arcToStart) {
            HapticsEngine.lightImpact()
        }
        pendingArcToStart = nil
    }

    var body: some View {
        NavigationStack {
            ScreenBackground {
                ScrollView {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        StoryModeHeader()

                        // Current Arc Hero
                        if let arc = currentArc {
                            ArcHeroCard2(
                                arc: arc,
                                startAction: attemptStartArc,
                                stopAction: { model.resetArcStart($0) }
                            )
                            .opacity(showHero ? 1 : 0)
                            .offset(y: showHero ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showHero)
                        } else {
                            ArcEmptyState2(suggestions: suggestions, startAction: attemptStartArc)
                        }

                        // Active Arcs
                        if !activeArcs.isEmpty && activeArcs.count > 1 {
                            ActiveArcsSection2(arcs: activeArcs.filter { $0.id != currentArc?.id }, startAction: attemptStartArc)
                        }

                        // Next Quests
                        if let arc = questBoard.arc, !questBoard.quests.isEmpty {
                            QuestBoardSection(arc: arc, quests: questBoard.quests)
                        }

                        // Suggested Arcs
                        if !suggestions.isEmpty {
                            SuggestedArcsSection(suggestions: suggestions.filter { $0.id != currentArc?.id }, startAction: attemptStartArc)
                        }

                        // All Arcs
                        AllArcsSection(startAction: attemptStartArc)

                        // Tools
                        ToolsSection()

                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
                .trackScrollActivity()
            }
            .navigationTitle(L10n.storyModeTitle)
            .onAppear {
                showHero = true
            }
            .confirmationDialog(
                "Choose an arc to pause",
                isPresented: $showArcLimitDialog,
                presenting: pendingArcToStart
            ) { pending in
                Button("Cancel", role: .cancel) { pendingArcToStart = nil }
                ForEach(activeArcs) { active in
                    Button(role: .destructive) {
                        swapArc(active, with: pending)
                    } label: {
                        Text("Stop \(active.title) and start \(pending.title)")
                    }
                }
            } message: { pending in
                Text("You have \(model.settings.maxConcurrentArcs) active arcs. Choose which one to pause to start \(pending.title).")
            }
        }
    }
}

// MARK: - Story Mode Header

struct StoryModeHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            Text(L10n.storyModeTitle)
                .font(DesignSystem.text.headlineLarge)
                .foregroundColor(BrandTheme.textPrimary)

            Text(L10n.storyModeSubtitle)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Arc Hero Card 2.0

struct ArcHeroCard2: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: ((Arc) -> Void)?
    var stopAction: ((Arc) -> Void)?

    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var isActive: Bool { model.arcStartDates[arc.id] != nil && progress < 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            // Header
            HStack(alignment: .top, spacing: DesignSystem.spacing.lg) {
                IconContainer(systemName: arc.iconSystemName, color: accent, size: .hero, style: progress >= 1 ? .gradient : .soft)

                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    // Status chips
                    HStack(spacing: DesignSystem.spacing.sm) {
                        if isActive {
                            ChipView(text: "Active", icon: "dot.radiowaves.left.and.right", color: BrandTheme.success, size: .small)
                        } else if progress >= 1 {
                            ChipView(text: "Completed", icon: "checkmark.seal.fill", color: accent, size: .small)
                        }
                        
                        if let day = model.arcDay(for: arc) {
                            ChipView(text: "Day \(day)", icon: "calendar", color: BrandTheme.mutedText, size: .small)
                        }
                    }
                    
                    Text(arc.title)
                        .font(DesignSystem.text.headlineLarge)
                        .foregroundColor(BrandTheme.textPrimary)

                    Text(arc.subtitle)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(2)
                    
                    // Dimension tags
                    if !arc.focusDimensions.isEmpty {
                        HStack(spacing: DesignSystem.spacing.xs) {
                            ForEach(arc.focusDimensions) { dim in
                                ChipView(text: dim.label, icon: dim.systemImage, color: BrandTheme.dimensionColor(dim), size: .small)
                            }
                        }
                    }
                }

                Spacer()
            }

            // Progress section
            VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                HStack {
                    Text("\(Int(progress * 100))% complete")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(arc.chapters.count) chapters • \(arc.questCount) quests")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                AnimatedProgressBar(progress: progress, height: 10, cornerRadius: 5, color: accent, showGlow: true)
            }

            // Chapter progress
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                Text("Chapters")
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.mutedText)

                ForEach(arc.chapters) { chapter in
                    ChapterRow(chapter: chapter, accent: accent)
                }
            }

            // Next quests
            let nextQuests = model.nextQuests(in: arc, limit: 3)
            if !nextQuests.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    Text("Next Quests")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.mutedText)

                    ForEach(nextQuests) { quest in
                        QuestRowCompact(quest: quest, accent: accent)
                    }
                }
            }

            // Action buttons
            HStack(spacing: DesignSystem.spacing.md) {
                NavigationLink(destination: ArcDetailView(arc: arc)) {
                    Text("View Details")
                }
                .buttonStyle(SoftButtonStyle(color: accent))
                
                if !isActive && progress < 1 {
                    Button {
                        startAction?(arc)
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Arc")
                        }
                    }
                    .buttonStyle(GlowButtonStyle(color: accent, size: .medium))
                    .disabled(!model.canStartArc(arc))
                }
                
                if isActive || progress >= 1 {
                    Button {
                        stopAction?(arc)
                    } label: {
                        Text(progress >= 1 ? "Reset" : "Stop")
                    }
                    .buttonStyle(GhostButtonStyle(color: BrandTheme.error))
                }
            }
        }
        .elevatedCard(accentColor: accent)
    }
}

// MARK: - Chapter Row

struct ChapterRow: View {
    @Environment(AppModel.self) private var model
    let chapter: Chapter
    let accent: Color
    
    private var progress: Double { model.chapterProgress(chapter) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack {
                if progress >= 1 {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(BrandTheme.success)
                } else {
                    Circle()
                        .strokeBorder(BrandTheme.borderSubtle, lineWidth: 2)
                        .frame(width: 14, height: 14)
                }
                
                Text(chapter.title)
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(progress >= 1 ? BrandTheme.mutedText : BrandTheme.textPrimary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            AnimatedProgressBar(progress: progress, height: 4, color: accent)
        }
        .padding(DesignSystem.spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Quest Row Compact

struct QuestRowCompact: View {
    @Environment(AppModel.self) private var model
    let quest: Quest
    let accent: Color
    
    private var isCompleted: Bool { model.isCompleted(quest) }
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                model.toggle(quest)
            }
            if !isCompleted {
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
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(quest.title)
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(isCompleted ? BrandTheme.mutedText : BrandTheme.textPrimary)
                        .strikethrough(isCompleted)
                        .lineLimit(1)
                    
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Label(quest.kind.label, systemImage: quest.kind.systemImage)
                            .font(.caption2)
                            .foregroundColor(accent)
                        
                        if let minutes = quest.estimatedMinutes {
                            Text("~\(minutes) min")
                                .font(.caption2)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                }
                
                Spacer()
                
                XPChip(xp: quest.xp, size: .small)
            }
            .padding(DesignSystem.spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                    .fill(isCompleted ? BrandTheme.cardBackgroundElevated.opacity(0.3) : BrandTheme.cardBackgroundElevated.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Arc Empty State 2.0

struct ArcEmptyState2: View {
    @Environment(AppModel.self) private var model
    let suggestions: [Arc]
    var startAction: ((Arc) -> Void)?

    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            IconContainer(systemName: "map", color: BrandTheme.mutedText, size: .hero, style: .soft)
            
            VStack(spacing: DesignSystem.spacing.sm) {
                Text("No Arc Active")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text("Start an arc to begin a guided journey. Pick one that matches your weakest dimension.")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .multilineTextAlignment(.center)
            }
            
            if let first = suggestions.first {
                Button {
                    startAction?(first)
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start \(first.title)")
                    }
                }
                .buttonStyle(GlowButtonStyle(size: .medium))
                .disabled(model.remainingArcSlots == 0)
            }
        }
        .brandCard()
    }
}

// MARK: - Active Arcs Section 2.0

struct ActiveArcsSection2: View {
    let arcs: [Arc]
    var startAction: ((Arc) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text(L10n.storyModeActive)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)

                Spacer()

                ChipView(text: "Live", icon: "dot.radiowaves.left.and.right", color: BrandTheme.success, size: .small)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.spacing.md) {
                    ForEach(arcs) { arc in
                        NavigationLink(destination: ArcDetailView(arc: arc)) {
                            ArcStoryCard(arc: arc, startAction: startAction)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Next Quests Section

struct QuestBoardSection: View {
    @Environment(AppModel.self) private var model
    let arc: Arc?
    let quests: [Quest]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: "list.bullet.clipboard", color: BrandTheme.accent, size: .small, style: .soft)
                
                Text(L10n.arcsNextQuestsTitle)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                if let arc = arc {
                    Text(arc.title)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }

            if quests.isEmpty {
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "info.circle")
                        .foregroundColor(BrandTheme.info)
                    
                    Text("Start an arc to see your quests here. We'll show your next best actions.")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                        .fill(BrandTheme.info.opacity(0.1))
                )
            } else {
                let accent = Color(hex: arc?.accentColorHex ?? "", default: BrandTheme.accent)
                ForEach(quests) { quest in
                    QuestRow2(quest: quest, accent: accent)
                }
            }
        }
        .brandCard()
    }
}

// MARK: - Quest Row 2.0

struct QuestRow2: View {
    @Environment(AppModel.self) private var model
    let quest: Quest
    let accent: Color
    
    @State private var isAnimating = false
    
    private var isCompleted: Bool { model.isCompleted(quest) }

    var body: some View {
        Button {
            let willComplete = !isCompleted
            
            // Snappy checkbox bounce
            withAnimation(.spring(response: 0.25, dampingFraction: 0.75, blendDuration: 0.05)) {
                isAnimating = true
            }
            
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.1)) {
                model.toggle(quest)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.85)) {
                    isAnimating = false
                }
            }
            
            if willComplete {
                HapticsEngine.lightImpact()
            }
        } label: {
            HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isCompleted ? accent : BrandTheme.borderSubtle, lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        Circle()
                            .fill(accent)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isAnimating ? 1.2 : 1)

                // Content
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Text(quest.title)
                            .font(DesignSystem.text.labelLarge)
                            .foregroundColor(isCompleted ? BrandTheme.mutedText : BrandTheme.textPrimary)
                            .strikethrough(isCompleted)
                        
                        ChipView(text: quest.kind.label, icon: quest.kind.systemImage, color: accent, size: .small)
                    }

                    if let detail = quest.detail {
                        Text(detail)
                            .font(DesignSystem.text.bodySmall)
                            .foregroundColor(BrandTheme.mutedText)
                            .lineLimit(2)
                    }

                    HStack(spacing: DesignSystem.spacing.sm) {
                        XPChip(xp: quest.xp, size: .small)
                        
                        if let minutes = quest.estimatedMinutes {
                            ChipView(text: "~\(minutes) min", icon: "clock", color: BrandTheme.mutedText, size: .small)
                        }
                        
                        ForEach(quest.dimensions.prefix(2)) { dim in
                            ChipView(text: dim.label, icon: dim.systemImage, color: BrandTheme.dimensionColor(dim), size: .small)
                        }
                    }
                    
                    // Guidance
                    Text(quest.kind.guidance)
                        .font(.caption2)
                        .foregroundColor(BrandTheme.textTertiary)
                        .italic()
                }

                Spacer()
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(isCompleted ? BrandTheme.cardBackgroundElevated.opacity(0.5) : BrandTheme.cardBackground.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .strokeBorder(isCompleted ? accent.opacity(0.3) : BrandTheme.borderSubtle.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Suggested Arcs Section

struct SuggestedArcsSection: View {
    @Environment(AppModel.self) private var model
    let suggestions: [Arc]
    var startAction: ((Arc) -> Void)?

    var body: some View {
        if !suggestions.isEmpty {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                HStack {
                    Text(L10n.storyModeSuggested)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Spacer()
                    
                    if let weak = model.lowestDimension {
                        ChipView(text: "\(weak.label) boost", icon: weak.systemImage, color: BrandTheme.dimensionColor(weak), size: .small)
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.spacing.md) {
                        ForEach(suggestions.prefix(6)) { arc in
                            NavigationLink(destination: ArcDetailView(arc: arc)) {
                                ArcStoryCard(arc: arc, startAction: startAction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

// MARK: - Arc Tile 2.0

struct ArcTile2: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: ((Arc) -> Void)?

    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var isActive: Bool { model.arcStartDates[arc.id] != nil && progress < 1 }

    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: arc.iconSystemName, color: accent, size: .medium, style: .soft)

            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                HStack {
                    Text(arc.title)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if isActive {
                        ChipView(text: "Live", color: BrandTheme.success, size: .small)
                    }
                    
                    if progress >= 1 {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(BrandTheme.success)
                    }
                }
                
                Text(arc.subtitle)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(1)

                HStack(spacing: DesignSystem.spacing.sm) {
                    AnimatedProgressBar(progress: progress, height: 4, color: accent)
                        .frame(maxWidth: 100)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }

            Spacer()

            Button {
                startAction?(arc)
            } label: {
                Text(isActive ? "Live" : "Start")
            }
            .buttonStyle(SoftButtonStyle(color: accent))
            .disabled(isActive || progress >= 1)
        }
        .subtleCard()
    }
}

// MARK: - Arc Story Card

struct ArcStoryCard: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: ((Arc) -> Void)?

    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var isActive: Bool { model.arcStartDates[arc.id] != nil && progress < 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: arc.iconSystemName, color: accent, size: .small, style: .gradient)

                Spacer()

                if isActive {
                    ChipView(text: String(localized: "status.live", bundle: .module), icon: "dot.radiowaves.left.and.right", color: BrandTheme.success, size: .small)
                } else if progress >= 1 {
                    ChipView(text: String(localized: "status.completed", bundle: .module), icon: "checkmark.seal.fill", color: accent, size: .small)
                }
            }

            Text(arc.title)
                .font(DesignSystem.text.headlineSmall)
                .foregroundColor(BrandTheme.textPrimary)
                .lineLimit(2)

            Text(arc.subtitle)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
                .lineLimit(2)

            AnimatedProgressBar(progress: progress, height: 8, color: accent)

            Text(String(format: String(localized: "progress.percentComplete", bundle: .module), Int(progress * 100)))
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(width: 240, alignment: .leading)
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackground.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .strokeBorder(accent.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - All Arcs Section

struct AllArcsSection: View {
    @Environment(AppModel.self) private var model
    var startAction: ((Arc) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text(L10n.storyModeLibrary)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)

                Spacer()

                Text("\(model.visibleArcs.count) arcs")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.spacing.md) {
                    ForEach(model.visibleArcs) { arc in
                    NavigationLink(destination: ArcDetailView(arc: arc)) {
                        ArcStoryCard(arc: arc, startAction: startAction)
                    }
                    .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Tools Section

struct ToolsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Tools")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)

            NavigationLink(destination: ChallengeView()) {
                QuickActionRow2(
                    icon: "flag.checkered",
                    title: "Weekend Challenge",
                    subtitle: "Get a curated challenge mix",
                    color: BrandTheme.warning
                )
            }
            .buttonStyle(CardButtonStyle())

            NavigationLink(destination: BadgesView()) {
                QuickActionRow2(
                    icon: "rosette",
                    title: "Badges",
                    subtitle: "View your achievements",
                    color: BrandTheme.accent
                )
            }
            .buttonStyle(CardButtonStyle())
        }
    }
}

// MARK: - Arc Detail View

struct ArcDetailView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let arc: Arc
    
    @State private var pendingArcToStart: Arc?
    @State private var showArcLimitDialog = false
    @State private var showStartCelebration = false

    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var isActive: Bool { model.arcStartDates[arc.id] != nil && progress < 1 }

    private func attemptStartArc() {
        let wasActive = model.arcStartDates[arc.id] != nil
        if model.startArcIfNeeded(arc), !wasActive {
            HapticsEngine.softCelebrate()
            model.soundManager.play(.celebration)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showStartCelebration = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showStartCelebration = false
                }
                dismiss()
            }
        } else if !wasActive && model.remainingArcSlots == 0 {
            pendingArcToStart = arc
            showArcLimitDialog = true
        }
    }

    private func swapArc(_ active: Arc) {
        model.resetArcStart(active)
        if model.startArcIfNeeded(arc) {
            HapticsEngine.lightImpact()
        }
        pendingArcToStart = nil
    }

    var body: some View {
        ZStack {
            BrandBackgroundStatic()
            
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Header
                    ArcDetailHeader(
                        arc: arc,
                        startAction: attemptStartArc,
                        stopAction: { model.resetArcStart(arc) }
                    )
                    
                    // Chapters
                    ForEach(arc.chapters) { chapter in
                        ChapterSection(chapter: chapter, accent: accent)
                    }
                    
                    Color.clear.frame(height: DesignSystem.spacing.xxl)
                }
                .padding(.horizontal, DesignSystem.spacing.lg)
            }
        }
        .overlay {
            if showStartCelebration {
                ArcStartCelebrationOverlay(arc: arc)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .navigationTitle(arc.title)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Max active arcs reached",
            isPresented: $showArcLimitDialog,
            presenting: pendingArcToStart
        ) { _ in
            Button("Cancel", role: .cancel) { pendingArcToStart = nil }
            ForEach(model.activeArcs) { active in
                Button(role: .destructive) {
                    swapArc(active)
                } label: {
                    Text("Stop \(active.title) and start \(arc.title)")
                }
            }
        } message: { _ in
            Text("You're at your limit of \(model.settings.maxConcurrentArcs) active arcs. Choose which one to pause.")
        }
    }
}

// MARK: - Arc Start Celebration Overlay

struct ArcStartCelebrationOverlay: View {
    let arc: Arc

    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0

    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            if showConfetti {
                ConfettiView(isActive: $showConfetti, particleCount: 35)
                    .transition(.opacity)
            }

            VStack(spacing: DesignSystem.spacing.sm) {
                IconContainer(systemName: arc.iconSystemName, color: accent, size: .hero, style: .gradient)

                Text("Arc Started!")
                    .font(DesignSystem.text.headlineLarge)
                    .foregroundColor(BrandTheme.textPrimary)

                Text("Great pick. Your next quests are ready.")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
            .padding(DesignSystem.spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackgroundElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(accent.opacity(0.4), lineWidth: 1)
            )
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            showConfetti = true
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                scale = 1
                opacity = 1
            }
        }
    }
}

// MARK: - Arc Detail Header

struct ArcDetailHeader: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: (() -> Void)?
    var stopAction: (() -> Void)?
    
    private var accent: Color { Color(hex: arc.accentColorHex, default: BrandTheme.accent) }
    private var progress: Double { model.arcProgress(arc) }
    private var isActive: Bool { model.arcStartDates[arc.id] != nil && progress < 1 }
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            HStack(alignment: .top, spacing: DesignSystem.spacing.lg) {
                IconContainer(systemName: arc.iconSystemName, color: accent, size: .hero, style: progress >= 1 ? .gradient : .soft)
                
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    HStack(spacing: DesignSystem.spacing.sm) {
                        if isActive {
                            ChipView(text: "Active", icon: "dot.radiowaves.left.and.right", color: BrandTheme.success, size: .small)
                        }
                        if let day = model.arcDay(for: arc) {
                            ChipView(text: "Day \(day)", icon: "calendar", color: BrandTheme.mutedText, size: .small)
                        }
                    }
                    
                    Text(arc.title)
                        .font(DesignSystem.text.headlineLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(arc.subtitle)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
            }
            
            // Progress
            VStack(spacing: DesignSystem.spacing.sm) {
                AnimatedProgressBar(progress: progress, height: 10, cornerRadius: 5, color: accent, showGlow: true)
                
                HStack {
                    Text("\(Int(progress * 100))% complete")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(accent)
                    
                    Spacer()
                    
                    Text("\(arc.questCount) quests • \(arc.totalXP) XP")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Dimensions
            if !arc.focusDimensions.isEmpty {
                HStack(spacing: DesignSystem.spacing.sm) {
                    ForEach(arc.focusDimensions) { dim in
                        ChipView(text: dim.label, icon: dim.systemImage, color: BrandTheme.dimensionColor(dim), size: .medium)
                    }
                    Spacer()
                }
            }
            
            // Actions
            HStack(spacing: DesignSystem.spacing.md) {
                if !isActive && progress < 1 {
                    Button {
                        startAction?()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Arc")
                        }
                    }
                    .buttonStyle(GlowButtonStyle(color: accent, size: .medium))
                    .disabled(!model.canStartArc(arc))
                }
                
                if isActive || progress >= 1 {
                    Button {
                        stopAction?()
                    } label: {
                        HStack {
                            Image(systemName: "stop.circle")
                            Text(progress >= 1 ? "Reset" : "Stop Arc")
                        }
                    }
                    .buttonStyle(SoftButtonStyle(color: BrandTheme.error))
                }
            }
        }
        .elevatedCard(accentColor: accent)
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Chapter Section

struct ChapterSection: View {
    @Environment(AppModel.self) private var model
    let chapter: Chapter
    let accent: Color
    
    private var progress: Double { model.chapterProgress(chapter) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack {
                        if progress >= 1 {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(BrandTheme.success)
                        }
                        
                        Text(chapter.title)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                    }
                    
                    Text(chapter.summary)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(accent)
            }
            
            AnimatedProgressBar(progress: progress, height: 6, color: accent)
            
            // Quests
            ForEach(chapter.quests) { quest in
                QuestRow2(quest: quest, accent: accent)
            }
        }
        .brandCard()
    }
}

// MARK: - Legacy Support

struct QuestRow: View {
    @Environment(AppModel.self) private var model
    let quest: Quest
    let accent: Color
    
    var body: some View {
        QuestRow2(quest: quest, accent: accent)
            .environment(model)
    }
}

struct ArcHeroCard: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: ((Arc) -> Void)?
    var stopAction: ((Arc) -> Void)?
    
    var body: some View {
        ArcHeroCard2(arc: arc, startAction: startAction, stopAction: stopAction)
            .environment(model)
    }
}

struct ArcEmptyState: View {
    @Environment(AppModel.self) private var model
    let suggestions: [Arc]
    var startAction: ((Arc) -> Void)?
    
    var body: some View {
        ArcEmptyState2(suggestions: suggestions, startAction: startAction)
            .environment(model)
    }
}

struct ActiveArcsSection: View {
    let arcs: [Arc]
    var startAction: ((Arc) -> Void)?
    
    var body: some View {
        ActiveArcsSection2(arcs: arcs, startAction: startAction)
    }
}

struct SuggestedArcsGrid: View {
    @Environment(AppModel.self) private var model
    let suggestions: [Arc]
    var startAction: ((Arc) -> Void)?
    
    var body: some View {
        SuggestedArcsSection(suggestions: suggestions, startAction: startAction)
            .environment(model)
    }
}

struct QuestBoardView: View {
    @Environment(AppModel.self) private var model
    let arc: Arc?
    let quests: [Quest]
    
    var body: some View {
        QuestBoardSection(arc: arc, quests: quests)
            .environment(model)
    }
}

struct ArcTile: View {
    @Environment(AppModel.self) private var model
    let arc: Arc
    var startAction: ((Arc) -> Void)?
    
    var body: some View {
        ArcTile2(arc: arc, startAction: startAction)
            .environment(model)
    }
}

struct ToolsPanel: View {
    var body: some View {
        ToolsSection()
    }
}

struct ChapterHeader: View {
    let chapter: Chapter
    let accent: Color
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack {
                Text(chapter.title)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            Text(chapter.summary)
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
            AnimatedProgressBar(progress: progress, height: 4, color: accent)
        }
    }
}

struct ChapterProgressRow: View {
    let title: String
    let summary: String
    let progress: Double
    let accent: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack {
                Text(title)
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(BrandTheme.textPrimary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(BrandTheme.mutedText)
            }
            Text(summary)
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
            AnimatedProgressBar(progress: progress, height: 4, color: accent)
        }
    }
}
