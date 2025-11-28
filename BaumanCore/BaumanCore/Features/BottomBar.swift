import SwiftUI


struct MapView: View {
    var body: some View {
        Map()
    }
}

struct MainPageView: View {
    var body: some View {
        MainPage()
    }
}

struct ScheduleView: View {
    var body: some View {
        Schedule()
    }
}

struct GradesView: View {
    var body: some View {
        Grades()
    }
}

struct ProfileView: View {
    var body: some View {
        Profile()
    }
}

struct BottomBarView: View {
    
    @State var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            MapView()
                .tag(0)
                .tabItem {
                    Image(systemName: "map")
                    Text("Маршрут")
                }
            
            MainPageView()
                .tag(1)
                .tabItem {
                    Image(systemName: "house")
                    Text("Главная")
                }
            
            ScheduleView()
                .tag(2)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Расписание")
                }
            
            GradesView()
                .tag(3)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Успеваемость")
                }
            
            ProfileView()
                .tag(4)
                .tabItem {
                    Image(systemName: "person")
                    Text("Аккаунт")
                }
        }
        .tint(Color(hex: "2932D9"))
    }
}
