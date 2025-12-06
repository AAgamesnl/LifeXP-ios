import SwiftUI

/// Lightweight tools and overviews that support the main Life XP flows.
struct ChallengeView: View {
    @EnvironmentObject var model: AppModel

    private var board: (arc: Arc?, quests: [Quest]) {
        model.nextQuestBoard(limit: 3)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()
                    .opacity(0.25)

                ScrollView {
                    VStack(spacing: 18) {
                        challengeHeader
                        arcChallengeSection
                        heroSection
                        microWinsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Weekend Challenge")
        }
    }

    private var challengeHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Fast track naar momentum", systemImage: "flag.checkered")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
            Text("We mixen je actieve arc met een hero quest en micro wins. Kies 1 grote + 1 kleine actie en claim die XP.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                streakChip
                xpChip
            }
        }
        .brandCard()
    }

    private var streakChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
            Text("\(model.currentStreak)-day streak")
        }
        .font(.caption.weight(.medium))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.orange.opacity(0.12)))
        .foregroundColor(.orange)
    }

    private var xpChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
            Text("\(model.totalXP) XP totaal")
        }
        .font(.caption.weight(.medium))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.accentColor.opacity(0.12)))
    }

    private var arcChallengeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Arc focus")
                    .font(.headline)
                Spacer()
                if let arc = board.arc {
                    Text(model.arcProgressHeadline)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if let arc = board.arc, !board.quests.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: arc.iconSystemName)
                            .foregroundColor(Color(hex: arc.accentColorHex, default: .accentColor))
                        VStack(alignment: .leading) {
                            Text(arc.title)
                                .font(.subheadline.weight(.semibold))
                            Text(arc.subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        Text("\(Int(model.arcProgress(arc) * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    ForEach(board.quests) { quest in
                        QuestSummaryRow(quest: quest, accent: Color(hex: arc.accentColorHex, default: .accentColor))
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Geen arc gekozen")
                        .font(.subheadline.weight(.semibold))
                    Text("Open de Arcs hub en kies een verhaal om te spelen. We tonen daarna automatisch je volgende quests hier.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .brandCard()
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Boss fight")
                    .font(.headline)
                Spacer()
                Text("Hoogste XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if model.heroQuests.isEmpty {
                Text("Claim eerst wat basis XP of kies een arc. Dan tonen we hier je drie zwaarste quests.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                VStack(spacing: 10) {
                    ForEach(model.heroQuests) { quest in
                        ChecklistSummaryRow(item: quest)
                    }
                }
            }
        }
    }

    private var microWinsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Micro wins")
                    .font(.headline)
                Spacer()
                Text("Dopamine snacks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if model.microWins.isEmpty {
                Text("Alles voltooid! Kies een arc of pak een boss fight om momentum te houden.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                VStack(spacing: 8) {
                    ForEach(model.microWins) { quest in
                        ChecklistSummaryRow(item: quest)
                    }
                }
            }
        }
    }
}

/// Dedicated badge gallery for unlocked milestones.
struct BadgesView: View {
    @EnvironmentObject var model: AppModel

    private var lockedBadges: [Badge] {
        badgeCatalog.filter { badge in
            !model.unlockedBadges.contains(where: { $0.id == badge.id })
        }
    }

    private var badgeCatalog: [Badge] {
        [
            Badge(id: "badge_getting_started", name: "Getting Started", description: "50+ XP in de pocket.", iconSystemName: "sparkles"),
            Badge(id: "badge_leveling_up", name: "Leveling Up", description: "200+ XP verzameld.", iconSystemName: "arrow.up.circle.fill"),
            Badge(id: "badge_architect", name: "Life Architect", description: "500+ XP en duidelijke architect van je leven.", iconSystemName: "rectangle.3.group.fill"),
            Badge(id: "badge_legend", name: "Level 100 Vibes", description: "1000+ XP: Legendary status.", iconSystemName: "star.circle.fill"),
            Badge(id: "badge_soft_lover", name: "Soft Lover", description: "80+ Love XP.", iconSystemName: "heart.circle.fill"),
            Badge(id: "badge_money_minded", name: "Money Minded", description: "80+ Money XP.", iconSystemName: "banknote"),
            Badge(id: "badge_mind_monk", name: "Mind Monk", description: "80+ Mind XP.", iconSystemName: "brain.head.profile"),
            Badge(id: "badge_explorer", name: "Explorer", description: "120+ Adventure XP.", iconSystemName: "globe.europe.africa.fill"),
            Badge(id: "badge_streak_7", name: "Consistency Era", description: "7-daagse streak.", iconSystemName: "calendar.badge.clock"),
            Badge(id: "badge_streak_21", name: "Unstoppable", description: "21-daagse streak.", iconSystemName: "flame"),
            Badge(id: "badge_arc_champion", name: "Story Arc", description: "Rond een hele arc af.", iconSystemName: "map.fill"),
            Badge(id: "badge_arcs_master", name: "Arc Master", description: "Voltooi 3 arcs.", iconSystemName: "rosette"),
        ]
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Unlocked") {
                    if model.unlockedBadges.isEmpty {
                        Text("Nog geen badges. Claim XP en bouw je streak om ze vrij te spelen.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(model.unlockedBadges) { badge in
                            BadgeRow(badge: badge, unlocked: true)
                        }
                    }
                }

                Section("Locked goals") {
                    if lockedBadges.isEmpty {
                        Text("Alles geclaimd! Nieuwe badges komen eraan.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(lockedBadges) { badge in
                            BadgeRow(badge: badge, unlocked: false)
                        }
                    }
                }
            }
            .navigationTitle("Badges")
        }
    }
}

struct BadgeRow: View {
    let badge: Badge
    var unlocked: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: badge.iconSystemName)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(unlocked ? .accentColor : .secondary)
                .padding(12)
                .background(
                    Circle().fill(unlocked ? Color.accentColor.opacity(0.14) : Color(.systemGray6))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(badge.name)
                    .font(.subheadline.weight(.semibold))
                Text(badge.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct QuestSummaryRow: View {
    let quest: Quest
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: quest.kind.systemImage)
                .foregroundColor(accent)
                .font(.headline)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(quest.title)
                    .font(.subheadline.weight(.semibold))
                if let detail = quest.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                HStack(spacing: 8) {
                    if let duration = quest.durationLabel {
                        Label(duration, systemImage: "clock")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(quest.kind.label)
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(accent.opacity(0.12)))
                        .foregroundColor(accent)
                }
            }

            Spacer()

            Text("\(quest.xp) XP")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct ChecklistSummaryRow: View {
    let item: ChecklistItem

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.accentColor)
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                if let detail = item.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                HStack(spacing: 8) {
                    ForEach(item.dimensions.prefix(2)) { dim in
                        Text(dim.label)
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color(.systemGray6)))
                    }
                }
            }

            Spacer()

            Text("\(item.xp) XP")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
            .environmentObject(AppModel())
            .preferredColorScheme(.dark)
    }
}
