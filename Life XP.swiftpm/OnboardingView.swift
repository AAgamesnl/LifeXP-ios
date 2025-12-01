import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var model: AppModel
    var onDone: () -> Void
    
    @State private var selectedFocus: LifeDimension? = nil
    @State private var overwhelmed: Double = 3
    @State private var selectedTone: ToneMode = .soft
    @State private var step: Int = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                TabView(selection: $step) {
                    pageWelcome
                        .tag(0)
                    pageFocus
                        .tag(1)
                    pageOverwhelm
                        .tag(2)
                    pageTone
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack {
                    if step > 0 {
                        Button("Back") {
                            withAnimation {
                                step -= 1
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(step == 3 ? "Start Life XP" : "Next") {
                        handleNext()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
    
    private var pageWelcome: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Welcome to Life XP")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            Text("Je leven is geen perfecte planning, maar je kunt het wel beetje bij beetje levelen. Life XP helpt je om bewuster keuzes te maken en alles een beetje minder chaotisch te maken.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Text("Swipe of druk op Next om te starten.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer().frame(height: 20)
        }
        .padding()
    }
    
    private var pageFocus: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Waar wil je nu vooral op focussen?")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Dit verandert niks aan hoe de app werkt, maar helpt bij suggesties.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(LifeDimension.allCases) { dim in
                    Button {
                        selectedFocus = dim
                    } label: {
                        HStack {
                            Image(systemName: dim.systemImage)
                            Text(dim.label)
                                .font(.subheadline.weight(.medium))
                            Spacer()
                            if selectedFocus == dim {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selectedFocus == dim ? Color.accentColor.opacity(0.18) : Color(.secondarySystemBackground))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    private var pageOverwhelm: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Hoe overwhelmed voel je je nu?")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Dit is puur voor jezelf. Life XP is er niet om je nog meer druk te geven, maar om je kleine concrete stappen te geven.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Text("\(Int(overwhelmed)) / 5")
                .font(.title3.bold())
                .padding(.top, 16)
            
            Slider(value: $overwhelmed, in: 1...5, step: 1)
            
            Spacer()
        }
        .padding()
    }
    
    private var pageTone: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Welke vibe wil je?")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Je kunt dit altijd later nog veranderen in Settings.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                toneOption(tone: .soft, title: "Soft & gentle", description: "Lief, zacht en ondersteunend. Perfect als je al genoeg stress hebt.")
                toneOption(tone: .realTalk, title: "Real talk", description: "Eerlijk, direct en een beetje savage. Respectvol, maar geen suikerlaag.")
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    private func toneOption(tone: ToneMode, title: String, description: String) -> some View {
        Button {
            selectedTone = tone
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: tone == .soft ? "sparkles" : "bolt.fill")
                    .font(.system(size: 20))
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if selectedTone == tone {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedTone == tone ? Color.accentColor.opacity(0.18) : Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
    
    private func handleNext() {
        if step < 3 {
            withAnimation {
                step += 1
            }
        } else {
            // Save into model
            model.primaryFocus = selectedFocus
            model.overwhelmedLevel = Int(overwhelmed)
            model.toneMode = selectedTone
            onDone()
        }
    }
}
