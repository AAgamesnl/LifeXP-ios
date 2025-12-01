import SwiftUI

struct JourneysView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Journeys")) {
                    ForEach(model.journeys) { journey in
                        NavigationLink(destination: JourneyDetailView(journey: journey)) {
                            JourneyCardView(journey: journey)
                        }
                    }
                }
                
                Section(header: Text("Tools")) {
                    NavigationLink(destination: ChallengeView()) {
                        Label("Weekend Challenge", systemImage: "flag.checkered")
                    }
                    
                    NavigationLink(destination: BadgesView()) {
                        Label("Badges", systemImage: "rosette")
                    }
                }
            }
            .navigationTitle("Journeys")
        }
    }
}

struct JourneyCardView: View {
    @EnvironmentObject var model: AppModel
    let journey: Journey
    
    var body: some View {
        let accent = Color(hex: journey.accentColorHex, default: .accentColor)
        let progress = model.journeyProgress(journey)
        let done = model.journeyCompletedCount(journey)
        let total = model.journeyTotalCount(journey)
        
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(accent.opacity(0.16))
                Image(systemName: journey.iconSystemName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(accent)
            }
            .frame(width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(journey.title)
                    .font(.subheadline.weight(.semibold))
                
                Text(journey.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                ProgressView(value: progress)
                    .tint(accent)
                
                HStack {
                    Text("\(done)/\(total) steps • \(journey.durationDays) days")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(10)
    }
}

struct JourneyDetailView: View {
    @EnvironmentObject var model: AppModel
    let journey: Journey
    
    var steps: [ChecklistItem] {
        journey.stepItemIDs.compactMap { model.item(withID: $0) }
    }
    
    var body: some View {
        let accent = Color(hex: journey.accentColorHex, default: .accentColor)
        let progress = model.journeyProgress(journey)
        
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(accent.opacity(0.15))
                            Image(systemName: journey.iconSystemName)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(accent)
                        }
                        .frame(width: 70, height: 70)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(journey.title)
                                .font(.title2.bold())
                            Text(journey.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            ProgressView(value: progress)
                                .tint(accent)
                            
                            Text("\(Int(progress * 100))% • \(model.journeyCompletedCount(journey))/\(model.journeyTotalCount(journey)) steps")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if !journey.focusDimensions.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(journey.focusDimensions) { dim in
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
            
            Section(header: Text("Steps")) {
                ForEach(steps) { item in
                    JourneyStepRow(item: item, accent: accent)
                }
            }
        }
        .navigationTitle(journey.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JourneyStepRow: View {
    @EnvironmentObject var model: AppModel
    let item: ChecklistItem
    let accent: Color
    
    @State private var showPaywall = false
    
    var body: some View {
        Button {
            if item.isPremium && !model.premiumUnlocked {
                showPaywall = true
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    model.toggle(item)
                }
            }
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: model.isCompleted(item) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(model.isCompleted(item) ? accent : Color(.systemGray4))
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if item.isPremium {
                            Text("PRO")
                                .font(.caption2.bold())
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule().fill(Color.yellow.opacity(0.16))
                                )
                                .overlay(
                                    Capsule().stroke(Color.yellow.opacity(0.7), lineWidth: 0.8)
                                )
                        }
                    }
                    
                    if let detail = item.detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("\(item.xp) XP")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(accent.opacity(0.14))
                        )
                        .foregroundColor(accent)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .alert("Life XP PRO", isPresented: $showPaywall) {
            Button("Later", role: .cancel) { }
        } message: {
            Text("Deze step hoort bij Life XP PRO.\n\nIn de echte app kun je PRO ontgrendelen via een eenmalige in-app aankoop. Voor nu kun je PRO testen via de dev toggle in Settings.")
        }
    }
}

// MARK: - Challenge View

struct ChallengeView: View {
    @EnvironmentObject var model: AppModel
    
    enum Mode: String, CaseIterable, Identifiable {
        case solo
        case friends
        case partner
        
        var id: String { rawValue }
        
        var label: String {
            switch self {
            case .solo: return "Solo"
            case .friends: return "Friends"
            case .partner: return "Partner"
            }
        }
        
        var icon: String {
            switch self {
            case .solo: return "person.fill"
            case .friends: return "person.2.fill"
            case .partner: return "heart.fill"
            }
        }
    }
    
    @State private var mode: Mode = .solo
    @State private var challengeItems: [ChecklistItem] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Form {
                Section(header: Text("Mode")) {
                    Picker("Mode", selection: $mode) {
                        ForEach(Mode.allCases) { m in
                            Label(m.label, systemImage: m.icon)
                                .tag(m)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Challenge")) {
                    if challengeItems.isEmpty {
                        Text("Tap op \"Generate\" om een challenge samen te stellen.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(challengeItems) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.accentColor)
                                    .padding(.top, 2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                    if let detail = item.detail {
                                        Text(detail)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        generateChallenge()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Generate weekend challenge", systemImage: "sparkles")
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Weekend Challenge")
        .onAppear {
            if challengeItems.isEmpty {
                generateChallenge()
            }
        }
    }
    
    private func generateChallenge() {
        let all = model.allVisibleItems
        
        let filtered: [ChecklistItem]
        switch mode {
        case .solo:
            filtered = all.filter { $0.dimensions.contains(.mind) || $0.dimensions.contains(.adventure) }
        case .friends:
            filtered = all.filter { $0.dimensions.contains(.adventure) || $0.dimensions.contains(.love) }
        case .partner:
            filtered = all.filter { $0.dimensions.contains(.love) }
        }
        
        let base = filtered.isEmpty ? all : filtered
        var shuffled = Array(base.shuffled().prefix(5))
        if shuffled.isEmpty {
            shuffled = all
        }
        challengeItems = shuffled
    }
}

// MARK: - Badges View

struct BadgesView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        List {
            Section(header: Text("Unlocked badges")) {
                if model.unlockedBadges.isEmpty {
                    Text("Nog geen badges… maar dat kan snel veranderen 😉")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(model.unlockedBadges) { badge in
                        BadgeRow(badge: badge)
                    }
                }
            }
        }
        .navigationTitle("Badges")
    }
}

struct BadgeRow: View {
    let badge: Badge
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 38, height: 38)
                Image(systemName: badge.iconSystemName)
                    .foregroundColor(.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(badge.name)
                    .font(.subheadline.weight(.semibold))
                Text(badge.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
