import SwiftUI

struct MainPage: View {
    @State private var showQR = false
    
    var body: some View {
        VStack(spacing: 0) {
            ImageCarousel()
                .padding(.top, 8)
            
            ThreeBlueLinks()
                .padding(.top, 20)
            
            HeaderView()
                .padding(.top, 40)
            
            Spacer()
            
            PassButton {
                showQR = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .fullScreenCover(isPresented: $showQR) {
            QRView()
        }
    }
    
    struct PassButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                RoundedRectangle(cornerRadius: 14)
                    .frame(height: 56)
                    .foregroundColor(AppColor.mainColor)
                    .overlay(
                        Text("Пропуск")
                            .foregroundColor(AppColor.white)
                            .font(.system(size: 17, weight: .semibold))
                    )
            }
        }
    }
    
    struct HeaderView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("Привет, Влад!")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.bottom, 2)
                
                Text("Сегодня пятница, 10 неделя")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                
                Text("7 ноября")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                
                Text("3 пары")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.top, 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}
