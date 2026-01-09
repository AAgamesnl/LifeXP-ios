import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    
    @AppStorage("lifeXP.hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var showCelebration: Bool = false
    @State private var previousLevel: Int = 1
    @State private var isReady: Bool = false
    
    enum Tab: String, CaseIterable {
        case home, arcs, packs, stats, settings
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .arcs: return "Arcs"
            case .packs: return "Packs"
            case .stats: return "Stats"
            case .settings: return "Settings"
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

    var body: some View {
        ZStack {
            // Background (use static for better performance in Playgrounds)
            BrandBackgroundStatic()
            
            if isReady {
                // Main content (deferred to allow Playgrounds UI to render first)
                VStack(spacing: 0) {
                    // Tab content
                    ZStack {
                        switch selectedTab {
                        case .home:
                            HomeView()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.98)),
                                    removal: .opacity
                                ))
                        case .arcs:
                            ArcsView()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity
                                ))
                        case .packs:
                            PacksView()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity
                                ))
                        case .stats:
                            StatsView()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity
                                ))
                        case .settings:
                            SettingsView()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity
                                ))
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedTab)
                    
                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab, level: model.level, streak: model.currentStreak)
                }
                .transition(.opacity)
                
                // Level up celebration
                if showCelebration {
                    LevelUpCelebration(level: model.level, isPresented: $showCelebration)
                        .transition(.opacity.combined(with: .scale))
                }
            } else {
                // Loading state - allows Playgrounds to render UI before heavy content
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(BrandTheme.accent)
                    Text("Life XP")
                        .font(.headline)
                        .foregroundColor(BrandTheme.textPrimary)
                }
            }
        }
        .tint(BrandTheme.accent)
        .preferredColorScheme(model.preferredColorScheme)
        .task {
            // Defer heavy content loading to next run loop
            // This allows Swift Playgrounds to render the initial UI
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            withAnimation(.easeOut(duration: 0.3)) {
                isReady = true
            }
            previousLevel = model.level
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .onChange(of: model.level) { oldValue, newValue in
            if newValue > oldValue {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showCelebration = true
                }
                HapticsEngine.success()
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                hasCompletedOnboarding = true
                showOnboarding = false
            }
            .environmentObject(model)
        }
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab
    let level: Int
    let streak: Int
    
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ContentView.Tab.allCases, id: \.rawValue) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: tabAnimation
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                    HapticsEngine.lightImpact()
                }
            }
        }
        .padding(.horizontal, DesignSystem.spacing.md)
        .padding(.top, DesignSystem.spacing.md)
        .padding(.bottom, DesignSystem.spacing.lg)
        .background(
            TabBarBackground()
        )
    }
}

private struct TabBarItem: View {
    let tab: ContentView.Tab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
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
                        .symbolEffect(.bounce, value: isSelected)
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
    
    @State private var showContent = false
    @State private var showConfetti = false
    @State private var ringScale: CGFloat = 0.3
    @State private var textScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Confetti (reduced particle count for performance)
            ConfettiView(isActive: $showConfetti, particleCount: 30)
            
            // Content
            VStack(spacing: DesignSystem.spacing.xl) {
                // Level ring
                ZStack {
                    // Outer glow rings
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(BrandTheme.accent.opacity(0.3 - Double(i) * 0.1), lineWidth: 2)
                            .frame(width: 160 + CGFloat(i) * 30, height: 160 + CGFloat(i) * 30)
                            .scaleEffect(ringScale)
                    }
                    
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
                                endRadius: 80
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: BrandTheme.accent.opacity(0.6), radius: 30)
                        .scaleEffect(ringScale)
                    
                    // Level number
                    VStack(spacing: 0) {
                        Text("LEVEL")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(level)")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(textScale)
                }
                
                VStack(spacing: DesignSystem.spacing.sm) {
                    Text("Level Up!")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(.white)
                    
                    Text("Je bent nu level \(level)! Blijf doorgaan 🚀")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
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
                .scaleEffect(showContent ? 1 : 0.8)
            }
            .padding(DesignSystem.spacing.xxl)
        }
        .onAppear {
            animateIn()
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            ringScale = 1
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
            textScale = 1
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            showContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showConfetti = true
        }
    }
    
    private func dismiss() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
            .preferredColorScheme(.light)
        
        ContentView()
            .environmentObject(AppModel())
            .preferredColorScheme(.dark)
    }
}
