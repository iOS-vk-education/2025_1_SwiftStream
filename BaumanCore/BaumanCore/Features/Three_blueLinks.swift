//
//  Three_blueLinks.swift
//  Main_page
//
//  Created by Sofia Biriukova on 21.11.2025.
//

import SwiftUI

struct Three_blueLinks: View {
    var body: some View {
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

    }
}
