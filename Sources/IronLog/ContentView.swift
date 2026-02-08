import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            WorkoutEntryView()
                .tabItem {
                    Label("Log", systemImage: "square.and.pencil")
                }

            RecommendationView()
                .tabItem {
                    Label("Today", systemImage: "figure.strengthtraining.traditional")
                }
        }
    }
}
