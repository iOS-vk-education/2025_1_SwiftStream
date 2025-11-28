//
//  ContentView.swift
//  Main_page
//

import SwiftUI

struct MainPage: View {
    let IconColor = Color(red: 0.16, green: 0.19, blue: 0.85)
    @State private var selectedTab: Int = 2
    
    var body: some View {
        ZStack {

            
            ImageCarousel()
                .position(x: 197, y: 110)
            
            HeaderView()
            
            Three_blueLinks()
            
            QR()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text("Привет, Влад!")
                    .font(.custom("SF Pro Display", size: 38))
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.bottom, 14)
                Text("Сегодня пятница, 10 неделя")
                    .font(.custom("SF Pro Display", size: 20))
                    .padding(.leading)
                Text("7 ноября")
                    .font(.custom("SF Pro Display", size: 20))
                    .padding(.leading)
                    .padding(.bottom, 7)
                Text("3 пары")
                    .font(.custom("SF Pro Display", size: 15))
                    .padding(.leading)
            }
            .padding(.leading, 17)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 267)
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 1)
    }
}
