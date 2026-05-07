import SwiftUI
import Firebase

@main
struct BaumanCoreApp: App {

    @StateObject private var appState = AppState()
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0
    @AppStorage("userSelectedTheme") private var selectedThemeRawValue = 0

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.locale, currentLocale)
                .preferredColorScheme(currentColorScheme)
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

    private var currentColorScheme: ColorScheme? {
        switch selectedThemeRawValue {
        case 0:
            return nil
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return nil
        }
    }
}
