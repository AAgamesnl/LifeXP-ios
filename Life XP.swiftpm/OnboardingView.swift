import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var model: AppModel
    var onDone: () -> Void

    @State private var selectedFocuses: Set<LifeDimension> = []
    @State private var overwhelmed: Double = 3
    @State private var selectedTone: ToneMode = .soft
    @State private var step: Int = 0
    @State private var hasSyncedFromModel = false
    @State private var isAdvancing: Bool = false
    
    var body: some View {
        ZStack {
            BrandBackground()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                TabView(selection: $step) {
                    onboardingPage(index: 0) { pageWelcome }
                    onboardingPage(index: 1) { pageFocus }
                    onboardingPage(index: 2) { pageOverwhelm }
                    onboardingPage(index: 3) { pageTone }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.35), value: step)

                controlBar
                    .padding(.horizontal)
                    .padding(.bottom, DesignSystem.spacing.lg)
            }
            .frame(maxWidth: 700)
            .padding(.top, DesignSystem.spacing.xl)
            .tint(BrandTheme.accent)
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
    }
    
    private var pageWelcome: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Welkom bij Life XP")
                .font(.largeTitle.bold())
                .foregroundStyle(BrandTheme.textPrimary)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)

            Text("Je leven hoeft niet perfect te worden ingepland. Met kleine stappen, heldere prioriteiten en een frisse mindset maak je ruimte voor wat ertoe doet.")
                .font(.body)
                .foregroundStyle(BrandTheme.mutedText)
                .multilineTextAlignment(.leading)

            VStack(alignment: .leading, spacing: 12) {
                Label("Focus op de thema's die nu belangrijk zijn", systemImage: "target")
                Label("Check in met je hoofd en verlaag de ruis", systemImage: "waveform.path")
                Label("Kies een toon die bij jou past", systemImage: "sparkles")
            }
            .font(.callout.weight(.semibold))
            .foregroundStyle(BrandTheme.textPrimary)
            .labelStyle(.titleAndIcon)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackground.opacity(0.9))
                    .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
            )

            Text("Veeg of tik op Volgende om te starten.")
                .font(.footnote)
                .foregroundStyle(BrandTheme.mutedText)
                .padding(.top, DesignSystem.spacing.md)
        }
        .padding(.vertical, DesignSystem.spacing.xl)
    }
    
    private var pageFocus: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Waar wil je nu vooral op focussen?")
                .font(.title2.bold())
                .foregroundStyle(BrandTheme.textPrimary)
                .multilineTextAlignment(.leading)

            Text("Dit verandert niets aan hoe de app werkt, maar helpt om je suggesties en statistieken persoonlijker te maken.")
                .font(.callout)
                .foregroundStyle(BrandTheme.mutedText)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(LifeDimension.allCases) { dim in
                    focusChip(for: dim)
                }
            }
            .accessibilityElement(children: .contain)
            .padding(.top, 4)

            Text("Je kunt meerdere thema's kiezen. We gebruiken de eerste selectie als hoofd-focusthema.")
                .font(.footnote)
                .foregroundStyle(BrandTheme.mutedText)
                .padding(.top, DesignSystem.spacing.sm)
        }
        .padding(.vertical, DesignSystem.spacing.xl)
    }
    
    private var pageOverwhelm: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Hoe druk voelt je leven nu aan?")
                .font(.title2.bold())
                .foregroundStyle(BrandTheme.textPrimary)
                .multilineTextAlignment(.leading)

            Text("Dit is puur voor jezelf. Life XP wil je niet extra belasten, maar juist helpen met heldere, haalbare stappen.")
                .font(.callout)
                .foregroundStyle(BrandTheme.mutedText)

            VStack(alignment: .leading, spacing: 12) {
                Text("\(Int(overwhelmed)) / 5")
                    .font(.title3.bold())
                    .foregroundStyle(BrandTheme.textPrimary)
                    .accessibilityLabel("Huidige drukte")
                    .accessibilityValue("\(Int(overwhelmed)) van de 5")

                Slider(value: $overwhelmed, in: 1...5, step: 1)
                    .tint(BrandTheme.accent)
                    .accessibilityLabel("Hoe druk je leven nu aanvoelt")
                    .accessibilityValue("\(Int(overwhelmed)) van de 5")

                HStack {
                    Text("Heel rustig")
                        .font(.footnote)
                        .foregroundStyle(BrandTheme.mutedText)
                    Spacer()
                    Text("Heel druk")
                        .font(.footnote)
                        .foregroundStyle(BrandTheme.mutedText)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(BrandTheme.cardBackground.opacity(0.92))
            )
        }
        .padding(.vertical, DesignSystem.spacing.xl)
    }
    
    private var pageTone: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welke vibe wil je?")
                .font(.title2.bold())
                .foregroundStyle(BrandTheme.textPrimary)
                .multilineTextAlignment(.leading)

            Text("Je kunt dit altijd later nog veranderen in Settings.")
                .font(.callout)
                .foregroundStyle(BrandTheme.mutedText)

            VStack(spacing: 14) {
                toneOption(tone: .soft, title: "Soft & gentle", description: "Lief, zacht en ondersteunend. Perfect als je al genoeg stress hebt.")
                toneOption(tone: .realTalk, title: "Real talk", description: "Eerlijk, direct en een beetje savage. Respectvol, maar geen suikerlaag.")
            }
            .padding(.top, DesignSystem.spacing.sm)
        }
        .padding(.vertical, DesignSystem.spacing.xl)
    }

    private var controlBar: some View {
        HStack(spacing: 12) {
            if step > 0 {
                Button {
                    withAnimation(.easeInOut) {
                        step -= 1
                    }
                } label: {
                    Label("Vorige", systemImage: "chevron.left")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.bordered)
                .tint(BrandTheme.mutedText)
            }

            Spacer()

            VStack(spacing: 6) {
                Text("Stap \(step + 1) van 4")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(BrandTheme.textPrimary)

                HStack(spacing: 6) {
                    ForEach(0..<4) { index in
                        Capsule()
                            .fill(index == step ? BrandTheme.accent : BrandTheme.mutedText.opacity(0.4))
                            .frame(width: index == step ? 22 : 12, height: 6)
                            .animation(.easeInOut(duration: 0.25), value: step)
                    }
                }
                .accessibilityHidden(true)
            }

            Spacer()

            Button(action: handleNext) {
                Text(step == 3 ? "Start Life XP" : "Volgende")
                    .font(.headline)
                    .padding(.horizontal, DesignSystem.spacing.lg)
                    .padding(.vertical, DesignSystem.spacing.md)
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .scaleEffect(isAdvancing ? 0.97 : 1)
            .animation(.spring(response: 0.35, dampingFraction: 0.72), value: isAdvancing)
            .accessibilityLabel(step == 3 ? "Start Life XP" : "Volgende stap")
            .accessibilityHint("Ga naar de volgende onboarding stap")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.radius.xl, style: .continuous)
                .fill(BrandTheme.cardBackground.opacity(0.82))
                .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
        )
    }

    @ViewBuilder
    private func onboardingPage<Content: View>(index: Int, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.spacing.lg) {
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, DesignSystem.spacing.xl)
        .padding(.bottom, DesignSystem.spacing.xl)
        .tag(index)
        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.98)), removal: .opacity))
    }

    private func focusChip(for dimension: LifeDimension) -> some View {
        let isSelected = selectedFocuses.contains(dimension)

        return Button {
            withAnimation(.easeInOut) {
                if isSelected {
                    selectedFocuses.remove(dimension)
                } else {
                    selectedFocuses.insert(dimension)
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: dimension.systemImage)
                    .font(.headline)
                Text(dimension.label)
                    .font(.callout.weight(.semibold))
                    .lineLimit(2)
                Spacer(minLength: 4)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, DesignSystem.spacing.sm)
            .padding(.horizontal, DesignSystem.spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? BrandTheme.accent.opacity(0.15) : BrandTheme.cardBackground.opacity(0.9))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isSelected ? BrandTheme.accent : BrandTheme.cardBackground.opacity(0.6), lineWidth: 1)
            )
            .foregroundStyle(isSelected ? BrandTheme.textPrimary : BrandTheme.textPrimary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(dimension.label)
        .accessibilityValue(isSelected ? "Geselecteerd" : "Niet geselecteerd")
    }
    
    private func toneOption(tone: ToneMode, title: String, description: String) -> some View {
        let isSelected = selectedTone == tone

        return Button {
            selectedTone = tone
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: tone == .soft ? "sparkles" : "bolt.fill")
                    .font(.title3)
                    .symbolVariant(isSelected ? .fill : .none)
                    .foregroundStyle(isSelected ? BrandTheme.accent : BrandTheme.mutedText)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(BrandTheme.textPrimary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(BrandTheme.mutedText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(BrandTheme.accent)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(DesignSystem.spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                    .fill(isSelected ? BrandTheme.cardBackground.opacity(0.96) : BrandTheme.cardBackground.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radius.lg, style: .continuous)
                            .stroke(isSelected ? BrandTheme.accent : BrandTheme.cardBackground.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint("Kies de \(title) toon")
        .accessibilityValue(isSelected ? "Geselecteerd" : "Niet geselecteerd")
    }

    private func handleNext() {
        HapticsEngine.lightImpact()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
            isAdvancing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                isAdvancing = false
            }
        }

        if step < 3 {
            withAnimation(.easeInOut) {
                step += 1
            }
            return
        }

        let chosenDimensions = selectedFocuses.isEmpty ? Set(LifeDimension.allCases) : selectedFocuses
        let primary = LifeDimension.allCases.first(where: { chosenDimensions.contains($0) })

        model.settings.enabledDimensions = chosenDimensions
        model.primaryFocus = primary
        model.overwhelmedLevel = Int(overwhelmed)
        model.toneMode = selectedTone
        onDone()
    }
}
