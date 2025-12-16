import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                BottomBarView(selectedTab: 1)
            } else {
                NavigationStack {
                    WelcomeView()
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
