import SwiftUI
import Firebase

@main
struct BaumanCoreApp: App {

    @StateObject private var appState = AppState()
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0
    @AppStorage("userSelectedLanguage") private var islockedin = 0

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.locale, currentLocale)
        }
    }

    private var currentLocale: Locale {
        switch selectedLanguageRawValue {
        case 0:
            return Locale(identifier: "ru")
        case 1:
            return Locale(identifier: "en")
        case 2:
            return Locale(identifier: "zh-Hans")
        default:
            return Locale(identifier: "ru")
        }
    }
}
