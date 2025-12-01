import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Life score + streak
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Life XP")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Your Life Checklist")
                                        .font(.title2.weight(.semibold))
                                }
                                
                                Spacer()
                                
                                if model.currentStreak > 0 {
                                    HStack(spacing: 6) {
                                        Image(systemName: "flame.fill")
                                        Text("\(model.currentStreak)-day streak")
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule().fill(Color.orange.opacity(0.12))
                                    )
                                    .foregroundColor(.orange)
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
                                        .foregroundColor(.secondary)
                                    
                                    if model.bestStreak > 0 {
                                        Text("Best streak: \(model.bestStreak) days")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
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
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(radius: 14, y: 6)

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

                        if let legendary = model.legendaryQuest, let pack = model.pack(for: legendary.id) {
                            LegendaryQuestCard(pack: pack, item: legendary)
                        }

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
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        // Quick links
                        VStack(spacing: 12) {
                            HStack {
                                Text("Quick actions")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            NavigationLink(destination: JourneysView()) {
                                QuickActionRow(
                                    icon: "map.fill",
                                    title: "Journeys",
                                    subtitle: "Maak van je leven een route, niet alleen een lijst."
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
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
        }
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
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(.systemGray5),
                    lineWidth: 14
                )
            
            Circle()
                .trim(from: 0, to: CGFloat(max(0, min(progress, 1))))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            Color.purple,
                            Color.pink,
                            Color.blue
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)
            
            VStack(spacing: 4) {
                Text("\(Int(progress * 100))")
                    .font(.title.bold())
                Text("%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
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
                        .fill(Color(.systemGray5))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.accentColor.opacity(0.9),
                                Color.accentColor.opacity(0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, ratio)))))
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
                    .fill(Color.accentColor.opacity(0.12))
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.accentColor)
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
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 3)
    }
}

// MARK: - Level + Focus Cards

struct LevelCard: View {
    @EnvironmentObject var model: AppModel
    let level: Int
    let progress: Double
    let xpToNext: Int
    let nextUnlock: String

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

                ProgressRing(progress: progress)
                    .frame(width: 80, height: 80)
            }

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
