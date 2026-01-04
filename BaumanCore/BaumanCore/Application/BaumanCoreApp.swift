import SwiftUI
import Firebase

@main
struct BaumanCoreApp: App {
    @StateObject private var appState = AppState()

    init() {
        FirebaseApp.configure()

        guard let navPlist = Bundle.main.path(forResource: "GoogleService-Info-Nav", ofType: "plist"),
              let navOptions = FirebaseOptions(contentsOfFile: navPlist) else {
            fatalError("Не удалось загрузить GoogleService-Info-Nav.plist")
        }

        FirebaseApp.configure(name: "navigation", options: navOptions)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
