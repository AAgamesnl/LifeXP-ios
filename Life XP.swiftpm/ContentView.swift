import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    @Environment(AppModel.self) private var model
    
    @AppStorage("lifeXP.hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("lifeXP.hasSeenWelcomeTutorial") private var hasSeenWelcomeTutorial: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var showCelebration: Bool = false
    @State private var previousLevel: Int = 1
    @State private var isReady: Bool = false
    @State private var showLogMood: Bool = false
    @State private var showMoreMenu: Bool = false
    
    // Tutorial system
    @StateObject private var tutorialManager = TutorialManager()
    
    enum Tab: String, CaseIterable {
        case home, arcs, packs, stats, settings
        
        var title: String {
            switch self {
            case .home: return String(localized: "tab.home")
            case .arcs: return String(localized: "tab.arcs")
            case .packs: return String(localized: "tab.packs")
            case .stats: return String(localized: "tab.stats")
            case .settings: return String(localized: "tab.settings")
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "sparkles"
            case .arcs: return "map.fill"
            case .packs: return "checklist"
            case .stats: return "chart.bar.fill"
            case .settings: return "gearshape.fill"
            }
        }
        
        var selectedIcon: String {
            switch self {
            case .home: return "sparkles"
            case .arcs: return "map.fill"
            case .packs: return "checklist.checked"
            case .stats: return "chart.bar.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    /// Additional features accessible from more menu
    enum MoreFeature: String, CaseIterable, Identifiable {
        case habits, journal, focus, analytics, trophies
        
        var id: String { rawValue }
        
        var title: String {
            String(localized: "moreFeature.\(rawValue)")
        }
        
        var icon: String {
            switch self {
            case .habits: return "repeat.circle.fill"
            case .journal: return "book.fill"
            case .focus: return "timer"
            case .analytics: return "chart.xyaxis.line"
            case .trophies: return "trophy.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .habits: return .purple
            case .journal: return .orange
            case .focus: return .blue
            case .analytics: return .green
            case .trophies: return .yellow
            }
        }
    }
    
    @State private var selectedFeature: MoreFeature?

    var body: some View {
        ZStack {
            // Background (use static for better performance in Playgrounds)
            BrandBackgroundStatic()
            
            if isReady {
                // Main content (deferred to allow Playgrounds UI to render first)
                VStack(spacing: 0) {
                    // Tab content - optimized transitions
                    ZStack {
                        switch selectedTab {
                        case .home:
                            HomeView()
                                .transition(.opacity)
                        case .arcs:
                            ArcsView()
                                .transition(.opacity)
                        case .packs:
                            PacksView()
                                .transition(.opacity)
                        case .stats:
                            StatsView()
                                .transition(.opacity)
                        case .settings:
                            SettingsView()
                                .transition(.opacity)
                        }
                    }
                    // Smoother, more responsive tab animation
                    .animation(.spring(response: 0.35, dampingFraction: 0.9, blendDuration: 0.1), value: selectedTab)
                    
                    // Custom Tab Bar with more options
                    EnhancedTabBar(
                        selectedTab: $selectedTab,
                        level: model.level,
                        streak: model.currentStreak,
                        onMoreTap: { showMoreMenu = true }
                    )
                }
                .transition(.opacity)
                
                // Log Mood Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        LogMoodFloatingButton(showingLogMood: $showLogMood)
                            .padding(.trailing, 20)
                            .padding(.bottom, 100)
                    }
                }
                
                // Level up celebration
                if showCelebration {
                    LevelUpCelebration(level: model.level, isPresented: $showCelebration)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                // Tutorial overlay (above everything except celebrations)
                TutorialOverlay(manager: tutorialManager)
            } else {
                // Loading state - allows Playgrounds to render UI before heavy content
                EnhancedLoadingView()
            }
        }
        .tint(BrandTheme.accent)
        .preferredColorScheme(model.preferredColorScheme)
        .environmentObject(tutorialManager)
        .task {
            // Defer heavy content loading to next run loop
            // This allows Swift Playgrounds to render the initial UI
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            withAnimation(.easeOut(duration: 0.25)) {
                isReady = true
            }
            previousLevel = model.level
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .onChange(of: model.level) { oldValue, newValue in
            if newValue > oldValue {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.1)) {
                    showCelebration = true
                }
                HapticsEngine.success()
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                hasCompletedOnboarding = true
                showOnboarding = false
                
                // Start the welcome tutorial after a short delay
                if !hasSeenWelcomeTutorial {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        tutorialManager.startTutorial(.welcome)
                        hasSeenWelcomeTutorial = true
                    }
                }
            }
            .environment(model)
        }
        .sheet(isPresented: $showLogMood) {
            LogMoodSheet(manager: model.journalManager)
        }
        .sheet(isPresented: $showMoreMenu) {
            MoreFeaturesSheet(selectedFeature: $selectedFeature)
                .presentationDetents([.medium])
        }
        .fullScreenCover(item: $selectedFeature) { feature in
            NavigationStack {
                featureView(for: feature)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.commonDone) {
                        selectedFeature = nil
                    }
                }
            }
            }
            .environment(model)
        }
    }
    
    @ViewBuilder
    private func featureView(for feature: MoreFeature) -> some View {
        switch feature {
        case .habits:
            HabitsView()
        case .journal:
            JournalView(manager: model.journalManager)
        case .focus:
            FocusTimerView()
        case .analytics:
            AnalyticsDashboardView()
        case .trophies:
            TrophyCaseView()
        }
    }
}

// MARK: - Enhanced Loading View

struct EnhancedLoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Animated rings
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            BrandTheme.accent.opacity(0.3 - Double(i) * 0.1),
                            lineWidth: 2
                        )
                        .frame(width: CGFloat(60 + i * 20), height: CGFloat(60 + i * 20))
                        .rotationEffect(.degrees(rotation + Double(i * 30)))
                }
                
                // Center icon
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundStyle(BrandTheme.accent)
                    .scaleEffect(scale)
            }
            
            VStack(spacing: 8) {
                Text("Life XP")
                    .font(.title2.bold())
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text("Loading your journey...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - More Features Sheet

struct MoreFeaturesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedFeature: ContentView.MoreFeature?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Feature grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(ContentView.MoreFeature.allCases) { feature in
                        FeatureButton(feature: feature) {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                selectedFeature = feature
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(BrandBackgroundStatic())
            .navigationTitle(L10n.moreFeaturesTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.commonDone) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureButton: View {
    let feature: ContentView.MoreFeature
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: feature.icon)
                        .font(.title2)
                        .foregroundStyle(feature.color)
                }
                
                Text(feature.title)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.secondary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radii.lg))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Enhanced Tab Bar with More Button

struct EnhancedTabBar: View {
    @Binding var selectedTab: ContentView.Tab
    let level: Int
    let streak: Int
    let onMoreTap: () -> Void
    
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ContentView.Tab.allCases, id: \.rawValue) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: tabAnimation
                ) {
                    // Use optimized animation curve
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85, blendDuration: 0.08)) {
                        selectedTab = tab
                    }
                    HapticsEngine.lightImpact()
                }
            }
            
            // More button
            MoreTabButton(action: onMoreTap)
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.top, DesignSystem.Spacing.md)
        .padding(.bottom, DesignSystem.Spacing.lg)
        .background(
            TabBarBackground()
        )
    }
}

struct MoreTabButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            HapticsEngine.lightImpact()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(BrandTheme.mutedText)
                }
                .frame(height: 36)
                
                Text("More")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(BrandTheme.mutedText)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("More features")
    }
}

// MARK: - Custom Tab Bar (Legacy - kept for compatibility)

private struct TabBarItem: View {
    let tab: ContentView.Tab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(BrandTheme.accent.opacity(0.15))
                            .frame(width: 52, height: 36)
                            .matchedGeometryEffect(id: "tabHighlight", in: namespace)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? BrandTheme.accent : BrandTheme.mutedText)
                        // Only use symbolEffect when not reducing motion
                        .symbolEffect(.bounce, options: reduceMotion ? .nonRepeating : .default, value: isSelected)
                }
                .frame(height: 36)
                
                Text(tab.title)
                    .font(.caption2)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? BrandTheme.accent : BrandTheme.mutedText)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct TabBarBackground: View {
    var body: some View {
        ZStack {
            // Frosted glass effect
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    BrandTheme.cardBackground.opacity(0.9),
                    BrandTheme.cardBackground.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Top border
            VStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                BrandTheme.accent.opacity(0.2),
                                BrandTheme.borderSubtle.opacity(0.3)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 0.5)
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Level Up Celebration

struct LevelUpCelebration: View {
    let level: Int
    @Binding var isPresented: Bool
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var showConfetti = false
    @State private var ringScale: CGFloat = 0.4
    @State private var textScale: CGFloat = 0.6
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Confetti (reduced particle count for performance)
            ConfettiView(isActive: $showConfetti, particleCount: 25)
            
            // Content
            VStack(spacing: DesignSystem.spacing.xl) {
                // Level ring - simplified for performance
                ZStack {
                    // Single outer glow ring (reduced from 3)
                    Circle()
                        .stroke(BrandTheme.accent.opacity(0.25), lineWidth: 2)
                        .frame(width: 170, height: 170)
                        .scaleEffect(ringScale)
                    
                    // Main circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    BrandTheme.accent,
                                    BrandTheme.primaryDark
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 75
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: BrandTheme.accent.opacity(0.5), radius: 25)
                        .scaleEffect(ringScale)
                    
                    // Level number
                    VStack(spacing: 0) {
                        Text("LEVEL")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(level)")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                    }
                    .scaleEffect(textScale)
                }
                
                VStack(spacing: DesignSystem.spacing.sm) {
                    Text("Level Up!")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(.white)
                    
                    Text("You're now level \(level)! Keep going 🚀")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 15)
                
                Button {
                    dismiss()
                } label: {
                    Text("Doorgaan")
                        .font(.headline.weight(.bold))
                        .foregroundColor(BrandTheme.accent)
                        .padding(.horizontal, DesignSystem.spacing.xxl)
                        .padding(.vertical, DesignSystem.spacing.md)
                        .background(
                            Capsule()
                                .fill(.white)
                        )
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.85)
            }
            .padding(DesignSystem.spacing.xxl)
        }
        .onAppear {
            animateIn()
        }
    }
    
    private func animateIn() {
        if reduceMotion {
            ringScale = 1
            textScale = 1
            showContent = true
            return
        }
        
        // Combined, smoother animation sequence
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.1)) {
            ringScale = 1
            textScale = 1
        }
        
        withAnimation(.easeOut(duration: 0.35).delay(0.2)) {
            showContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            showConfetti = true
        }
    }
    
    private func dismiss() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 0.05)) {
            isPresented = false
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(AppModel())
            .preferredColorScheme(.light)
        
        ContentView()
            .environment(AppModel())
            .preferredColorScheme(.dark)
    }
}
