import SwiftUI

// MARK: - Onboarding View

struct OnboardingView: View {
    @Environment(AppModel.self) private var model
    var onDone: () -> Void

    @State private var selectedFocuses: Set<LifeDimension> = []
    @State private var overwhelmed: Double = 3
    @State private var selectedTone: ToneMode = .soft
    @State private var step: Int = 0
    @State private var hasSyncedFromModel = false
    @State private var isAdvancing: Bool = false
    @State private var showConfetti = false
    
    private let totalSteps = 4
    
    var body: some View {
        ZStack {
            // Static background for performance
            BrandBackgroundStatic()
                .ignoresSafeArea()
            
            // Confetti on completion (reduced particle count)
            ConfettiView(isActive: $showConfetti, particleCount: 30)
            
            VStack(spacing: 0) {
                // Progress indicator
                OnboardingProgress(currentStep: step, totalSteps: totalSteps)
                    .padding(.top, DesignSystem.spacing.xl)
                    .padding(.horizontal, DesignSystem.spacing.xl)
                
                // Content pages
                TabView(selection: $step) {
                    WelcomePage(isActive: step == 0)
                        .tag(0)
                    
                    FocusPage(selectedFocuses: $selectedFocuses, isActive: step == 1)
                        .tag(1)
                    
                    EnergyPage(overwhelmed: $overwhelmed, isActive: step == 2)
                        .tag(2)
                    
                    TonePage(selectedTone: $selectedTone, isActive: step == 3)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: step)
                
                // Navigation controls
                OnboardingControls(
                    step: $step,
                    totalSteps: totalSteps,
                    isAdvancing: isAdvancing,
                    canProceed: canProceed,
                    onNext: handleNext,
                    onBack: handleBack
                )
                .padding(.horizontal, DesignSystem.spacing.xl)
                .padding(.bottom, DesignSystem.spacing.xxl)
            }
        }
        .onAppear {
            guard !hasSyncedFromModel else { return }
            selectedFocuses = model.settings.enabledDimensions
            if selectedFocuses.isEmpty, let primary = model.primaryFocus {
                selectedFocuses.insert(primary)
            }
            overwhelmed = Double(model.overwhelmedLevel)
            selectedTone = model.toneMode
            hasSyncedFromModel = true
        }
    }
    
    private var canProceed: Bool {
        switch step {
        case 1: return !selectedFocuses.isEmpty
        default: return true
        }
    }
    
    private func handleNext() {
        HapticsEngine.lightImpact()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            isAdvancing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                isAdvancing = false
            }
        }

        if step < totalSteps - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                step += 1
            }
            return
        }

        // Final step - save and complete
        completeOnboarding()
    }
    
    private func handleBack() {
        HapticsEngine.lightImpact()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            step = max(0, step - 1)
        }
    }
    
    private func completeOnboarding() {
        let chosenDimensions = selectedFocuses.isEmpty ? Set(LifeDimension.allCases) : selectedFocuses
        let primary = LifeDimension.allCases.first(where: { chosenDimensions.contains($0) })

        model.settings.enabledDimensions = chosenDimensions
        model.primaryFocus = primary
        model.overwhelmedLevel = Int(overwhelmed)
        model.toneMode = selectedTone
        
        HapticsEngine.success()
        showConfetti = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            showConfetti = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            onDone()
        }
    }
}

// MARK: - Onboarding Progress

struct OnboardingProgress: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.sm) {
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(DesignSystem.text.labelSmall)
                .foregroundColor(BrandTheme.mutedText)
            
            HStack(spacing: DesignSystem.spacing.sm) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentStep ? BrandTheme.accent : BrandTheme.borderSubtle)
                        .frame(width: index == currentStep ? 32 : 16, height: 6)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentStep)
                }
            }
        }
    }
}

// MARK: - Onboarding Controls

struct OnboardingControls: View {
    @Binding var step: Int
    let totalSteps: Int
    let isAdvancing: Bool
    let canProceed: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.lg) {
            // Back button
            if step > 0 {
                Button(action: onBack) {
                    HStack(spacing: DesignSystem.spacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .buttonStyle(GhostButtonStyle())
            } else {
                Spacer()
            }
            
            Spacer()
            
            // Next/Finish button
            Button(action: onNext) {
                HStack(spacing: DesignSystem.spacing.sm) {
                    Text(step == totalSteps - 1 ? "Start Life XP" : "Continue")
                    Image(systemName: step == totalSteps - 1 ? "sparkles" : "arrow.right")
                }
            }
            .buttonStyle(GlowButtonStyle(size: .large))
            .disabled(!canProceed)
            .opacity(canProceed ? 1 : 0.6)
            .scaleEffect(isAdvancing ? 0.95 : 1)
        }
        .padding(DesignSystem.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                        .strokeBorder(BrandTheme.borderSubtle.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Welcome Page

struct WelcomePage: View {
    let isActive: Bool
    @State private var showContent = false
    @State private var showFeatures = false
    @State private var iconScale: CGFloat = 0.5
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DesignSystem.spacing.xxl) {
                Spacer().frame(height: DesignSystem.spacing.xxl)
                
                // Hero icon
                ZStack {
                    // Glow rings
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(BrandTheme.accent.opacity(0.2 - Double(i) * 0.05), lineWidth: 2)
                            .frame(width: 140 + CGFloat(i) * 30, height: 140 + CGFloat(i) * 30)
                    }
                    
                    // Main icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [BrandTheme.accent, BrandTheme.primaryDark],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: BrandTheme.accent.opacity(0.5), radius: 20)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(iconScale)
                .opacity(showContent ? 1 : 0)
                
                // Title
                VStack(spacing: DesignSystem.spacing.md) {
                    Text("Welcome to")
                        .font(DesignSystem.text.bodyLarge)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Text("Life XP")
                        .font(DesignSystem.text.displayLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("Your life checklist, gamified")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.textSecondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Feature list
                VStack(spacing: DesignSystem.spacing.md) {
                    FeatureRow(
                        icon: "target",
                        title: "Track Life Dimensions",
                        description: "Love, Money, Mind & Adventure",
                        color: BrandTheme.love
                    )
                    
                    FeatureRow(
                        icon: "map.fill",
                        title: "Follow Story Arcs",
                        description: "Guided journeys for real change",
                        color: BrandTheme.accent
                    )
                    
                    FeatureRow(
                        icon: "flame.fill",
                        title: "Build Streaks",
                        description: "Consistency creates momentum",
                        color: BrandTheme.warning
                    )
                    
                    FeatureRow(
                        icon: "star.fill",
                        title: "Earn XP & Level Up",
                        description: "Progress you can feel",
                        color: BrandTheme.success
                    )
                }
                .opacity(showFeatures ? 1 : 0)
                .offset(y: showFeatures ? 0 : 30)
                .padding(.horizontal, DesignSystem.spacing.lg)
                
                Spacer().frame(height: DesignSystem.spacing.huge)
            }
            .padding(.horizontal, DesignSystem.spacing.xl)
        }
        .onAppear {
            if isActive {
                animateIn()
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                animateIn()
            } else {
                resetState()
            }
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            iconScale = 1
            showContent = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            showFeatures = true
        }
    }
    
    private func resetState() {
        showContent = false
        showFeatures = false
        iconScale = 0.5
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            IconContainer(systemName: icon, color: color, size: .medium, style: .soft)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Text(description)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            Spacer()
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackground.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Focus Page

struct FocusPage: View {
    @Binding var selectedFocuses: Set<LifeDimension>
    let isActive: Bool
    @State private var showContent = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DesignSystem.spacing.xxl) {
                Spacer().frame(height: DesignSystem.spacing.xl)
                
                // Header
                VStack(spacing: DesignSystem.spacing.md) {
                    Text("What matters most?")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Select the life dimensions you want to focus on. We'll personalize your suggestions.")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.mutedText)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Dimension cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.spacing.md) {
                    ForEach(LifeDimension.allCases) { dimension in
                        DimensionCard(
                            dimension: dimension,
                            isSelected: selectedFocuses.contains(dimension)
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedFocuses.contains(dimension) {
                                    selectedFocuses.remove(dimension)
                                } else {
                                    selectedFocuses.insert(dimension)
                                }
                            }
                            HapticsEngine.lightImpact()
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                // Hint
                Text("Select at least one. You can change this later.")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: DesignSystem.spacing.huge)
            }
            .padding(.horizontal, DesignSystem.spacing.xl)
        }
        .onAppear {
            if isActive {
                animateIn()
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                animateIn()
            } else {
                showContent = false
            }
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
            showContent = true
        }
    }
}

struct DimensionCard: View {
    let dimension: LifeDimension
    let isSelected: Bool
    let action: () -> Void
    
    private var color: Color {
        BrandTheme.dimensionColor(dimension)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.spacing.md) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: dimension.systemImage)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(isSelected ? .white : color)
                }
                
                Text(dimension.label)
                    .font(DesignSystem.text.labelLarge)
                    .foregroundColor(BrandTheme.textPrimary)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(isSelected ? color.opacity(0.15) : BrandTheme.cardBackground.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(isSelected ? color : BrandTheme.borderSubtle, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 10, y: 4)
            .scaleEffect(isSelected ? 1.02 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(dimension.label)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

// MARK: - Energy Page

struct EnergyPage: View {
    @Binding var overwhelmed: Double
    let isActive: Bool
    @State private var showContent = false
    
    private var energyLevel: String {
        switch Int(overwhelmed) {
        case 1: return "Very calm 😌"
        case 2: return "Pretty relaxed 🙂"
        case 3: return "Balanced ⚖️"
        case 4: return "Quite busy 😅"
        case 5: return "Very overwhelmed 🫠"
        default: return "Balanced"
        }
    }
    
    private var energyColor: Color {
        switch Int(overwhelmed) {
        case 1, 2: return BrandTheme.success
        case 3: return BrandTheme.warning
        case 4, 5: return BrandTheme.error
        default: return BrandTheme.warning
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DesignSystem.spacing.xxl) {
                Spacer().frame(height: DesignSystem.spacing.xl)
                
                // Header
                VStack(spacing: DesignSystem.spacing.md) {
                    Text("How's your energy?")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Be honest - this helps us suggest the right pace for you.")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.mutedText)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Energy indicator
                VStack(spacing: DesignSystem.spacing.xl) {
                    // Big number
                    ZStack {
                        Circle()
                            .fill(energyColor.opacity(0.15))
                            .frame(width: 140, height: 140)
                        
                        VStack(spacing: 0) {
                            Text("\(Int(overwhelmed))")
                                .font(.system(size: 64, weight: .black, design: .rounded))
                                .foregroundColor(energyColor)
                            
                            Text("/ 5")
                                .font(DesignSystem.text.labelMedium)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                    
                    Text(energyLevel)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    // Slider
                    VStack(spacing: DesignSystem.spacing.md) {
                        Slider(value: $overwhelmed, in: 1...5, step: 1)
                            .tint(energyColor)
                        
                        HStack {
                            Text("Very calm")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                            Spacer()
                            Text("Very busy")
                                .font(.caption)
                                .foregroundColor(BrandTheme.mutedText)
                        }
                    }
                    .padding(DesignSystem.spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                            .fill(BrandTheme.cardBackground.opacity(0.9))
                    )
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                // Info
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(BrandTheme.info)
                    
                    Text("We'll adjust suggestions based on your energy. Low energy = gentle tasks. High energy = bigger challenges.")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(BrandTheme.info.opacity(0.1))
                )
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: DesignSystem.spacing.huge)
            }
            .padding(.horizontal, DesignSystem.spacing.xl)
        }
        .onAppear {
            if isActive {
                animateIn()
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                animateIn()
            } else {
                showContent = false
            }
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
            showContent = true
        }
    }
}

// MARK: - Tone Page

struct TonePage: View {
    @Binding var selectedTone: ToneMode
    let isActive: Bool
    @State private var showContent = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DesignSystem.spacing.xxl) {
                Spacer().frame(height: DesignSystem.spacing.xl)
                
                // Header
                VStack(spacing: DesignSystem.spacing.md) {
                    Text("Pick your vibe")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("How should Life XP talk to you?")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.mutedText)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Tone options
                VStack(spacing: DesignSystem.spacing.md) {
                    ToneOptionCard(
                        tone: .soft,
                        title: "Soft & Gentle",
                        description: "Kind, supportive, and understanding. Perfect if you need encouragement without pressure.",
                        icon: "heart.fill",
                        isSelected: selectedTone == .soft
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTone = .soft
                        }
                        HapticsEngine.lightImpact()
                    }
                    
                    ToneOptionCard(
                        tone: .realTalk,
                        title: "Real Talk",
                        description: "Honest, direct, and a bit spicy. For when you need someone to call you out (respectfully).",
                        icon: "bolt.fill",
                        isSelected: selectedTone == .realTalk
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTone = .realTalk
                        }
                        HapticsEngine.lightImpact()
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                // Preview
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    Text("Preview:")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Text(selectedTone == .soft
                        ? "\"You've got this. One small step at a time is still progress.\" 💫"
                        : "\"Stop scrolling, start doing. Your future self is waiting.\" 🔥")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.textSecondary)
                        .padding(DesignSystem.spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                .fill(BrandTheme.accentMuted.opacity(0.5))
                        )
                }
                .opacity(showContent ? 1 : 0)
                
                // Note
                Text("You can change this anytime in Settings.")
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: DesignSystem.spacing.huge)
            }
            .padding(.horizontal, DesignSystem.spacing.xl)
        }
        .onAppear {
            if isActive {
                animateIn()
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                animateIn()
            } else {
                showContent = false
            }
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
            showContent = true
        }
    }
}

struct ToneOptionCard: View {
    let tone: ToneMode
    let title: String
    let description: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    private var color: Color {
        tone == .soft ? BrandTheme.love : BrandTheme.warning
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isSelected ? .white : color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack {
                        Text(title)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(color)
                        }
                    }
                    
                    Text(description)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(DesignSystem.spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(isSelected ? color.opacity(0.1) : BrandTheme.cardBackground.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .strokeBorder(isSelected ? color : BrandTheme.borderSubtle, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 12, y: 6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(description)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}
