import SwiftUI

struct ArcsView: View {
    @EnvironmentObject var model: AppModel

    private var currentArc: Arc? { model.activeArc }
    private var suggestions: [Arc] { model.suggestedArcs }
    private var questBoard: (arc: Arc?, quests: [Quest]) { model.nextQuestBoard(limit: 3) }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                ScrollView {
                    VStack(spacing: 16) {
                    if let arc = currentArc {
                        ArcHeroCard(arc: arc)
                            .transition(.scale.combined(with: .opacity))
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

        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(accent.opacity(0.16))
                    Image(systemName: arc.iconSystemName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(accent)
                }
                .frame(width: 70, height: 70)

                VStack(alignment: .leading, spacing: 6) {
                    Text(arc.title)
                        .font(.title3.bold())
                    Text(arc.subtitle)
                        .font(.subheadline)
                        .foregroundColor(BrandTheme.mutedText)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 6) {
                        ForEach(arc.focusDimensions) { dim in
                            Label(dim.label, systemImage: dim.systemImage)
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(accent.opacity(0.14)))
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                }

                Spacer()
            }

            ProgressView(value: progress) {
                Text("\(Int(progress * 100))% • \(arc.chapters.count) chapters")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            .tint(accent)

            if let day = day {
                Label("Dag \(day) sinds start", systemImage: "clock.arrow.circlepath")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(BrandTheme.accent)
            }

            if !next.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                Text("Volgende quests")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(BrandTheme.mutedText)
                ForEach(next) { quest in
                    QuestRow(quest: quest, accent: accent)
                }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Chapters")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(BrandTheme.mutedText)

                VStack(spacing: 8) {
                    ForEach(arc.chapters) { chapter in
                        ChapterProgressRow(
                            title: chapter.title,
                            summary: chapter.summary,
                            progress: model.chapterProgress(chapter),
                            accent: accent
                        )
                    }
                }
            }

            HStack(spacing: 10) {
                NavigationLink(destination: ArcDetailView(arc: arc)) {
                    Text("Open arc")
                        .font(.footnote.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(accent.opacity(0.16))
                        .foregroundColor(accent)
                        .clipShape(Capsule())
                }

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
            }
        }
        .brandCard(cornerRadius: 22)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(summary)
                .font(.caption)
                .foregroundColor(.secondary)
            ProgressView(value: progress)
                .tint(accent)
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
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct QuestRow: View {
    @EnvironmentObject var model: AppModel
    let quest: Quest
    let accent: Color

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                model.toggle(quest)
            }
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: model.isCompleted(quest) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(model.isCompleted(quest) ? accent : Color(.systemGray4))
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(quest.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        Label(quest.kind.label, systemImage: quest.kind.systemImage)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(accent.opacity(0.14)))
                            .foregroundColor(accent)
                    }

                    if let detail = quest.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 8) {
                        Text("\(quest.xp) XP")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(accent.opacity(0.12)))
                            .foregroundColor(accent)

                        if let minutes = quest.estimatedMinutes {
                            Label("\(minutes) min", systemImage: "clock")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color(.systemGray6)))
                        }

                        ForEach(quest.dimensions) { dim in
                            Label(dim.label, systemImage: dim.systemImage)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color(.systemGray6)))
                        }
                    }

                    Text(quest.kind.guidance)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .contentShape(Rectangle())
        }
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
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(accent.opacity(0.15))
                            Image(systemName: arc.iconSystemName)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(accent)
                        }
                        .frame(width: 70, height: 70)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(arc.title)
                                .font(.title2.bold())
                            Text(arc.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)

                            ProgressView(value: progress)
                                .tint(accent)

                            Text("\(Int(progress * 100))% voltooid • \(arc.questCount) quests")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack(spacing: 10) {
                        Button {
                            model.startArcIfNeeded(arc)
                        } label: {
                            Label(model.arcStartDates[arc.id] == nil ? "Start arc" : "Ga verder", systemImage: "play.fill")
                                .font(.footnote.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(accent.opacity(0.18)))
                        }
                        .buttonStyle(.plain)

                        if let day = model.arcDay(for: arc) {
                            Text("Live dag \(day)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    if !arc.focusDimensions.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(arc.focusDimensions) { dim in
                                HStack(spacing: 4) {
                                    Image(systemName: dim.systemImage)
                                    Text(dim.label)
                                }
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule().fill(Color(.systemGray6))
                                )
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(chapter.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(chapter.summary)
                .font(.caption)
                .foregroundColor(.secondary)
            ProgressView(value: progress)
                .tint(accent)
        }
    }
}

// MARK: - Tools

struct ToolsPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tools")
                .font(.headline)

            NavigationLink(destination: ChallengeView()) {
                Label("Weekend Challenge", systemImage: "flag.checkered")
            }

            NavigationLink(destination: BadgesView()) {
                Label("Badges", systemImage: "rosette")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
