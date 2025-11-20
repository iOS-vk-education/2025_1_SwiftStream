//
//  CustomTabView.swift
//  Main_page
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Int
    
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
            Color.clear
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
        .onChange(of: selectedTab) { newValue in
            switch newValue {
            case 0: print("Маршрут")
            case 1: print("Главная")
            case 2: print("Расписание")
            case 3: print("Успеваемость")
            case 4: print("Аккаунт")
            default: break
            }
        }
    }
}
