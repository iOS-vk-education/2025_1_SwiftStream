import SwiftUI

struct WelcomeViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var appState: AppState

    func makeUIViewController(context: Context) -> UINavigationController {
        let welcomeVC = WelcomeViewController()
        welcomeVC.appState = appState
        return UINavigationController(rootViewController: welcomeVC)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}


struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                BottomBarView(selectedTab: 1)
            } else {
                NavigationStack {
                    WelcomeViewControllerWrapper()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return ContentView()
            .environmentObject(appState)
    }
}
