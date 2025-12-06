import SwiftUI

struct ArcsView: View {
    @EnvironmentObject var model: AppModel
    @State private var showHero = false

    private var currentArc: Arc? { model.activeArc }
    private var suggestions: [Arc] { model.suggestedArcs }
    private var questBoard: (arc: Arc?, quests: [Quest]) { model.nextQuestBoard(limit: model.questBoardLimit) }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        if let arc = currentArc {
                            ArcHeroCard(arc: arc)
                                .opacity(showHero ? 1 : 0)
                                .scaleEffect(showHero ? 1 : 0.96)
                                .animation(.easeOut(duration: 0.55), value: showHero)
                        } else {
                            ArcEmptyState(suggestions: suggestions)
                        }

                        SuggestedArcsGrid(suggestions: suggestions)

                        QuestBoardView(arc: questBoard.arc, quests: questBoard.quests)

                        ToolsPanel()
                    }
                    .padding()
                }
            }
            .navigationTitle("Arcs")
            .onAppear {
                withAnimation(.easeOut(duration: 0.55)) {
                    showHero = true
                }
            }
        }
    }
}

// MARK: - Arc hero

struct ArcHeroCard: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc

    private var accent: Color { Color(hex: arc.accentColorHex, default: .accentColor) }

    var body: some View {
        let progress = model.arcProgress(arc)
        let next = model.nextQuests(in: arc, limit: 2)
        let day = model.arcDay(for: arc)
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            HStack(alignment: .top, spacing: DesignSystem.spacing.lg) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(accent.opacity(0.16))
                    Image(systemName: arc.iconSystemName)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(accent)
                }
                .frame(width: 76, height: 76)

                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text(arc.title)
                        .font(DesignSystem.text.heroTitle)
                        .foregroundColor(BrandTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(arc.subtitle)
                        .font(.subheadline)
                        .foregroundColor(BrandTheme.mutedText)
                        .fixedSize(horizontal: false, vertical: true)

                    FlexibleLabelRow(items: arc.focusDimensions.map { ($0.label, $0.systemImage) }, accent: accent.opacity(0.14))
                }

                Spacer(minLength: DesignSystem.spacing.sm)
            }

            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                HStack {
                    Text("\(Int(progress * 100))% • \(arc.chapters.count) chapters")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                        .fixedSize()
                    Spacer()
                    if let day = day {
                        Label("Dag \(day)", systemImage: "clock.arrow.circlepath")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(accent)
                            .accessibilityLabel("Dag \(day) sinds start")
                    }
                }
                ProgressView(value: progress)
                    .tint(accent)
                    .animation(.easeInOut(duration: 0.45), value: progress)
            }

            if !next.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Volgende quests")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(BrandTheme.mutedText)
                    VStack(spacing: DesignSystem.spacing.sm) {
                        ForEach(next) { quest in
                            QuestRow(quest: quest, accent: accent)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                Text("Chapters")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(BrandTheme.mutedText)

                VStack(spacing: DesignSystem.spacing.sm) {
                    ForEach(arc.chapters) { chapter in
                        ChapterProgressRow(
                            title: chapter.title,
                            summary: chapter.summary,
                            progress: model.chapterProgress(chapter),
                            accent: accent
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Chapter \(chapter.title), \(Int(model.chapterProgress(chapter) * 100)) procent voltooid")
                    }
                }
            }

            HStack(spacing: DesignSystem.spacing.md) {
                let canStart = model.remainingArcSlots > 0 || model.arcStartDates[arc.id] != nil
                if model.arcStartDates[arc.id] == nil && model.remainingArcSlots == 0 {
                    Label("Max \(model.settings.maxConcurrentArcs) arcs actief", systemImage: "exclamationmark.triangle")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .fixedSize()
                }

                NavigationLink(destination: ArcDetailView(arc: arc)) {
                    Text("Open arc")
                        .font(.footnote.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(accent.opacity(0.16))
                        .foregroundColor(accent)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("Open arc \(arc.title)")

                Button {
                    model.startArcIfNeeded(arc)
                } label: {
                    Text(model.arcStartDates[arc.id] == nil ? "Start" : "Live")
                        .font(.footnote.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(accent.opacity(0.1)))
                }
                .buttonStyle(.plain)
                .disabled(!canStart)
                .accessibilityLabel(model.arcStartDates[arc.id] == nil ? "Start arc" : "Ga verder in arc")
                .accessibilityHint(canStart ? "Start of hervat arc" : "Maximum actieve arcs bereikt")
            }
        }
        .brandCard(cornerRadius: DesignSystem.radius.lg)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Arc \(arc.title)")
        .accessibilityHint("\(Int(progress * 100)) percent complete. Tap to view arc details or start it.")
    }
}

struct ChapterProgressRow: View {
    let title: String
    let summary: String
    let progress: Double
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: DesignSystem.spacing.sm)
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
            }
            Text(summary)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(value: progress)
                .tint(accent)
                .animation(.easeInOut(duration: 0.45), value: progress)
        }
    }
}

struct ArcEmptyState: View {
    @EnvironmentObject var model: AppModel
    let suggestions: [Arc]

    var body: some View {
        let accent = Color.accentColor
        VStack(alignment: .leading, spacing: 12) {
            Text("Geen arc actief")
                .font(.headline)
            Text("Kies een arc die past bij je zwakste dimensie, of start met de suggesties hieronder.")
                .font(.footnote)
                .foregroundColor(.secondary)
            if let first = suggestions.first {
                Button {
                    model.startArcIfNeeded(first)
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start \(first.title)")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(accent.opacity(0.14)))
                }
                .buttonStyle(.plain)
                .disabled(model.remainingArcSlots == 0)
            } else {
                Text("Geen suggesties gevonden. Voltooi eerst een paar checklist items zodat we kunnen adviseren.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Suggested arcs

struct SuggestedArcsGrid: View {
    @EnvironmentObject var model: AppModel
    let suggestions: [Arc]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Suggested arcs")
                    .font(.headline)
                Spacer()
                if let weak = model.lowestDimension {
                    Text("\(weak.label) boost")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if suggestions.isEmpty {
                Text("Geen suggesties beschikbaar. Probeer een paar quests of checklists te doen zodat we patronen zien.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(suggestions) { arc in
                        NavigationLink(destination: ArcDetailView(arc: arc)) {
                            ArcTile(arc: arc)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct ArcTile: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc

    var body: some View {
        let accent = Color(hex: arc.accentColorHex, default: .accentColor)
        let progress = model.arcProgress(arc)

        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent.opacity(0.14))
                Image(systemName: arc.iconSystemName)
                    .foregroundColor(accent)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text(arc.title)
                    .font(.subheadline.weight(.semibold))
                Text(arc.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    ProgressView(value: progress)
                        .tint(accent)
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                model.startArcIfNeeded(arc)
            } label: {
                Text(model.arcStartDates[arc.id] == nil ? "Start" : "Ga door")
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(accent.opacity(0.16)))
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Quest board

struct QuestBoardView: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc?
    let quests: [Quest]

    var body: some View {
        let accent = Color.accentColor
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Quest board")
                    .font(.headline)
                Spacer()
                if let arc = arc {
                    Text(arc.title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if quests.isEmpty {
                Text("Start een arc of open een chapter om je eerstvolgende quests te zien. We tonen hier automatisch acties uit je huidige arc, of de beste volgende stap uit een suggestie.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ForEach(quests) { quest in
                    QuestRow(quest: quest, accent: accent)
                }
            }
        }
        .brandCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Quest board")
        .accessibilityHint(quests.isEmpty ? "Geen quests beschikbaar" : "\(quests.count) quests weergegeven")
    }
}

struct QuestRow: View {
    @EnvironmentObject var model: AppModel
    let quest: Quest
    let accent: Color
    @State private var isBouncing = false

    var body: some View {
        Button {
            let willComplete = !model.isCompleted(quest)
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                model.toggle(quest)
            }
            if willComplete {
                HapticsEngine.lightImpact()
                withAnimation(.spring(response: 0.32, dampingFraction: 0.7)) { isBouncing = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    withAnimation(.easeOut(duration: 0.22)) { isBouncing = false }
                }
            }
        } label: {
            HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                Image(systemName: model.isCompleted(quest) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(model.isCompleted(quest) ? accent : Color(.systemGray4))
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack(alignment: .firstTextBaseline, spacing: DesignSystem.spacing.sm) {
                        Text(quest.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Label(quest.kind.label, systemImage: quest.kind.systemImage)
                            .font(.caption2)
                            .padding(.horizontal, DesignSystem.spacing.sm)
                            .padding(.vertical, DesignSystem.spacing.xs)
                            .background(Capsule().fill(accent.opacity(0.14)))
                            .foregroundColor(accent)
                            .accessibilityLabel("Type: \(quest.kind.label)")
                    }

                    if let detail = quest.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack(spacing: DesignSystem.spacing.sm) {
                        Text("\(quest.xp) XP")
                            .font(.caption2)
                            .padding(.horizontal, DesignSystem.spacing.sm)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(accent.opacity(0.12)))
                            .foregroundColor(accent)
                            .accessibilityLabel("\(quest.xp) XP")

                        if let minutes = quest.estimatedMinutes {
                            Label("\(minutes) min", systemImage: "clock")
                                .font(.caption2)
                                .padding(.horizontal, DesignSystem.spacing.sm)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color(.systemGray6)))
                                .accessibilityLabel("Tijd: \(minutes) minuten")
                        }

                        ForEach(quest.dimensions) { dim in
                            Label(dim.label, systemImage: dim.systemImage)
                                .font(.caption2)
                                .padding(.horizontal, DesignSystem.spacing.sm)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color(.systemGray6)))
                                .accessibilityLabel("Dimensie: \(dim.label)")
                        }
                    }

                    Text(quest.kind.guidance)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .scaleEffect(isBouncing ? 1.03 : 1.0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Quest: \(quest.title), \(quest.xp) XP")
        .accessibilityHint("Dubbel tik om te voltooien of markeer als openstaand")
    }
}

// MARK: - Arc detail

struct ArcDetailView: View {
    @EnvironmentObject var model: AppModel
    let arc: Arc

    var body: some View {
        let accent = Color(hex: arc.accentColorHex, default: .accentColor)
        let progress = model.arcProgress(arc)

        List {
            Section {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                    HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                .fill(accent.opacity(0.18))
                            Image(systemName: arc.iconSystemName)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(accent)
                        }
                        .frame(width: 82, height: 82)

                        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                            Text(arc.title)
                                .font(DesignSystem.text.heroTitle)
                                .foregroundColor(BrandTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(arc.subtitle)
                                .font(.subheadline)
                                .foregroundColor(BrandTheme.mutedText)
                                .fixedSize(horizontal: false, vertical: true)

                            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("\(Int(progress * 100))% voltooid • \(arc.questCount) quests")
                                        .font(.caption)
                                        .foregroundColor(BrandTheme.mutedText)
                                        .fixedSize()
                                    Spacer(minLength: DesignSystem.spacing.sm)
                                    if let day = model.arcDay(for: arc) {
                                        Label("Dag \(day)", systemImage: "clock")
                                            .font(.caption.weight(.semibold))
                                            .foregroundColor(accent)
                                            .accessibilityLabel("Live dag \(day)")
                                    }
                                }
                                ProgressView(value: progress)
                                    .tint(accent)
                                    .animation(.easeInOut(duration: 0.45), value: progress)
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(arc.title), \(Int(progress * 100)) procent, \(arc.questCount) quests")
                    }

                    if !arc.focusDimensions.isEmpty {
                        FlexibleLabelRow(items: arc.focusDimensions.map { ($0.label, $0.systemImage) }, accent: Color(.systemGray6))
                    }

                    HStack(spacing: DesignSystem.spacing.md) {
                        Button {
                            model.startArcIfNeeded(arc)
                        } label: {
                            Label(model.arcStartDates[arc.id] == nil ? "Start arc" : "Ga verder", systemImage: "play.fill")
                                .font(.footnote.weight(.semibold))
                                .padding(.horizontal, DesignSystem.spacing.md)
                                .padding(.vertical, DesignSystem.spacing.sm)
                                .background(Capsule().fill(accent.opacity(0.18)))
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint(model.arcStartDates[arc.id] == nil ? "Start deze arc" : "Ga verder in actieve arc")

                        if let day = model.arcDay(for: arc) {
                            Text("Live dag \(day)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Live dag \(day)")
                        }
                    }
                }
                .brandCard(cornerRadius: DesignSystem.radius.lg)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Arc overzicht voor \(arc.title)")
                .accessibilityHint("\(Int(progress * 100)) procent voltooid, \(arc.questCount) quests")
            }

            ForEach(arc.chapters) { chapter in
                Section(header: ChapterHeader(chapter: chapter, accent: accent, progress: model.chapterProgress(chapter))) {
                    ForEach(chapter.quests) { quest in
                        QuestRow(quest: quest, accent: accent)
                    }
                }
            }
        }
        .navigationTitle(arc.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChapterHeader: View {
    let chapter: Chapter
    let accent: Color
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            HStack(alignment: .firstTextBaseline) {
                Text(chapter.title)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: DesignSystem.spacing.sm)
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
            }
            Text(chapter.summary)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(value: progress)
                .tint(accent)
                .animation(.easeInOut(duration: 0.45), value: progress)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Chapter \(chapter.title) \(Int(progress * 100)) procent")
    }
}

// MARK: - Tools

struct ToolsPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            Text("Tools")
                .font(DesignSystem.text.sectionTitle)
                .foregroundColor(BrandTheme.textPrimary)

            VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                NavigationLink(destination: ChallengeView()) {
                    Label("Weekend Challenge", systemImage: "flag.checkered")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(BrandTheme.textPrimary)
                        .accessibilityHint("Open weekend challenge")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                .fill(BrandTheme.cardBackground.opacity(0.7))
                        )
                }

                NavigationLink(destination: BadgesView()) {
                    Label("Badges", systemImage: "rosette")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(BrandTheme.textPrimary)
                        .accessibilityHint("Bekijk je badges")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                .fill(BrandTheme.cardBackground.opacity(0.7))
                        )
                }
            }
        }
        .brandCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tools overzicht")
    }
}

private struct FlexibleLabelRow: View {
    let items: [(String, String)]
    let accent: Color

    var body: some View {
        FlexibleStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
            ForEach(items, id: \.0) { item in
                Label(item.0, systemImage: item.1)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, DesignSystem.spacing.sm)
                    .padding(.vertical, DesignSystem.spacing.xs)
                    .background(Capsule().fill(accent))
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
    }
}

private struct FlexibleStack<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: spacing)], alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
