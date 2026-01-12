import SwiftUI

// MARK: - AAA Game System Views
// Beautiful, interactive UI components for the advanced game systems.

// MARK: - Daily Challenges Card

struct DailyChallengesCard: View {
    @ObservedObject var manager: DailyChallengeManager
    @State private var expandedChallengeID: String?
    @State private var showAllChallenges = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            // Header
            HStack {
                IconContainer(
                    systemName: "target",
                    color: BrandTheme.warning,
                    size: .medium,
                    style: .gradient
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Challenges")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("\(manager.earnedBonusXP)/\(manager.totalBonusXPAvailable) Bonus XP")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                if manager.allChallengesCompleted {
                    ChipView(text: "Complete!", icon: "checkmark.circle.fill", color: BrandTheme.success, size: .small)
                }
            }
            
            // Challenges list
            VStack(spacing: DesignSystem.spacing.md) {
                ForEach(Array(manager.todaysChallenges.prefix(showAllChallenges ? 10 : 3))) { challenge in
                    DailyChallengeRow(
                        challenge: challenge,
                        isExpanded: expandedChallengeID == challenge.id
                    )
                    .onTapGesture {
                        withAnimation(DesignSystem.animation.smooth) {
                            expandedChallengeID = expandedChallengeID == challenge.id ? nil : challenge.id
                        }
                    }
                }
            }
            
            // Show more button
            if manager.todaysChallenges.count > 3 {
                Button {
                    withAnimation(DesignSystem.animation.smooth) {
                        showAllChallenges.toggle()
                    }
                } label: {
                    HStack {
                        Text(showAllChallenges ? "Show less" : "Show all challenges")
                            .font(DesignSystem.text.labelMedium)
                        Image(systemName: showAllChallenges ? "chevron.up" : "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(BrandTheme.accent)
                }
            }
        }
        .brandCard()
    }
}

struct DailyChallengeRow: View {
    let challenge: DailyChallenge
    var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(challenge.isCompleted ? BrandTheme.success.opacity(0.15) : BrandTheme.accent.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: challenge.isCompleted ? "checkmark" : challenge.iconSystemName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(challenge.isCompleted ? BrandTheme.success : BrandTheme.accent)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(challenge.title)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                        .strikethrough(challenge.isCompleted)
                    
                    Text("\(challenge.progress)/\(challenge.targetCount)")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                XPChip(xp: challenge.bonusXP, size: .small)
            }
            
            // Progress bar
            AnimatedProgressBar(
                progress: challenge.progressRatio,
                height: 6,
                color: challenge.isCompleted ? BrandTheme.success : BrandTheme.accent
            )
            
            // Expanded details
            if isExpanded {
                Text(challenge.description)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .padding(.top, DesignSystem.spacing.xs)
            }
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

// MARK: - Combo Display

struct ComboDisplay: View {
    let combo: ComboSystem
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showCombo = false
    
    var body: some View {
        if combo.currentCombo > 1 {
            HStack(spacing: DesignSystem.spacing.sm) {
                // Combo counter with optimized animation
                if reduceMotion {
                    StaticComboCounter(combo: combo.currentCombo)
                } else {
                    AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
                        let scale = computeScale(for: timeline.date)
                        
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [BrandTheme.warning, BrandTheme.error],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 28
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .scaleEffect(scale)
                            
                            Text("\(combo.currentCombo)x")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(combo.comboLabel)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text(String(format: "%.1fx Multiplier", combo.multiplier))
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.warning)
                    
                    // Timer bar
                    if combo.timeRemaining > 0 {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(BrandTheme.borderSubtle)
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        LinearGradient(
                                            colors: [BrandTheme.warning, BrandTheme.error],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * CGFloat(combo.timeRemaining / combo.comboWindowSeconds))
                            }
                        }
                        .frame(height: 4)
                    }
                }
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [BrandTheme.warning.opacity(0.5), BrandTheme.error.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: BrandTheme.warning.opacity(0.25), radius: 10, y: 4)
            .scaleEffect(showCombo ? 1 : 0.85)
            .opacity(showCombo ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0.1)) {
                    showCombo = true
                }
            }
        }
    }
    
    private func computeScale(for date: Date) -> CGFloat {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = sin(seconds * 4) // Faster pulse for urgency
        return 1.0 + CGFloat(cycle) * 0.06
    }
}

private struct StaticComboCounter: View {
    let combo: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [BrandTheme.warning, BrandTheme.error],
                        center: .center,
                        startRadius: 0,
                        endRadius: 28
                    )
                )
                .frame(width: 50, height: 50)
            
            Text("\(combo)x")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Mood Tracker Card

struct MoodTrackerCard: View {
    @ObservedObject var tracker: MoodTracker
    @State private var showMoodPicker = false
    @State private var selectedMood: MoodState?
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            // Header
            HStack {
                IconContainer(
                    systemName: "face.smiling.fill",
                    color: BrandTheme.mind,
                    size: .medium,
                    style: .soft
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("How are you feeling?")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if let mood = tracker.currentMood {
                        Text("Current: \(mood.emoji) \(mood.label)")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
                
                Spacer()
                
                if tracker.shouldPromptCheckIn {
                    Circle()
                        .fill(BrandTheme.error)
                        .frame(width: 8, height: 8)
                }
            }
            
            // Mood selector
            if showMoodPicker {
                MoodPickerGrid(
                    selectedMood: $selectedMood,
                    onSelect: { mood in
                        tracker.logMood(mood)
                        withAnimation(DesignSystem.animation.smooth) {
                            showMoodPicker = false
                        }
                        HapticsEngine.lightImpact()
                    }
                )
            } else {
                // Quick mood display
                HStack(spacing: DesignSystem.spacing.sm) {
                    ForEach(MoodState.allCases.prefix(4)) { mood in
                        MoodQuickButton(
                            mood: mood,
                            isSelected: tracker.currentMood == mood
                        ) {
                            tracker.logMood(mood)
                            HapticsEngine.lightImpact()
                        }
                    }
                    
                    Button {
                        withAnimation(DesignSystem.animation.smooth) {
                            showMoodPicker = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(BrandTheme.mutedText)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(BrandTheme.cardBackgroundElevated)
                            )
                    }
                }
            }
            
            // Insight
            if let insight = tracker.dominantMoodToday {
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(BrandTheme.warning)
                    
                    Text(insight.suggestedTaskType)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                }
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                        .fill(BrandTheme.warning.opacity(0.1))
                )
            }
        }
        .brandCard()
    }
}

struct MoodQuickButton: View {
    let mood: MoodState
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(mood.emoji)
                .font(.system(size: 24))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? mood.color.opacity(0.2) : BrandTheme.cardBackgroundElevated)
                        .overlay(
                            Circle()
                                .strokeBorder(isSelected ? mood.color : Color.clear, lineWidth: 2)
                        )
                )
        }
        .scaleEffect(isSelected ? 1.1 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MoodPickerGrid: View {
    @Binding var selectedMood: MoodState?
    let onSelect: (MoodState) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignSystem.spacing.md) {
            ForEach(MoodState.allCases) { mood in
                Button {
                    selectedMood = mood
                    onSelect(mood)
                } label: {
                    VStack(spacing: DesignSystem.spacing.sm) {
                        Text(mood.emoji)
                            .font(.system(size: 32))
                        
                        Text(mood.label)
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                            .fill(selectedMood == mood ? mood.color.opacity(0.15) : BrandTheme.cardBackgroundElevated)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                            .strokeBorder(selectedMood == mood ? mood.color : Color.clear, lineWidth: 2)
                    )
                }
            }
        }
    }
}

// MARK: - Skill Tree View

struct SkillTreeView: View {
    @ObservedObject var manager: SkillTreeManager
    @State private var selectedDimension: LifeDimension = .mind
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.spacing.xl) {
                // Header
                VStack(spacing: DesignSystem.spacing.md) {
                    IconContainer(
                        systemName: "chart.bar.doc.horizontal.fill",
                        color: BrandTheme.accent,
                        size: .hero,
                        style: .gradient
                    )
                    
                    Text("Skill Tree")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("\(manager.totalUnlocked)/\(manager.nodes.count) Skills Unlocked")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.mutedText)
                }
                .padding(.top, DesignSystem.spacing.xl)
                
                // Dimension selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.spacing.md) {
                        ForEach(LifeDimension.allCases, id: \.self) { dimension in
                            DimensionTab(
                                dimension: dimension,
                                isSelected: selectedDimension == dimension,
                                unlockedCount: manager.nodesForDimension(dimension).filter { $0.isUnlocked }.count,
                                totalCount: manager.nodesForDimension(dimension).count
                            ) {
                                withAnimation(DesignSystem.animation.smooth) {
                                    selectedDimension = dimension
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                }
                
                // Skill nodes
                VStack(spacing: DesignSystem.spacing.lg) {
                    ForEach(manager.nodesForDimension(selectedDimension)) { node in
                        SkillNodeCard(node: node)
                            .bounceOnAppear(delay: Double(node.tier) * 0.1)
                    }
                }
                .padding(.horizontal, DesignSystem.spacing.lg)
            }
            .padding(.bottom, DesignSystem.spacing.xxl)
        }
        .background(BrandBackground(animated: true, intensity: 0.5))
    }
}

struct DimensionTab: View {
    let dimension: LifeDimension
    let isSelected: Bool
    let unlockedCount: Int
    let totalCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.spacing.sm) {
                Image(systemName: dimension.iconSystemName)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(dimension.label)
                    .font(DesignSystem.text.labelSmall)
                
                Text("\(unlockedCount)/\(totalCount)")
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .white : BrandTheme.dimensionColor(dimension))
            .padding(.horizontal, DesignSystem.spacing.lg)
            .padding(.vertical, DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(isSelected ? BrandTheme.dimensionColor(dimension) : BrandTheme.dimensionColor(dimension).opacity(0.1))
            )
        }
    }
}

struct SkillNodeCard: View {
    let node: SkillNode
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.lg) {
                // Node icon
                ZStack {
                    Circle()
                        .fill(node.isUnlocked ?
                              BrandTheme.dimensionColor(node.dimension) :
                              BrandTheme.borderSubtle
                        )
                        .frame(width: 56, height: 56)
                    
                    if node.isUnlocked {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 56, height: 56)
                    }
                    
                    Image(systemName: node.iconSystemName)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(node.isUnlocked ? .white : BrandTheme.mutedText)
                    
                    if !node.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(BrandTheme.mutedText)
                            .offset(x: 18, y: 18)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(node.name)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(node.isUnlocked ? BrandTheme.textPrimary : BrandTheme.mutedText)
                        
                        ChipView(
                            text: node.tierLabel,
                            color: BrandTheme.dimensionColor(node.dimension),
                            size: .small
                        )
                        .opacity(node.isUnlocked ? 1 : 0.5)
                    }
                    
                    Text(node.description)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                    
                    if !node.isUnlocked {
                        Text("Requires \(node.xpRequired) XP in \(node.dimension.label)")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                    } else if let date = node.unlockedDate {
                        Text("Unlocked \(date, style: .relative) ago")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.success)
                    }
                }
                
                Spacer()
            }
            
            // Connection line to next tier
            if node.tier < 5 {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    node.isUnlocked ? BrandTheme.dimensionColor(node.dimension) : BrandTheme.borderSubtle,
                                    BrandTheme.borderSubtle.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 3, height: 30)
                    Spacer()
                }
            }
        }
        .padding(DesignSystem.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                .fill(BrandTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                        .strokeBorder(
                            node.isUnlocked ?
                            BrandTheme.dimensionColor(node.dimension).opacity(0.3) :
                            BrandTheme.borderSubtle.opacity(0.3),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: node.isUnlocked ?
            BrandTheme.dimensionColor(node.dimension).opacity(0.2) :
            Color.black.opacity(0.05),
            radius: 12,
            y: 6
        )
        .opacity(node.isUnlocked ? 1 : 0.7)
    }
}

// MARK: - Personal Goals Card

struct PersonalGoalsCard: View {
    @ObservedObject var manager: PersonalGoalsManager
    @State private var showAddGoal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            // Header
            HStack {
                IconContainer(
                    systemName: "flag.fill",
                    color: BrandTheme.success,
                    size: .medium,
                    style: .gradient
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Personal Goals")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("\(manager.activeGoals.count) active goals")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                Button {
                    showAddGoal = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(BrandTheme.accent)
                }
            }
            
            // Goals list
            if manager.activeGoals.isEmpty {
                EmptyGoalsState(onAdd: { showAddGoal = true })
            } else {
                VStack(spacing: DesignSystem.spacing.md) {
                    ForEach(manager.activeGoals.prefix(3)) { goal in
                        PersonalGoalRow(goal: goal, manager: manager)
                    }
                }
            }
            
            // Urgent goals warning
            if !manager.urgentGoals.isEmpty {
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(BrandTheme.warning)
                    
                    Text("\(manager.urgentGoals.count) goal(s) due within a week")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.warning)
                }
                .padding(DesignSystem.spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.sm, style: .continuous)
                        .fill(BrandTheme.warning.opacity(0.1))
                )
            }
        }
        .brandCard()
        .sheet(isPresented: $showAddGoal) {
            AddGoalSheet(manager: manager)
        }
    }
}

struct EmptyGoalsState: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 32))
                .foregroundColor(BrandTheme.mutedText)
            
            Text("No personal goals yet")
                .font(DesignSystem.text.bodyMedium)
                .foregroundColor(BrandTheme.textSecondary)
            
            Button(action: onAdd) {
                Text("Create your first goal")
                    .font(DesignSystem.text.labelMedium)
            }
            .buttonStyle(SoftButtonStyle(color: BrandTheme.success))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.spacing.xl)
    }
}

struct PersonalGoalRow: View {
    let goal: PersonalGoal
    @ObservedObject var manager: PersonalGoalsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack(spacing: DesignSystem.spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: goal.color, default: BrandTheme.accent).opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: goal.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: goal.color, default: BrandTheme.accent))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.title)
                        .font(DesignSystem.text.labelLarge)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if let days = goal.daysRemaining {
                        Text("\(days) days remaining")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(days <= 3 ? BrandTheme.error : BrandTheme.mutedText)
                    }
                }
                
                Spacer()
                
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(BrandTheme.borderSubtle, lineWidth: 3)
                        .frame(width: 36, height: 36)
                    
                    Circle()
                        .trim(from: 0, to: goal.progress)
                        .stroke(Color(hex: goal.color, default: BrandTheme.accent), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 36, height: 36)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(goal.progress * 100))")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(BrandTheme.textSecondary)
                }
            }
            
            // Milestones preview
            if !goal.milestones.isEmpty {
                HStack(spacing: DesignSystem.spacing.xs) {
                    ForEach(goal.milestones.prefix(5)) { milestone in
                        Circle()
                            .fill(milestone.isCompleted ? BrandTheme.success : BrandTheme.borderSubtle)
                            .frame(width: 8, height: 8)
                    }
                    
                    if goal.milestones.count > 5 {
                        Text("+\(goal.milestones.count - 5)")
                            .font(.caption2)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
            }
        }
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackgroundElevated.opacity(0.5))
        )
    }
}

struct AddGoalSheet: View {
    @ObservedObject var manager: PersonalGoalsManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var hasDeadline = false
    @State private var targetDate = Date().addingTimeInterval(604800) // 1 week default
    @State private var selectedDimensions: Set<LifeDimension> = []
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "6366F1"
    
    let iconOptions = ["star.fill", "flag.fill", "target", "heart.fill", "bolt.fill", "leaf.fill", "book.fill", "globe", "sparkles", "flame.fill"]
    let colorOptions = ["6366F1", "EC4899", "10B981", "F59E0B", "8B5CF6", "3B82F6", "EF4444", "14B8A6"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xl) {
                    // Title input
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Goal Title")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        TextField("What do you want to achieve?", text: $title)
                            .textFieldStyle(.plain)
                            .font(DesignSystem.text.bodyLarge)
                            .padding(DesignSystem.spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                    .fill(BrandTheme.cardBackgroundElevated)
                            )
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Description (optional)")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        TextField("Why is this important?", text: $description, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(DesignSystem.text.bodyMedium)
                            .lineLimit(3...5)
                            .padding(DesignSystem.spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                                    .fill(BrandTheme.cardBackgroundElevated)
                            )
                    }
                    
                    // Icon picker
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Icon")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignSystem.spacing.md) {
                                ForEach(iconOptions, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIcon == icon ? .white : Color(hex: selectedColor, default: BrandTheme.accent))
                                            .frame(width: 44, height: 44)
                                            .background(
                                                Circle()
                                                    .fill(selectedIcon == icon ? Color(hex: selectedColor, default: BrandTheme.accent) : Color(hex: selectedColor, default: BrandTheme.accent).opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                    }
                    
                    // Color picker
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Color")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        HStack(spacing: DesignSystem.spacing.md) {
                            ForEach(colorOptions, id: \.self) { color in
                                Button {
                                    selectedColor = color
                                } label: {
                                    Circle()
                                        .fill(Color(hex: color, default: .gray))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(.white, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                        .shadow(color: selectedColor == color ? Color(hex: color, default: .gray).opacity(0.5) : .clear, radius: 6)
                                }
                            }
                        }
                    }
                    
                    // Deadline toggle
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                        Toggle(isOn: $hasDeadline) {
                            Text("Set a deadline")
                                .font(DesignSystem.text.labelLarge)
                                .foregroundColor(BrandTheme.textPrimary)
                        }
                        .tint(BrandTheme.accent)
                        
                        if hasDeadline {
                            DatePicker("Target date", selection: $targetDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .tint(Color(hex: selectedColor, default: BrandTheme.accent))
                        }
                    }
                    
                    // Dimensions
                    VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                        Text("Related Dimensions")
                            .font(DesignSystem.text.labelMedium)
                            .foregroundColor(BrandTheme.textSecondary)
                        
                        HStack(spacing: DesignSystem.spacing.md) {
                            ForEach(LifeDimension.allCases, id: \.self) { dimension in
                                Button {
                                    if selectedDimensions.contains(dimension) {
                                        selectedDimensions.remove(dimension)
                                    } else {
                                        selectedDimensions.insert(dimension)
                                    }
                                } label: {
                                    HStack(spacing: DesignSystem.spacing.sm) {
                                        Image(systemName: dimension.iconSystemName)
                                        Text(dimension.label)
                                    }
                                    .font(DesignSystem.text.labelSmall)
                                    .foregroundColor(selectedDimensions.contains(dimension) ? .white : BrandTheme.dimensionColor(dimension))
                                    .padding(.horizontal, DesignSystem.spacing.md)
                                    .padding(.vertical, DesignSystem.spacing.sm)
                                    .background(
                                        Capsule()
                                            .fill(selectedDimensions.contains(dimension) ? BrandTheme.dimensionColor(dimension) : BrandTheme.dimensionColor(dimension).opacity(0.1))
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let goal = PersonalGoal(
                            title: title,
                            description: description,
                            targetDate: hasDeadline ? targetDate : nil,
                            dimensions: Array(selectedDimensions),
                            iconName: selectedIcon,
                            color: selectedColor
                        )
                        manager.addGoal(goal)
                        HapticsEngine.success()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - Weekly Review Card

struct WeeklyReviewCard: View {
    @ObservedObject var manager: WeeklyReviewManager
    @State private var showFullReview = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            // Header
            HStack {
                IconContainer(
                    systemName: "calendar.badge.checkmark",
                    color: BrandTheme.info,
                    size: .medium,
                    style: .soft
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("This Week")
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("\(manager.currentWeekProgress.xpEarned) XP earned")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
                
                if manager.currentWeekProgress.xpEarned > manager.averageWeeklyXP {
                    ChipView(text: "Above average!", icon: "arrow.up", color: BrandTheme.success, size: .small)
                }
            }
            
            // Quick stats
            HStack(spacing: DesignSystem.spacing.lg) {
                WeekStatItem(
                    value: "\(manager.currentWeekProgress.itemsCompleted)",
                    label: "Items",
                    icon: "checkmark.circle.fill",
                    color: BrandTheme.success
                )
                
                WeekStatItem(
                    value: "\(manager.currentWeekProgress.questsCompleted)",
                    label: "Quests",
                    icon: "flag.fill",
                    color: BrandTheme.warning
                )
                
                WeekStatItem(
                    value: "\(manager.currentWeekProgress.xpEarned)",
                    label: "XP",
                    icon: "star.fill",
                    color: BrandTheme.accent
                )
            }
            
            // Previous week comparison
            if let lastReview = manager.latestReview {
                HStack(spacing: DesignSystem.spacing.md) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(BrandTheme.mutedText)
                    
                    Text("Last week: \(lastReview.totalXPEarned) XP, \(lastReview.itemsCompleted) items")
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.textSecondary)
                }
                
                Button {
                    showFullReview = true
                } label: {
                    Text("View past weeks")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.accent)
                }
            }
        }
        .brandCard()
        .sheet(isPresented: $showFullReview) {
            WeeklyReviewSheet(manager: manager)
        }
    }
}

struct WeekStatItem: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(label)
                .font(DesignSystem.text.labelSmall)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeeklyReviewSheet: View {
    @ObservedObject var manager: WeeklyReviewManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.spacing.xl) {
                    ForEach(manager.reviews) { review in
                        WeeklyReviewRow(review: review)
                    }
                    
                    if manager.reviews.isEmpty {
                        EmptyStateView(
                            icon: "calendar",
                            title: "No reviews yet",
                            message: "Complete your first week to see your review"
                        )
                    }
                }
                .padding(DesignSystem.spacing.lg)
            }
            .background(BrandBackgroundStatic())
            .navigationTitle("Weekly Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct WeeklyReviewRow: View {
    let review: WeeklyReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                Text(review.formattedDateRange)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)
                
                Spacer()
                
                XPChip(xp: review.totalXPEarned, size: .medium)
            }
            
            HStack(spacing: DesignSystem.spacing.lg) {
                Label("\(review.itemsCompleted) items", systemImage: "checkmark.circle.fill")
                Label("\(review.questsCompleted) quests", systemImage: "flag.fill")
            }
            .font(DesignSystem.text.bodySmall)
            .foregroundColor(BrandTheme.textSecondary)
            
            Text(review.insight)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
                .italic()
        }
        .brandCard()
    }
}

// MARK: - Seasonal Event Banner

struct SeasonalEventBanner: View {
    let event: SeasonalEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: event.themeColor, default: BrandTheme.accent), Color(hex: event.themeColor, default: BrandTheme.accent).opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: event.iconSystemName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(event.name)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        ChipView(
                            text: String(format: "%.1fx XP", event.bonusMultiplier),
                            icon: "sparkles",
                            color: Color(hex: event.themeColor, default: BrandTheme.accent),
                            size: .small
                        )
                    }
                    
                    Text("\(event.daysRemaining) days remaining")
                        .font(DesignSystem.text.labelSmall)
                        .foregroundColor(BrandTheme.mutedText)
                }
                
                Spacer()
            }
            
            Text(event.description)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.textSecondary)
            
            // Progress to end
            AnimatedProgressBar(
                progress: event.progress,
                height: 6,
                color: Color(hex: event.themeColor, default: BrandTheme.accent)
            )
        }
        .padding(DesignSystem.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                .fill(BrandTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: event.themeColor, default: BrandTheme.accent).opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                .strokeBorder(Color(hex: event.themeColor, default: BrandTheme.accent).opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Smart Insights Card

struct SmartInsightsCard: View {
    @ObservedObject var engine: InsightsEngine
    @State private var currentInsightIndex = 0
    
    var body: some View {
        if let insight = engine.topInsight {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                HStack {
                    IconContainer(
                        systemName: insight.iconSystemName,
                        color: insight.color,
                        size: .medium,
                        style: .soft
                    )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(insight.title)
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Text("Smart Insight")
                            .font(DesignSystem.text.labelSmall)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                    
                    Spacer()
                    
                    if engine.insights.count > 1 {
                        Button {
                            withAnimation(DesignSystem.animation.smooth) {
                                currentInsightIndex = (currentInsightIndex + 1) % engine.insights.count
                            }
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(BrandTheme.accent)
                        }
                    }
                }
                
                Text(insight.message)
                    .font(DesignSystem.text.bodyMedium)
                    .foregroundColor(BrandTheme.textSecondary)
                
                if let actionLabel = insight.actionLabel {
                    Button(actionLabel) {
                        // Action would be handled by parent
                    }
                    .buttonStyle(SoftButtonStyle(color: insight.color))
                }
            }
            .brandCard(enableGlow: true, glowColor: insight.color)
        }
    }
}

// MARK: - Time of Day Greeting

struct TimeOfDayGreeting: View {
    let timeOfDay = TimeOfDay.current
    let userName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            Text(timeOfDay.greeting)
                .font(DesignSystem.text.displaySmall)
                .foregroundColor(BrandTheme.textPrimary)
            
            if let name = userName {
                Text("Welcome back, \(name)")
                    .font(DesignSystem.text.bodyMedium)
                    .foregroundColor(BrandTheme.textSecondary)
            }
            
            Text(timeOfDay.suggestion)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
        }
    }
}

// MARK: - Animated Mascot

struct AnimatedMascot: View {
    let mood: MascotMood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    enum MascotMood {
        case happy, excited, encouraging, celebrating, thinking
        
        var mainColor: Color {
            switch self {
            case .happy: return BrandTheme.success
            case .excited: return BrandTheme.warning
            case .encouraging: return BrandTheme.accent
            case .celebrating: return BrandTheme.love
            case .thinking: return BrandTheme.mind
            }
        }
    }
    
    var body: some View {
        if reduceMotion {
            StaticMascotContent(mood: mood)
        } else {
            AdaptiveTimelineView(minimumInterval: 1.0 / 120) { timeline in
                let (bounce, blink) = computeAnimationState(for: timeline.date)
                
                ZStack {
                    // Body with gentle bounce
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [mood.mainColor, mood.mainColor.opacity(0.8)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 48
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(bounce)
                    
                    // Face
                    VStack(spacing: 8) {
                        // Eyes
                        HStack(spacing: 16) {
                            MascotEye(isBlinking: blink)
                            MascotEye(isBlinking: blink)
                        }
                        
                        // Mouth
                        MascotMouth(mood: mood)
                    }
                    .offset(y: -4)
                    
                    // Sparkles for celebrating mood (static positioned)
                    if mood == .celebrating {
                        CelebrationSparkles(date: timeline.date)
                    }
                }
            }
        }
    }
    
    private func computeAnimationState(for date: Date) -> (bounce: CGFloat, blink: Bool) {
        let seconds = date.timeIntervalSinceReferenceDate
        
        // Gentle bounce
        let bounceCycle = sin(seconds * 2.5)
        let bounce = 1.0 + CGFloat(bounceCycle) * 0.05
        
        // Periodic blink (every ~3 seconds for 0.15 seconds)
        let blinkCycle = seconds.truncatingRemainder(dividingBy: 3.0)
        let blink = blinkCycle < 0.15
        
        return (bounce, blink)
    }
}

private struct StaticMascotContent: View {
    let mood: AnimatedMascot.MascotMood
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [mood.mainColor, mood.mainColor.opacity(0.8)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 48
                    )
                )
                .frame(width: 80, height: 80)
            
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    MascotEye(isBlinking: false)
                    MascotEye(isBlinking: false)
                }
                MascotMouth(mood: mood)
            }
            .offset(y: -4)
        }
    }
}

private struct CelebrationSparkles: View {
    let date: Date
    
    // Pre-computed sparkle positions
    private let sparklePositions: [(x: CGFloat, y: CGFloat)] = [
        (-35, -35), (35, -30), (-40, 10), (40, 15), (-25, 40), (30, 38)
    ]
    
    var body: some View {
        ForEach(0..<6) { i in
            let opacity = computeSparkleOpacity(index: i)
            
            Image(systemName: "sparkle")
                .font(.system(size: 10))
                .foregroundColor(.white)
                .opacity(opacity)
                .offset(x: sparklePositions[i].x, y: sparklePositions[i].y)
        }
    }
    
    private func computeSparkleOpacity(index: Int) -> Double {
        let seconds = date.timeIntervalSinceReferenceDate
        let offset = Double(index) * 0.5
        let cycle = sin((seconds + offset) * 3)
        return 0.5 + cycle * 0.5
    }
}

private struct MascotEye: View {
    let isBlinking: Bool
    
    var body: some View {
        Ellipse()
            .fill(.white)
            .frame(width: 12, height: isBlinking ? 2 : 14)
            .overlay(
                Circle()
                    .fill(.black)
                    .frame(width: 6, height: 6)
                    .offset(y: 2)
                    .opacity(isBlinking ? 0 : 1)
            )
    }
}

private struct MascotMouth: View {
    let mood: AnimatedMascot.MascotMood
    
    var body: some View {
        switch mood {
        case .happy, .celebrating:
            MascotArcShape(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                .stroke(.white, lineWidth: 3)
                .frame(width: 20, height: 10)
        case .excited:
            Circle()
                .fill(.white)
                .frame(width: 12, height: 12)
        case .encouraging:
            RoundedRectangle(cornerRadius: 2)
                .fill(.white)
                .frame(width: 14, height: 4)
        case .thinking:
            MascotArcShape(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
                .stroke(.white, lineWidth: 3)
                .frame(width: 16, height: 6)
        }
    }
}

private struct MascotArcShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: clockwise ? rect.minY : rect.maxY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        return path
    }
}

// MARK: - Swipeable Item Row

struct SwipeableItemRow<Content: View>: View {
    let content: Content
    let onComplete: () -> Void
    let onSkip: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showComplete = false
    @State private var showSkip = false
    
    private let swipeThreshold: CGFloat = 100
    
    init(@ViewBuilder content: () -> Content, onComplete: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.content = content()
        self.onComplete = onComplete
        self.onSkip = onSkip
    }
    
    var body: some View {
        ZStack {
            // Background actions
            HStack {
                // Complete action (swipe right)
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                    Text("Complete")
                        .font(DesignSystem.text.labelMedium)
                }
                .foregroundColor(.white)
                .frame(width: abs(min(0, offset)), alignment: .leading)
                .padding(.leading, DesignSystem.spacing.lg)
                .opacity(showComplete ? 1 : 0)
                
                Spacer()
                
                // Skip action (swipe left)
                HStack {
                    Text("Skip")
                        .font(DesignSystem.text.labelMedium)
                    Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                }
                .foregroundColor(.white)
                .frame(width: abs(max(0, offset)), alignment: .trailing)
                .padding(.trailing, DesignSystem.spacing.lg)
                .opacity(showSkip ? 1 : 0)
            }
            .background(
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(BrandTheme.success)
                        .opacity(offset > 0 ? 1 : 0)
                    
                    Rectangle()
                        .fill(BrandTheme.warning)
                        .opacity(offset < 0 ? 1 : 0)
                }
            )
            .cornerRadius(DesignSystem.radius.lg)
            
            // Content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                            showComplete = offset > swipeThreshold / 2
                            showSkip = offset < -swipeThreshold / 2
                        }
                        .onEnded { value in
                            if offset > swipeThreshold {
                                // Complete
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    offset = 500
                                }
                                HapticsEngine.success()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onComplete()
                                }
                            } else if offset < -swipeThreshold {
                                // Skip
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    offset = -500
                                }
                                HapticsEngine.lightImpact()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSkip()
                                }
                            } else {
                                // Reset
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    offset = 0
                                    showComplete = false
                                    showSkip = false
                                }
                            }
                        }
                )
        }
    }
}

// MARK: - Badge Trophy Case (simplified badge showcase)

struct BadgeTrophyCaseView: View {
    let badges: [Badge]
    let unlockedBadgeIDs: Set<String>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.spacing.xl) {
                // Header
                VStack(spacing: DesignSystem.spacing.md) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [BrandTheme.warning, BrandTheme.warning.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.white)
                    }
                    .shadow(color: BrandTheme.warning.opacity(0.4), radius: 20, y: 10)
                    
                    Text("Trophy Case")
                        .font(DesignSystem.text.displaySmall)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    Text("\(unlockedBadgeIDs.count)/\(badges.count) Achievements")
                        .font(DesignSystem.text.bodyMedium)
                        .foregroundColor(BrandTheme.mutedText)
                }
                .padding(.top, DesignSystem.spacing.xl)
                
                // Trophy grid
                LazyVGrid(columns: columns, spacing: DesignSystem.spacing.lg) {
                    ForEach(badges) { badge in
                        TrophyItem(
                            badge: badge,
                            isUnlocked: unlockedBadgeIDs.contains(badge.id)
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.spacing.lg)
            }
            .padding(.bottom, DesignSystem.spacing.xxl)
        }
        .background(BrandBackground(animated: true, intensity: 0.5))
    }
}

struct TrophyItem: View {
    let badge: Badge
    let isUnlocked: Bool
    @State private var showDetail = false
    
    var body: some View {
        Button {
            showDetail = true
        } label: {
            VStack(spacing: DesignSystem.spacing.sm) {
                // Trophy icon with 3D effect
                ZStack {
                    // Shadow/depth
                    Circle()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: 70, height: 70)
                        .offset(y: 4)
                    
                    // Main trophy
                    Circle()
                        .fill(
                            isUnlocked ?
                            LinearGradient(
                                colors: [BrandTheme.warning, BrandTheme.warning.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [BrandTheme.borderSubtle, BrandTheme.borderSubtle.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    // Shine effect
                    if isUnlocked {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white.opacity(0.4), .clear],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 70, height: 70)
                    }
                    
                    // Icon
                    Image(systemName: isUnlocked ? badge.iconSystemName : "lock.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(isUnlocked ? .white : BrandTheme.mutedText)
                }
                
                Text(badge.name)
                    .font(DesignSystem.text.labelSmall)
                    .foregroundColor(isUnlocked ? BrandTheme.textPrimary : BrandTheme.mutedText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .opacity(isUnlocked ? 1 : 0.6)
        .sheet(isPresented: $showDetail) {
            TrophyDetailSheet(badge: badge, isUnlocked: isUnlocked)
                .presentationDetents([.medium])
        }
    }
}

struct TrophyDetailSheet: View {
    let badge: Badge
    let isUnlocked: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xl) {
            // Trophy with celebration
            ZStack {
                if isUnlocked {
                    ForEach(0..<8) { i in
                        Image(systemName: "sparkle")
                            .font(.system(size: 16))
                            .foregroundColor(BrandTheme.warning.opacity(0.7))
                            .offset(
                                x: cos(Double(i) * .pi / 4) * 60,
                                y: sin(Double(i) * .pi / 4) * 60
                            )
                    }
                }
                
                Circle()
                    .fill(
                        isUnlocked ?
                        LinearGradient(
                            colors: [BrandTheme.warning, BrandTheme.warning.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [BrandTheme.borderSubtle, BrandTheme.borderSubtle.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: isUnlocked ? BrandTheme.warning.opacity(0.4) : .clear, radius: 20, y: 10)
                
                Image(systemName: isUnlocked ? badge.iconSystemName : "lock.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(isUnlocked ? .white : BrandTheme.mutedText)
            }
            
            Text(badge.name)
                .font(DesignSystem.text.headlineLarge)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(badge.description)
                .font(DesignSystem.text.bodyMedium)
                .foregroundColor(BrandTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.spacing.xl)
            
            if !isUnlocked {
                Text("Complete the requirements to unlock this trophy")
                    .font(DesignSystem.text.labelMedium)
                    .foregroundColor(BrandTheme.mutedText)
            }
            
            Spacer()
            
            Button("Done") {
                dismiss()
            }
            .buttonStyle(GlowButtonStyle(color: isUnlocked ? BrandTheme.warning : BrandTheme.accent))
        }
        .padding(DesignSystem.spacing.xl)
        .background(BrandBackgroundStatic())
    }
}
