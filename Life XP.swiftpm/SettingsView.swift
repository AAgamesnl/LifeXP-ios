import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: AppModel

    @State private var confirmResetAll = false
    @State private var confirmResetArcs = false
    @State private var confirmResetStreaks = false
    @State private var confirmResetStats = false

    var body: some View {
        NavigationStack {
            ZStack {
                BrandBackground()

                Form {
                    Section(header: Text("Experience"), footer: Text("Kies hoe direct Life XP coacht en hoeveel nudges je op Home ziet.")) {
                        Picker("Tone", selection: $model.settings.toneMode) {
                            ForEach(ToneMode.allCases) { tone in
                                Text(tone.label).tag(tone)
                            }
                        }

                        Picker("Daily nudges", selection: $model.settings.dailyNudgeIntensity) {
                            ForEach(NudgeIntensity.allCases) { mode in
                                Text(mode.label).tag(mode)
                            }
                        }

                        Picker("Quest board", selection: $model.settings.questBoardDensity) {
                            ForEach(QuestBoardDensity.allCases) { density in
                                Text(density.label).tag(density)
                            }
                        }
                        .pickerStyle(.segmented)

                        Stepper(value: $model.settings.maxConcurrentArcs, in: 1...3) {
                            Text("Max actieve arcs: \(model.settings.maxConcurrentArcs)")
                        }

                        Toggle("Safe mode (lichte thema's)", isOn: $model.settings.safeMode)
                    }

                    Section(header: Text("Content"), footer: Text("Kies wat we wel of niet tonen op Home en in suggesties.")) {
                        Toggle("Verberg Heart Repair/breakup content", isOn: $model.settings.showHeartRepairContent.negated())
                            .tint(.pink)
                        Toggle("Toon PRO / locked teasers", isOn: $model.settings.showProTeasers)
                        Picker("Prioriteit dimensie", selection: $model.settings.primaryFocus) {
                            Text("Geen voorkeur").tag(LifeDimension?.none)
                            ForEach(LifeDimension.allCases) { dim in
                                Text(dim.label).tag(Optional(dim))
                            }
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Benadruk dimensies")
                                .font(.subheadline.weight(.semibold))
                            Text("We tonen vooral suggesties in deze levensgebieden.")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            ForEach(LifeDimension.allCases) { dim in
                                Toggle(isOn: Binding(
                                    get: { model.settings.enabledDimensions.contains(dim) },
                                    set: { newValue in
                                        var set = model.settings.enabledDimensions
                                        if newValue {
                                            set.insert(dim)
                                        } else if set.count > 1 {
                                            set.remove(dim)
                                        }
                                        model.settings.enabledDimensions = set
                                    }
                                )) {
                                    Label(dim.label, systemImage: dim.systemImage)
                                }
                            }
                        }
                    }

                    Section(header: Text("Visuals"), footer: Text("Pas Home aan: compact of juist hero-kaarten, streaks en share info.")) {
                        Picker("Thema", selection: $model.settings.appearanceMode) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.label).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)

                        Toggle("Compacte lay-out", isOn: $model.settings.compactHomeLayout)
                        Toggle("Hero kaarten tonen", isOn: $model.settings.showHeroCards)
                        Toggle("Kaarten standaard uitgeklapt", isOn: $model.settings.expandHomeCardsByDefault)

                        Toggle("Toon energy check-in", isOn: $model.settings.showEnergyCard)
                        Toggle("Toon momentum grid", isOn: $model.settings.showMomentumGrid)
                        Toggle("Toon quick actions", isOn: $model.settings.showQuickActions)
                        Toggle("Streaks op Home", isOn: $model.settings.showStreaks)
                        Toggle("Arc progress op share-card", isOn: $model.settings.showArcProgressOnShare)
                    }

                    Section(header: Text("Data & reset"), footer: Text("We vragen altijd om bevestiging zodat je niet per ongeluk progress verliest.")) {
                        Button(role: .destructive) {
                            confirmResetAll = true
                        } label: {
                            Label("Reset alles (XP, arcs, streaks)", systemImage: "trash.fill")
                        }

                        Button {
                            confirmResetArcs = true
                        } label: {
                            Label("Reset alleen arcs", systemImage: "map")
                        }

                        Button {
                            confirmResetStreaks = true
                        } label: {
                            Label("Reset alleen streaks", systemImage: "flame")
                        }

                        Button {
                            confirmResetStats = true
                        } label: {
                            Label("Reset alleen stats", systemImage: "chart.line.downtrend.xyaxis")
                        }
                    }

                    Section(header: Text("Advanced / Dev")) {
                        Toggle(isOn: $model.premiumUnlocked) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Forceer PRO (dev)")
                                Text("Gebruik dit om alle PRO-packs te testen.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .accessibilityHint("Schakel PRO in voor alle packs tijdens testen")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .confirmationDialog("Reset alles?", isPresented: $confirmResetAll, titleVisibility: .visible) {
                Button("Reset Life XP", role: .destructive) { model.resetAllProgress() }
                Button("Annuleer", role: .cancel) { }
            }
            .confirmationDialog("Reset arcs?", isPresented: $confirmResetArcs, titleVisibility: .visible) {
                Button("Verwijder arc progress", role: .destructive) { model.resetArcProgress() }
                Button("Annuleer", role: .cancel) { }
            }
            .confirmationDialog("Reset streaks?", isPresented: $confirmResetStreaks, titleVisibility: .visible) {
                Button("Reset streak teller", role: .destructive) { model.resetStreaksOnly() }
                Button("Annuleer", role: .cancel) { }
            }
            .confirmationDialog("Reset stats?", isPresented: $confirmResetStats, titleVisibility: .visible) {
                Button("Reset statistieken", role: .destructive) { model.resetStatsOnly() }
                Button("Annuleer", role: .cancel) { }
            }
        }
    }
}

private extension Binding where Value == Bool {
    /// Convenience for toggles that conceptually flip the meaning.
    func negated() -> Binding<Bool> {
        Binding<Bool>(
            get: { !wrappedValue },
            set: { wrappedValue = !$0 }
        )
    }
}
