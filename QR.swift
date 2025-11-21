//
//  QR.swift
//  Main_page
//
//  Created by Sofia Biriukova on 21.11.2025.
//

import SwiftUI

struct QR: View {
    var body: some View {
        HStack {
            Button {
                print("Пропуск")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 360, height: 51)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                    Text("Пропуск")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                }
                .overlay(
                    HStack {
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
    }
}
