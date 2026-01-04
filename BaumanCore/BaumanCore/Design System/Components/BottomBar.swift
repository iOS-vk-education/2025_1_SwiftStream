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
                Text("Маршрут")
            }
            .tag(0)
            
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image("tab_home").renderingMode(.template)
                Text("Главная")
            }
            .tag(1)
            
            NavigationStack {
                Schedule()
            }
            .tabItem {
                Image("tab_calendar").renderingMode(.template)
                Text("Расписание")
            }
            .tag(2)
            
            NavigationStack {
                Grades()
            }
            .tabItem {
                Image("tab_grades").renderingMode(.template)
                Text("Успеваемость")
            }
            .tag(3)
            
            NavigationStack {
                Profile()
            }
            .tabItem {
                Image("tab_profile").renderingMode(.template)
                Text("Аккаунт")
            }
            .tag(4)
        }
        .tint(AppColor.mainColor)
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return BottomBarView(selectedTab: 4)
            .environmentObject(appState)
    }
}
