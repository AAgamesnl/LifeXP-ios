import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Life XP PRO")) {
                    Toggle(isOn: $model.premiumUnlocked) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unlock PRO (dev mode)")
                            Text("Gebruik dit om alle PRO-packs te testen. In de echte app wordt dit door een aankoop bepaald lool.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Style & tone")) {
                    Picker("Tone", selection: $model.toneMode) {
                        ForEach(ToneMode.allCases) { tone in
                            Text(tone.label).tag(tone)
                        }
                    }
                    
                    Toggle("Hide heavy topics", isOn: $model.hideHeavyTopics)
                }
                
                Section(header: Text("Info")) {
                    HStack {
                        Text("App name")
                        Spacer()
                        Text("Life XP")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Model")
                        Spacer()
                        Text("Free app + PRO via IAP")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
