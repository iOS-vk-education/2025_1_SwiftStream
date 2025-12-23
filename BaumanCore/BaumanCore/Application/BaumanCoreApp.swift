import SwiftUI
import Firebase

@main
struct BaumanCoreApp: App {

    @StateObject private var appState = AppState()


    init() {
        FirebaseApp.configure() // добавил firebase
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
