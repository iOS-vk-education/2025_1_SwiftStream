//
//  BottomBar.swift
//  BaumanCore
//
//  Created by Иван Агошков on 21.11.2025.
//

import SwiftUI

struct BottomBarView: View {
    
    @State private var selectedTab: Int = 3
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Color.clear
                .tag(0)
                .tabItem {
                    Image(systemName: "map")
                    Text("Маршрут")
                }
            
            Color.clear
                .tag(1)
                .tabItem {
                    Image(systemName: "house")
                    Text("Главная")
                }
            
            Color.clear
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
            
            Color.clear
                .tag(4)
                .tabItem {
                    Image(systemName: "person")
                    Text("Аккаунт")
                }
        }
    }
}
