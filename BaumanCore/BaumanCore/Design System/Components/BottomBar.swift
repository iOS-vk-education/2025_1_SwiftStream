import SwiftUI

struct BottomBarView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Map()
            }
            .tabItem {
                Image(systemName: "map")
                Text("Маршрут")
            }
            .tag(0)
            
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Главная")
            }
            .tag(1)
            
            NavigationStack {
                Schedule()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Расписание")
            }
            .tag(2)
            
            NavigationStack {
                Grades()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Успеваемость")
            }
            .tag(3)
            
            NavigationStack {
                Profile()
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("Аккаунт")
            }
            .tag(4)
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return BottomBarView(selectedTab: 4)
            .environmentObject(appState)
    }
}
