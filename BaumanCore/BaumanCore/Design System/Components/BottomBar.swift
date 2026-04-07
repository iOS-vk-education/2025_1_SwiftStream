import SwiftUI

struct BottomBarView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MapView()
            }
            .tabItem {
                Image("tab_route").renderingMode(.template)
                Text("tab_route_title")
            }
            .tag(0)
            
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image("tab_home").renderingMode(.template)
                Text("tab_home_title")
            }
            .tag(1)
            
            NavigationStack {
                Schedule()
            }
            .tabItem {
                Image("tab_calendar").renderingMode(.template)
                Text("tab_schedule_title")
            }
            .tag(2)
            
            NavigationStack {
                Grades()
            }
            .tabItem {
                Image("tab_grades").renderingMode(.template)
                Text("tab_grades_title")
            }
            .tag(3)
            
            NavigationStack {
                Profile()
            }
            .tabItem {
                Image("tab_profile").renderingMode(.template)
                Text("tab_account_title")
            }
            .tag(4)
        }
        .tint(Colors.MainColor)
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
