//
//  ScrollView.swift
//  Main_page
//
//  Created by Sofia Biriukova on 21.11.2025.
//

import SwiftUI

struct ImageCarousel: View {
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack {
                    Group {
                        Image("first_slide")
                            .resizable()
                            .frame(width: 360, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image("second_slide")
                            .resizable()
                            .frame(width: 360, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image("third_slide")
                            .resizable()
                            .frame(width: 360, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image("fourth_slide")
                            .resizable()
                            .frame(width: 360, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
        }
    }
}
