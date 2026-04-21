import SwiftUI

struct BottomBarView: View {
    @State var selectedTab: Int = 0
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                MapView()
                    .environmentObject(appState)
            }
            .tabItem {
                Image("tab_route").renderingMode(.template)
                Text(Translation.TabBar.route)
            }
            .tag(0)
            
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image("tab_home").renderingMode(.template)
                Text(Translation.TabBar.home)
            }
            .tag(1)
            
            NavigationStack {
                Schedule()
                    .environmentObject(appState)
            }
            .tabItem {
                Image("tab_calendar").renderingMode(.template)
                Text(Translation.TabBar.schedule)
            }
            .tag(2)
            
            NavigationStack {
                Grades()
            }
            .tabItem {
                Image("tab_grades").renderingMode(.template)
                Text(Translation.TabBar.grades)
            }
            .tag(3)
            
            NavigationStack {
                Profile()
            }
            .tabItem {
                Image("tab_profile").renderingMode(.template)
                Text(Translation.TabBar.account)
            }
            .tag(4)
        }
        .tint(Colors.MainColor)
        .onChange(of: selectedTab) { newValue in
            appState.selectedTab = newValue
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "ru"))
                .previewDisplayName("Russian")
            
            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
            
            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .previewDisplayName("Chinese")
        }
    }
}
