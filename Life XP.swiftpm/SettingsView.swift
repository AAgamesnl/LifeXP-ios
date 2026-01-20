import SwiftUI
import Observation

// MARK: - Settings View

struct SettingsView: View {
    @Environment(AppModel.self) private var model

    @State private var confirmResetAll = false
    @State private var confirmResetArcs = false
    @State private var confirmResetStreaks = false
    @State private var confirmResetStats = false
    @State private var showResetOptions = false

    var body: some View {
        NavigationStack {
            ScreenBackground {
                ScrollView {
                    VStack(spacing: DesignSystem.spacing.xl) {
                        // Profile Summary
                        ProfileSummaryCard()
                        
                        // Experience Settings
                        ExperienceSettingsSection()
                        
                        // Content Settings
                        ContentSettingsSection()
                        
                        // Visual Settings
                        VisualSettingsSection()
                        
                        // Home Customization
                        HomeCustomizationSection()
                        
                        // Help & Tutorials
                        HelpTutorialsSection()
                        
                        // Data & Reset
                        DataResetSection(
                            showResetOptions: $showResetOptions,
                            confirmResetAll: $confirmResetAll,
                            confirmResetArcs: $confirmResetArcs,
                            confirmResetStreaks: $confirmResetStreaks,
                            confirmResetStats: $confirmResetStats
                        )
                        
                        // Developer Options
                        DeveloperSection()
                        
                        // App Info
                        AppInfoSection()
                        
                        Color.clear.frame(height: DesignSystem.spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
                .trackScrollActivity()
            }
            .navigationTitle(L10n.tabSettings)
            .confirmationDialog("Reset Everything?", isPresented: $confirmResetAll, titleVisibility: .visible) {
                Button("Reset Life XP", role: .destructive) { model.resetAllProgress() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will reset all your XP, arcs, streaks, and progress. This cannot be undone.")
            }
            .confirmationDialog("Reset Arcs?", isPresented: $confirmResetArcs, titleVisibility: .visible) {
                Button("Reset Arc Progress", role: .destructive) { model.resetArcProgress() }
                Button("Cancel", role: .cancel) { }
            }
            .confirmationDialog("Reset Streaks?", isPresented: $confirmResetStreaks, titleVisibility: .visible) {
                Button("Reset Streak Counter", role: .destructive) { model.resetStreaksOnly() }
                Button("Cancel", role: .cancel) { }
            }
            .confirmationDialog("Reset Stats?", isPresented: $confirmResetStats, titleVisibility: .visible) {
                Button("Reset Statistics", role: .destructive) { model.resetStatsOnly() }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

// MARK: - Profile Summary Card

struct ProfileSummaryCard: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.lg) {
            // Level badge
            ZStack {
                Circle()
                    .fill(BrandTheme.accent)
                    .frame(width: 64, height: 64)
                
                Text("\(model.level)")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            .shadow(color: BrandTheme.accent.opacity(0.4), radius: 8, y: 4)
            
            VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                Text("Level \(model.level)")
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text("\(model.totalXP) XP total • \(model.unlockedBadges.count) badges")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                
                if model.currentStreak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(BrandTheme.error)
                        Text("\(model.currentStreak) day streak")
                            .foregroundColor(BrandTheme.textSecondary)
                    }
                    .font(.caption)
                }
            }
            
            Spacer()
        }
        .brandCard()
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Experience Settings Section

struct ExperienceSettingsSection: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        SettingsSection(title: "Experience", icon: "sparkles", color: BrandTheme.accent) {
            VStack(spacing: DesignSystem.spacing.md) {
                // Tone
                SettingsPicker(
                    title: "Coaching Tone",
                    subtitle: "How Life XP speaks to you",
                    selection: $model.settings.toneMode,
                    options: ToneMode.allCases
                )
                
                Divider().background(BrandTheme.divider)
                
                // Nudge Intensity
                SettingsPicker(
                    title: "Daily Nudges",
                    subtitle: "How often we suggest actions",
                    selection: $model.settings.dailyNudgeIntensity,
                    options: NudgeIntensity.allCases
                )
                
                Divider().background(BrandTheme.divider)
                
                // Next Quests
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text(L10n.settingsNextQuestsTitle)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(L10n.settingsNextQuestsSubtitle)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Picker(String(localized: "arcs.nextQuests.title"), selection: $model.settings.questBoardDensity) {
                        ForEach(QuestBoardDensity.allCases) { density in
                            Text(density.label).tag(density)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}

// MARK: - Content Settings Section

struct ContentSettingsSection: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        SettingsSection(title: "Content", icon: "slider.horizontal.3", color: BrandTheme.info) {
            VStack(spacing: DesignSystem.spacing.md) {
                // PRO Teasers
                SettingsToggle(
                    title: "Show PRO Teasers",
                    subtitle: "Display locked premium content hints",
                    isOn: $model.settings.showProTeasers
                )
                
                Divider().background(BrandTheme.divider)
                
                // Primary Focus
                SettingsPicker(
                    title: "Primary Focus",
                    subtitle: "Your main life dimension",
                    selection: Binding(
                        get: { model.settings.primaryFocus ?? .love },
                        set: { model.settings.primaryFocus = $0 }
                    ),
                    options: LifeDimension.allCases
                )
                
                Divider().background(BrandTheme.divider)
                
                // Enabled Dimensions
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Active Dimensions")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Show suggestions for these areas")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    ForEach(LifeDimension.allCases) { dim in
                        DimensionToggleRow(dimension: dim)
                    }
                }
            }
        }
    }
}

struct DimensionToggleRow: View {
    @Environment(AppModel.self) private var model
    let dimension: LifeDimension
    
    private var isEnabled: Bool {
        model.settings.enabledDimensions.contains(dimension)
    }
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isEnabled },
            set: { newValue in
                var set = model.settings.enabledDimensions
                if newValue {
                    set.insert(dimension)
                } else if set.count > 1 {
                    set.remove(dimension)
                }
                model.settings.enabledDimensions = set
            }
        )) {
            Label {
                Text(dimension.label)
                    .font(DesignSystem.text.labelSmall)
            } icon: {
                Image(systemName: dimension.systemImage)
                    .foregroundColor(BrandTheme.dimensionColor(dimension))
            }
        }
        .tint(BrandTheme.dimensionColor(dimension))
    }
}

// MARK: - Visual Settings Section

struct VisualSettingsSection: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        SettingsSection(title: "Appearance", icon: "paintbrush.fill", color: BrandTheme.mind) {
            VStack(spacing: DesignSystem.spacing.md) {
                // Theme
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Theme")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Picker("Theme", selection: $model.settings.appearanceMode) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Divider().background(BrandTheme.divider)
                
                // Compact Layout
                SettingsToggle(
                    title: "Compact Layout",
                    subtitle: "Reduce spacing between cards",
                    isOn: $model.settings.compactHomeLayout
                )
                
                Divider().background(BrandTheme.divider)
                
                // Hero Cards
                SettingsToggle(
                    title: "Hero Cards",
                    subtitle: "Show large featured cards",
                    isOn: $model.settings.showHeroCards
                )
                
                Divider().background(BrandTheme.divider)
                
                // Cards Expanded
                SettingsToggle(
                    title: "Expand Cards by Default",
                    subtitle: "Show full card content initially",
                    isOn: $model.settings.expandHomeCardsByDefault
                )
            }
        }
    }
}

// MARK: - Home Customization Section

struct HomeCustomizationSection: View {
    @Environment(AppModel.self) private var model
    @State private var isExpanded = false
    
    var body: some View {
        @Bindable var model = model
        SettingsSection(title: "Home Screen", icon: "house.fill", color: BrandTheme.love) {
            VStack(spacing: DesignSystem.spacing.md) {
                // Essential toggles
                SettingsToggle(
                    title: "Show Streaks",
                    subtitle: "Display streak counter on home",
                    isOn: $model.settings.showStreaks
                )
                
                Divider().background(BrandTheme.divider)
                
                SettingsToggle(
                    title: "Momentum Grid",
                    subtitle: "Show dimension balance grid",
                    isOn: $model.settings.showMomentumGrid
                )
                
                Divider().background(BrandTheme.divider)
                
                SettingsToggle(
                    title: "Quick Actions",
                    subtitle: "Show quick action buttons",
                    isOn: $model.settings.showQuickActions
                )
                
                // Expandable section for more options
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("More Options")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.accent)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(BrandTheme.accent)
                    }
                }
                .buttonStyle(.plain)
                
                if isExpanded {
                    VStack(spacing: DesignSystem.spacing.md) {
                        Divider().background(BrandTheme.divider)
                        
                        SettingsToggle(
                            title: "Energy Check-in",
                            subtitle: "Show energy level card",
                            isOn: $model.settings.showEnergyCard
                        )
                        
                        SettingsToggle(
                            title: "Weekly Blueprint",
                            subtitle: "Show weekly ritual card",
                            isOn: $model.settings.showWeeklyBlueprint
                        )
                        
                        SettingsToggle(
                            title: "Focus Dimension",
                            subtitle: "Highlight weakest dimension",
                            isOn: $model.settings.showFocusDimensionCard
                        )
                        
                        SettingsToggle(
                            title: "Focus Playlist",
                            subtitle: "Show quick focus tasks",
                            isOn: $model.settings.showFocusPlaylistCard
                        )
                        
                        SettingsToggle(
                            title: "Legendary Quest",
                            subtitle: "Show boss fight card",
                            isOn: $model.settings.showLegendaryQuestCard
                        )
                        
                        SettingsToggle(
                            title: "Seasonal Spotlight",
                            subtitle: "Show themed content",
                            isOn: $model.settings.showSeasonalSpotlight
                        )
                        
                        SettingsToggle(
                            title: "Daily Suggestion",
                            subtitle: "Show personalized task",
                            isOn: $model.settings.showSuggestionCard
                        )
                        
                        SettingsToggle(
                            title: "Arc Progress on Share",
                            subtitle: "Include arc in share card",
                            isOn: $model.settings.showArcProgressOnShare
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Data Reset Section

struct DataResetSection: View {
    @Environment(AppModel.self) private var model
    @Binding var showResetOptions: Bool
    @Binding var confirmResetAll: Bool
    @Binding var confirmResetArcs: Bool
    @Binding var confirmResetStreaks: Bool
    @Binding var confirmResetStats: Bool
    
    var body: some View {
        SettingsSection(title: "Data & Reset", icon: "arrow.counterclockwise", color: BrandTheme.error) {
            VStack(spacing: DesignSystem.spacing.md) {
                Text("Reset options require confirmation to prevent accidental data loss.")
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showResetOptions.toggle()
                    }
                } label: {
                    HStack {
                        Text("Show Reset Options")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.error)
                        
                        Spacer()
                        
                        Image(systemName: showResetOptions ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(BrandTheme.error)
                    }
                }
                .buttonStyle(.plain)
                
                if showResetOptions {
                    VStack(spacing: DesignSystem.spacing.sm) {
                        ResetButton(
                            title: "Reset Everything",
                            subtitle: "XP, arcs, streaks - start fresh",
                            icon: "trash.fill",
                            isDestructive: true
                        ) {
                            confirmResetAll = true
                        }
                        
                        ResetButton(
                            title: "Reset Arcs Only",
                            subtitle: "Keep XP, reset arc progress",
                            icon: "map"
                        ) {
                            confirmResetArcs = true
                        }
                        
                        ResetButton(
                            title: "Reset Streaks Only",
                            subtitle: "Keep everything else",
                            icon: "flame"
                        ) {
                            confirmResetStreaks = true
                        }
                        
                        ResetButton(
                            title: "Reset Stats Only",
                            subtitle: "Reset completion tracking",
                            icon: "chart.line.downtrend.xyaxis"
                        ) {
                            confirmResetStats = true
                        }
                    }
                }
            }
        }
    }
}

struct ResetButton: View {
    let title: String
    let subtitle: String
    let icon: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isDestructive ? .white : BrandTheme.error)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isDestructive ? BrandTheme.error : BrandTheme.error.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(BrandTheme.mutedText)
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Help & Tutorials Section

struct HelpTutorialsSection: View {
    @State private var showTutorialList = false
    @EnvironmentObject var tutorialManager: TutorialManager
    
    var body: some View {
        SettingsSection(title: "Help & Tutorials", icon: "book.fill", color: BrandTheme.info) {
            VStack(spacing: DesignSystem.spacing.md) {
                // View all tutorials
                Button {
                    showTutorialList = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("App Tutorials")
                                .font(DesignSystem.text.labelMedium)
                                .foregroundColor(BrandTheme.textPrimary)
                            Text("Learn how to use all features")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
                .buttonStyle(.plain)
                
                Divider().background(BrandTheme.divider)
                
                // Quick start tutorials
                VStack(spacing: DesignSystem.spacing.sm) {
                    QuickTutorialButton(
                        title: "Welcome Tour",
                        icon: "hand.wave.fill",
                        color: BrandTheme.accent
                    ) {
                        tutorialManager.startTutorial(.welcome)
                    }
                    
                    QuickTutorialButton(
                        title: "Life Dimensions",
                        icon: "circle.grid.2x2.fill",
                        color: BrandTheme.mind
                    ) {
                        tutorialManager.startTutorial(.dimensionsExplained)
                    }
                    
                    QuickTutorialButton(
                        title: "Game Features",
                        icon: "gamecontroller.fill",
                        color: BrandTheme.adventure
                    ) {
                        tutorialManager.startTutorial(.gamificationFeatures)
                    }
                }
            }
        }
        .sheet(isPresented: $showTutorialList) {
            TutorialListView()
                .environmentObject(tutorialManager)
        }
    }
}

struct QuickTutorialButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )
                
                Text(title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            .padding(DesignSystem.spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(color.opacity(0.05))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Developer Section

struct DeveloperSection: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        SettingsSection(title: "Developer", icon: "hammer.fill", color: BrandTheme.warning) {
            VStack(spacing: DesignSystem.spacing.md) {
                SettingsToggle(
                    title: "Force PRO Mode",
                    subtitle: "Unlock all premium content for testing",
                    isOn: $model.premiumUnlocked
                )
                
                HStack(spacing: DesignSystem.spacing.sm) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(BrandTheme.info)
                    
                    Text("This is for testing purposes only. In the real app, PRO would be unlocked via in-app purchase.")
                        .font(.caption)
                        .foregroundColor(BrandTheme.mutedText)
                }
            }
        }
    }
}

// MARK: - App Info Section

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: DesignSystem.spacing.md) {
            Text("Life XP")
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text("Version 2.0")
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
            
            Text("Built with ❤️ for personal growth")
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.spacing.xl)
    }
}

// MARK: - Settings Components

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.sm) {
                IconContainer(systemName: icon, color: color, size: .small, style: .soft)
                
                Text(title)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
            }
            
            content()
        }
        .brandCard()
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
        }
        .tint(BrandTheme.accent)
    }
}

struct SettingsPicker<T: Hashable & Identifiable & CaseIterable>: View where T.AllCases: RandomAccessCollection {
    let title: String
    let subtitle: String
    @Binding var selection: T
    let options: T.AllCases
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.id) { option in
                    Text(String(describing: option).capitalized)
                        .tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(BrandTheme.accent)
        }
    }
}
