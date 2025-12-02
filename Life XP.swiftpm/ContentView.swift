import SwiftUI

struct ContentView: View {
    @StateObject private var model = AppModel()
    
    @AppStorage("lifeXP.hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showOnboarding: Bool = false

    var body: some View {
        ZStack {
            BrandBackground()

            TabView {
                HomeView()
                    .environmentObject(model)
                    .tabItem {
                        Label("Home", systemImage: "sparkles")
                    }

                JourneysView()
                    .environmentObject(model)
                    .tabItem {
                        Label("Journeys", systemImage: "map.fill")
                    }

                PacksView()
                    .environmentObject(model)
                    .tabItem {
                        Label("Packs", systemImage: "checklist")
                    }

                StatsView()
                    .environmentObject(model)
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }

                SettingsView()
                    .environmentObject(model)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }
        .tint(BrandTheme.accent)
        .onAppear {
            if !hasCompletedOnboarding {
                showOnboarding = true
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
