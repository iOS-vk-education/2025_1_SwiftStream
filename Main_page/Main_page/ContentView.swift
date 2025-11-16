//
//  ContentView.swift
//  Main_page
//
//  Created by Sofia Biriukova on 12.11.2025.
//

import SwiftUI

struct ContentView: View {
    let IconColor = Color(red: 0.16, green: 0.19, blue: 0.85)
    
    var body: some View {
        ZStack{
            HeaderView()
            HStack{
                Button {
                    print("Переход на страницу почты")
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color(red: 0.16, green: 0.19, blue: 0.85))
                        .overlay(
                                    Image("mail")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(.leading, 15),
                                    alignment: .leading
                                )
                }
                    .padding()
                
                
                Button {
                    print("Переход на страницу факультета")
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color(red: 0.16, green: 0.19, blue: 0.85))
                        .overlay(
                                    Image("chair")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .padding(.leading, 10),
                                    alignment: .leading
                                )
                }
                    .padding()
                
                
                Button {
                    print("Переход на страницу физры")
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color(red: 0.16, green: 0.19, blue: 0.85))
                        .overlay(
                                Image("fizra")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.leading, 15),
                                alignment: .leading
                            )
                }
                    .padding()
                
            }
            .position(CGPoint(x: 197, y: 278))
            
            HStack{
                Button {
                    print("Пропуск")
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 360, height: 51)
                            .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                        Text("Пропуск")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                    }
                        .overlay(
                            HStack{
                                Image("qr")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.leading, -180)
                            }
                        )
                }
                .padding()
            }
            .position(CGPoint(x: 197, y: 617.5))
            
            Button(action: {
                        print("Переход на навигатор")
                    }) {
                        Image("Vector")
                    }
                    .position(CGPoint(x: 48.5, y: 750))
            
            Button(action: {
                        print("Переход на главную")
                    }) {
                        Image("Home")
                    }
                    .position(CGPoint(x: 123.5, y: 750))
            
            Button(action: {
                        print("Переход на расписание")
                    }) {
                        Image("Schedule")
                    }
                    .position(CGPoint(x: 199.5, y: 750))
            
            Button(action: {
                        print("Переход на успеваемость")
                    }) {
                        Image("Grades")
                    }
                    .position(CGPoint(x: 274.5, y: 750))
            
            Button(action: {
                        print("Переход на аккаунт")
                    }) {
                        Image("Profile")
                    }
                    .position(CGPoint(x: 349.5, y: 750))
            
        }
        
    }
}

struct HeaderView: View {
    var body: some View {
        VStack{
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
            .frame(maxWidth: .infinity, alignment:.leading)
            .padding(.bottom, 267)
            
            
        }
    }
}

#Preview {
    ContentView()
}

