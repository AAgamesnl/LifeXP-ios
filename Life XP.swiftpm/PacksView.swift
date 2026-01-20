import SwiftUI

// MARK: - Packs View

struct PacksView: View {
    @Environment(AppModel.self) private var model
    @State private var searchText = ""
    
    private var filteredPacks: [CategoryPack] {
        guard !searchText.isEmpty else { return model.packs }
        return model.packs.filter { pack in
            pack.title.localizedCaseInsensitiveContains(searchText) ||
            pack.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var inProgressPacks: [CategoryPack] {
        model.packs.filter { model.progress(for: $0) > 0 && model.progress(for: $0) < 1 }
    }

    private var completedPacks: [CategoryPack] {
        model.packs.filter { model.progress(for: $0) >= 1 }
    }

    private var premiumPacks: [CategoryPack] {
        model.packs.filter { $0.isPremium }
    }

    private var recommendedPacks: [CategoryPack] {
        let inProgressIDs = Set(inProgressPacks.map(\.id))
        let completedIDs = Set(completedPacks.map(\.id))
        let premiumIDs = Set(premiumPacks.map(\.id))
        return model.featuredPacks.filter { pack in
            !inProgressIDs.contains(pack.id) &&
            !completedIDs.contains(pack.id) &&
            !premiumIDs.contains(pack.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScreenBackground {
                ScrollView {
                    VStack(spacing: DesignSystem.spacing.lg) {
                        TrainingModeHeader()

                        PacksStatsHeader()

                        if !searchText.isEmpty {
                            PackSearchResultsSection(packs: filteredPacks)
                        } else {
                            PackDeckSection(title: L10n.trainingSectionInProgress, packs: inProgressPacks)
                            PackDeckSection(title: L10n.trainingSectionRecommended, packs: recommendedPacks)
                            PackDeckSection(title: L10n.trainingSectionCompleted, packs: completedPacks)
                            PackDeckSection(title: L10n.trainingSectionPremium, packs: premiumPacks)
                        }
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.bottom, DesignSystem.spacing.xxl)
                }
                .trackScrollActivity()
            }
            .navigationTitle(L10n.trainingModeTitle)
            .searchable(text: $searchText, prompt: L10n.packsSearchPrompt)
        }
    }
}

// MARK: - Training Mode Header

struct TrainingModeHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
            Text(L10n.trainingModeTitle)
                .font(DesignSystem.text.headlineLarge)
                .foregroundColor(BrandTheme.textPrimary)

            Text(L10n.trainingModeSubtitle)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Packs Stats Header

struct PacksStatsHeader: View {
    @Environment(AppModel.self) private var model
    
    private var completedPacks: Int {
        model.packs.filter { model.progress(for: $0) >= 1 }.count
    }
    
    private var inProgressPacks: Int {
        model.packs.filter { model.progress(for: $0) > 0 && model.progress(for: $0) < 1 }.count
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.md) {
            PackStatTile(
                icon: "checklist.checked",
                value: "\(completedPacks)",
                label: "Completed",
                color: BrandTheme.success
            )
            
            PackStatTile(
                icon: "clock.arrow.circlepath",
                value: "\(inProgressPacks)",
                label: "In Progress",
                color: BrandTheme.warning
            )
            
            PackStatTile(
                icon: "star.fill",
                value: "\(model.totalXP)",
                label: "Total XP",
                color: BrandTheme.accent
            )
        }
    }
}

struct PackStatTile: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.text.headlineMedium)
                .foregroundColor(BrandTheme.textPrimary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Pack Deck Section

struct PackDeckSection: View {
    let title: LocalizedStringKey
    let packs: [CategoryPack]

    var body: some View {
        if !packs.isEmpty {
            VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
                Text(title)
                    .font(DesignSystem.text.headlineMedium)
                    .foregroundColor(BrandTheme.textPrimary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.spacing.md) {
                        ForEach(packs) { pack in
                            NavigationLink(destination: PackDetailView(pack: pack)) {
                                PackDeckCard(pack: pack)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

struct PackDeckCard: View {
    @Environment(AppModel.self) private var model
    let pack: CategoryPack

    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }

    private var progress: Double {
        model.progress(for: pack)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.md) {
            HStack {
                IconContainer(systemName: pack.iconSystemName, color: accent, size: .small, style: .gradient)

                Spacer()

                XPChip(xp: pack.items.reduce(0) { $0 + $1.xp }, size: .small)
            }

            Text(pack.title)
                .font(DesignSystem.text.headlineSmall)
                .foregroundColor(BrandTheme.textPrimary)
                .lineLimit(2)

            Text(pack.subtitle)
                .font(DesignSystem.text.bodySmall)
                .foregroundColor(BrandTheme.mutedText)
                .lineLimit(2)

            AnimatedProgressBar(progress: progress, height: 8, color: accent)

            Text(String(format: String(localized: "progress.percentComplete", bundle: .module), Int(progress * 100)))
                .font(.caption)
                .foregroundColor(BrandTheme.mutedText)
        }
        .frame(width: 220, alignment: .leading)
        .padding(DesignSystem.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .fill(BrandTheme.cardBackground.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                .strokeBorder(accent.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Pack Search Results

struct PackSearchResultsSection: View {
    let packs: [CategoryPack]

    var body: some View {
        if packs.isEmpty {
            EmptyStateView(
                icon: "checklist",
                title: String(localized: "packs.empty.title"),
                message: String(localized: "packs.empty.message")
            )
            .padding(.top, DesignSystem.spacing.xxl)
        } else {
            LazyVStack(spacing: DesignSystem.spacing.md) {
                ForEach(packs) { pack in
                    NavigationLink(destination: PackDetailView(pack: pack)) {
                        PackCard(pack: pack)
                    }
                    .buttonStyle(CardButtonStyle())
                }
            }
        }
    }
}

// MARK: - Pack Card

struct PackCard: View {
    @Environment(AppModel.self) private var model
    let pack: CategoryPack
    
    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }
    
    private var progress: Double {
        model.progress(for: pack)
    }
    
    private var itemCount: Int {
        model.items(for: pack).count
    }
    
    private var completedCount: Int {
        model.items(for: pack).filter { model.isCompleted($0) }.count
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.spacing.lg) {
            // Icon
            IconContainer(
                systemName: pack.iconSystemName,
                color: accent,
                size: .large,
                style: progress >= 1 ? .gradient : .soft
            )
            
            // Content
            VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                HStack {
                    Text(pack.title)
                        .font(DesignSystem.text.headlineMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                    
                    if pack.isPremium {
                        ProBadge()
                    }
                    
                    if progress >= 1 {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BrandTheme.success)
                    }
                }
                
                Text(pack.subtitle)
                    .font(DesignSystem.text.bodySmall)
                    .foregroundColor(BrandTheme.mutedText)
                    .lineLimit(2)
                
                // Progress section
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    AnimatedProgressBar(progress: progress, height: 6, color: accent)
                    
                    HStack {
                        Text("\(Int(progress * 100))% complete")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                        
                        Spacer()
                        
                        Text("\(completedCount)/\(itemCount) items")
                            .font(.caption)
                            .foregroundColor(BrandTheme.mutedText)
                    }
                }
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BrandTheme.mutedText)
        }
        .brandCard()
    }
}

struct ProBadge: View {
    var body: some View {
        Text("PRO")
            .font(.system(size: 10, weight: .black))
            .foregroundColor(BrandTheme.warning)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(BrandTheme.warning.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .strokeBorder(BrandTheme.warning.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Pack Detail View

struct PackDetailView: View {
    @Environment(AppModel.self) private var model
    let pack: CategoryPack
    
    @State private var showCompletedItems = true
    @State private var searchText = ""
    
    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }
    
    private var items: [ChecklistItem] {
        var filteredItems = model.items(for: pack)
        
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                (item.detail?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        if !showCompletedItems {
            filteredItems = filteredItems.filter { !model.isCompleted($0) }
        }
        
        return filteredItems
    }
    
    private var progress: Double {
        model.progress(for: pack)
    }
    
    private var completedCount: Int {
        model.items(for: pack).filter { model.isCompleted($0) }.count
    }
    
    private var totalXP: Int {
        model.items(for: pack).reduce(0) { $0 + $1.xp }
    }
    
    private var earnedXP: Int {
        model.items(for: pack).filter { model.isCompleted($0) }.reduce(0) { $0 + $1.xp }
    }
    
    var body: some View {
        ZStack {
            BrandBackgroundStatic()
            
            ScrollView {
                VStack(spacing: DesignSystem.spacing.lg) {
                    // Header card
                    PackDetailHeader(
                        pack: pack,
                        progress: progress,
                        completedCount: completedCount,
                        totalItems: model.items(for: pack).count,
                        earnedXP: earnedXP,
                        totalXP: totalXP
                    )
                    
                    // Filter toggle
                    HStack {
                        Text("Items")
                            .font(DesignSystem.text.headlineMedium)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showCompletedItems.toggle()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: showCompletedItems ? "eye.fill" : "eye.slash.fill")
                                Text(showCompletedItems ? "Show all" : "Hide done")
                            }
                            .font(.caption.weight(.medium))
                            .foregroundColor(BrandTheme.accent)
                            .padding(.horizontal, DesignSystem.spacing.sm)
                            .padding(.vertical, DesignSystem.spacing.xs)
                            .background(
                                Capsule()
                                    .fill(BrandTheme.accent.opacity(0.1))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    
                    // Items list
                    LazyVStack(spacing: DesignSystem.spacing.sm) {
                        ForEach(items) { item in
                            ChecklistItemRow(item: item, accent: accent)
                        }
                    }
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    
                    // Empty state
                    if items.isEmpty {
                        EmptyStateView(
                            icon: "checkmark.circle.fill",
                            title: showCompletedItems ? "No items found" : "All done!",
                            message: showCompletedItems ? "Try adjusting your search." : "Great job completing all items!"
                        )
                        .padding(.top, DesignSystem.spacing.xl)
                    }
                    
                    Color.clear.frame(height: DesignSystem.spacing.xxl)
                }
            }
        }
        .navigationTitle(pack.title)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search items")
    }
}

// MARK: - Pack Detail Header

struct PackDetailHeader: View {
    let pack: CategoryPack
    let progress: Double
    let completedCount: Int
    let totalItems: Int
    let earnedXP: Int
    let totalXP: Int
    
    private var accent: Color {
        Color(hex: pack.accentColorHex, default: BrandTheme.accent)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.spacing.lg) {
            HStack(alignment: .top, spacing: DesignSystem.spacing.lg) {
                // Icon
                IconContainer(
                    systemName: pack.iconSystemName,
                    color: accent,
                    size: .hero,
                    style: progress >= 1 ? .gradient : .soft
                )
                
                // Info
                VStack(alignment: .leading, spacing: DesignSystem.spacing.sm) {
                    HStack {
                        Text(pack.title)
                            .font(DesignSystem.text.headlineLarge)
                            .foregroundColor(BrandTheme.textPrimary)
                        
                        if pack.isPremium {
                            ProBadge()
                        }
                    }
                    
                    Text(pack.subtitle)
                        .font(DesignSystem.text.bodySmall)
                        .foregroundColor(BrandTheme.mutedText)
                        .lineLimit(3)
                }
                
                Spacer()
            }
            
            // Progress section
            VStack(spacing: DesignSystem.spacing.sm) {
                AnimatedProgressBar(progress: progress, height: 10, cornerRadius: 5, color: accent, showGlow: true)
                
                HStack {
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BrandTheme.success)
                        Text("\(completedCount)/\(totalItems) items")
                    }
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
                    
                    Spacer()
                    
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Image(systemName: "star.fill")
                            .foregroundColor(BrandTheme.warning)
                        Text("\(earnedXP)/\(totalXP) XP")
                    }
                    .font(.caption)
                    .foregroundColor(BrandTheme.mutedText)
                }
            }
            
            // Completion badge
            if progress >= 1 {
                HStack(spacing: DesignSystem.spacing.sm) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(BrandTheme.warning)
                    Text("Pack completed!")
                        .font(DesignSystem.text.labelMedium)
                        .foregroundColor(BrandTheme.textPrimary)
                }
                .padding(DesignSystem.spacing.md)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                        .fill(BrandTheme.warning.opacity(0.1))
                )
            }
        }
        .elevatedCard(accentColor: accent)
        .padding(.horizontal, DesignSystem.spacing.lg)
        .padding(.top, DesignSystem.spacing.md)
    }
}

// MARK: - Checklist Item Row

struct ChecklistItemRow: View {
    @Environment(AppModel.self) private var model
    let item: ChecklistItem
    let accent: Color
    
    @State private var showPaywall = false
    @State private var isAnimating = false
    
    private var isCompleted: Bool {
        model.isCompleted(item)
    }
    
    var body: some View {
        Button {
            handleTap()
        } label: {
            HStack(alignment: .top, spacing: DesignSystem.spacing.md) {
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isCompleted ? accent : BrandTheme.borderSubtle, lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        Circle()
                            .fill(accent)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isAnimating ? 1.2 : 1)
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.spacing.xs) {
                    HStack(spacing: DesignSystem.spacing.sm) {
                        Text(item.title)
                            .font(DesignSystem.text.labelLarge)
                            .foregroundColor(isCompleted ? BrandTheme.mutedText : BrandTheme.textPrimary)
                            .strikethrough(isCompleted)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if item.isPremium {
                            ProBadge()
                        }
                    }
                    
                    if let detail = item.detail {
                        Text(detail)
                            .font(DesignSystem.text.bodySmall)
                            .foregroundColor(BrandTheme.mutedText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Tags
                    HStack(spacing: DesignSystem.spacing.sm) {
                        XPChip(xp: item.xp, size: .small)
                        
                        ForEach(item.dimensions.prefix(2)) { dim in
                            ChipView(
                                text: dim.label,
                                icon: dim.systemImage,
                                color: BrandTheme.dimensionColor(dim),
                                size: .small
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .padding(DesignSystem.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .fill(isCompleted ? BrandTheme.cardBackgroundElevated.opacity(0.5) : BrandTheme.cardBackground.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radius.md, style: .continuous)
                    .strokeBorder(
                        isCompleted ? accent.opacity(0.3) : BrandTheme.borderSubtle.opacity(0.3),
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .alert("Life XP PRO", isPresented: $showPaywall) {
            Button("Later", role: .cancel) { }
        } message: {
            Text("This item is part of Life XP PRO.\n\nYou can test PRO features via the dev toggle in Settings.")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title), \(item.xp) XP, \(isCompleted ? "completed" : "not completed")")
        .accessibilityHint("Double tap to toggle completion")
    }
    
    private func handleTap() {
        if item.isPremium && !model.premiumUnlocked {
            showPaywall = true
            return
        }
        
        let willComplete = !isCompleted
        
        // Snappy checkbox animation
        withAnimation(.spring(response: 0.25, dampingFraction: 0.75, blendDuration: 0.05)) {
            isAnimating = true
        }
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.1)) {
            model.toggle(item)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.85)) {
                isAnimating = false
            }
        }
        
        if willComplete {
            HapticsEngine.lightImpact()
        }
    }
}

// MARK: - Legacy Support

struct PackCardView: View {
    @Environment(AppModel.self) private var model
    let pack: CategoryPack
    
    var body: some View {
        PackCard(pack: pack)
            .environment(model)
    }
}

struct ChecklistRow: View {
    @Environment(AppModel.self) private var model
    let item: ChecklistItem
    let accent: Color
    
    var body: some View {
        ChecklistItemRow(item: item, accent: accent)
            .environment(model)
    }
}
