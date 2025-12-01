import SwiftUI

struct StatsView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    LevelSummaryCard(
                        level: model.level,
                        progress: model.levelProgress,
                        xpToNext: model.xpToNextLevel,
                        nextUnlock: model.nextUnlockMessage
                    )

                    // Overall card
                    VStack(spacing: 8) {
                        Text("Overall")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .center, spacing: 20) {
                            ProgressRing(progress: model.globalProgress)
                                .frame(width: 120, height: 120)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Life Score")
                                    .font(.headline)
                                Text("\(Int(model.globalProgress * 100))% completed")
                                    .font(.title2.bold())
                                Text("\(model.totalXP) XP total")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if model.currentStreak > 0 {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                        Text("Current streak: \(model.currentStreak) days")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                }
                                
                                if model.bestStreak > 0 {
                                    Text("Best streak: \(model.bestStreak) days")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 10, y: 5)
                    
                    // Dimensions
                    VStack(spacing: 16) {
                        HStack {
                            Text("Dimensions")
                                .font(.headline)
                            Spacer()
                        }

                        ForEach(LifeDimension.allCases) { dim in
                            StatsDimensionCard(dimension: dim)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    VStack(spacing: 12) {
                        HStack {
                            Text("Journeys & arcs")
                                .font(.headline)
                            Spacer()
                            Text("\(model.completedJourneys.count) completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        ForEach(model.journeys) { journey in
                            JourneyProgressRow(journey: journey)
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 6, y: 3)

                    // Badges quick view
                    if !model.unlockedBadges.isEmpty {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Badges")
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: BadgesView()) {
                                    Text("View all")
                                        .font(.caption)
                                }
                            }
                            
                            ForEach(model.unlockedBadges.prefix(3)) { badge in
                                BadgeRow(badge: badge)
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(radius: 6, y: 3)
                    }
                    
                    // Share card
                    NavigationLink(destination: SharePreviewView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.blue.opacity(0.15))
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 54, height: 54)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Maak een share card")
                                    .font(.subheadline.weight(.semibold))
                                Text("Perfect voor TikTok, Insta stories of om naar vrienden te sturen.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(radius: 6, y: 3)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("Stats")
        }
    }
}

struct StatsDimensionCard: View {
    @EnvironmentObject var model: AppModel
    let dimension: LifeDimension
    
    private var ratio: Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: dimension.systemImage)
                Text(dimension.label)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(model.xp(for: dimension)) / \(model.maxXP(for: dimension)) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.accentColor.opacity(0.9),
                                Color.accentColor.opacity(0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: max(10, geo.size.width * CGFloat(min(1, max(0, ratio)))))
                }
            }
            .frame(height: 12)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

struct LevelSummaryCard: View {
    let level: Int
    let progress: Double
    let xpToNext: Int
    let nextUnlock: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(level)")
                        .font(.title3.bold())
                    Text("Nog \(xpToNext) XP tot level \(level + 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                ProgressRing(progress: progress)
                    .frame(width: 90, height: 90)
            }

            Text(nextUnlock)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
}

struct JourneyProgressRow: View {
    @EnvironmentObject var model: AppModel
    let journey: Journey

    var body: some View {
        let accent = Color(hex: journey.accentColorHex, default: .accentColor)
        let progress = model.journeyProgress(journey)

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: journey.iconSystemName)
                    .foregroundColor(accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(journey.title)
                        .font(.subheadline.weight(.semibold))
                    Text(journey.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(accent.opacity(0.18)))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accent)
                        .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, progress)))))
                }
            }
            .frame(height: 10)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Share Views

struct SharePreviewView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Screenshot deze kaart en deel ’m in je story ✨")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                
                ShareCardView()
                    .frame(maxWidth: 360)
                
                Text("Tip: zet je camera op full-screen, maak een screenshot en tag je app-naam.")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .navigationTitle("Share card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShareCardView: View {
    @EnvironmentObject var model: AppModel
    
    private func ratio(for dimension: LifeDimension) -> Double {
        let maxXP = model.maxXP(for: dimension)
        guard maxXP > 0 else { return 0 }
        return Double(model.xp(for: dimension)) / Double(maxXP)
    }
    
    var body: some View {
        GeometryReader { geo in
            let _ = geo.size
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple,
                        Color.black,
                        Color.blue
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                    .padding(10)
                
                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("My Life Checklist")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("How ‘completed’ is your life?")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    ProgressRing(progress: model.globalProgress)
                        .frame(width: 150, height: 150)
                        .padding(.top, 8)
                    
                    Text("\(model.totalXP) XP collected")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    VStack(spacing: 10) {
                        ForEach(LifeDimension.allCases) { dim in
                            HStack(spacing: 10) {
                                Image(systemName: dim.systemImage)
                                    .foregroundColor(.white)
                                Text(dim.label)
                                    .font(.footnote.weight(.medium))
                                    .foregroundColor(.white)
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.15))
                                        Capsule()
                                            .fill(Color.white)
                                            .frame(width: max(8, geo.size.width * CGFloat(min(1, max(0, ratio(for: dim))))))
                                    }
                                }
                                .frame(height: 8)
                                
                                Text("\(model.xp(for: dim))")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Check jouw life progress")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.85))
                        
                        Text("Search in the App Store: Life XP")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
            }
        }
        .aspectRatio(9/16, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(radius: 24, y: 10)
    }
}
