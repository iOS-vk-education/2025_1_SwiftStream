import SwiftUI

struct ThreeBlueLinks: View {
    var body: some View {
        HStack(spacing: 24) {
            Button {
                print("Переход на страницу почты")
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 90, height: 90)
                    .foregroundColor(AppColor.mainColor)
                    .overlay(
                        Image("mail")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.leading, 15),
                        alignment: .leading
                    )
            }
            
            Button {
                print("Переход на страницу факультета")
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 90, height: 90)
                    .foregroundColor(AppColor.mainColor)
                    .overlay(
                        Image("faculty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.leading, 15),
                        alignment: .leading
                    )
            }
            
            Button {
                print("Переход на страницу физры")
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 90, height: 90)
                    .foregroundColor(AppColor.mainColor)
                    .overlay(
                        Image("sport")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.leading, 15),
                        alignment: .leading
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}
