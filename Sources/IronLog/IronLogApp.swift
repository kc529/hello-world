import SwiftUI
import SwiftData

@main
struct IronLogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Workout.self)
    }
}
