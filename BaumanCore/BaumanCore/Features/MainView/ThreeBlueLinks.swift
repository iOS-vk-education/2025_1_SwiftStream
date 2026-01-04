import SwiftUI
import UIKit

struct ThreeBlueLinks: View {
    let email: String

    @State private var showMailAlert = false
    @State private var mailAlertTitle = ""
    @State private var mailAlertMessage = ""

    private func openMailComposer() {
        guard let url = URL(string: "https://student.bmstu.ru/?Skin=hPronto-&altLanguage=russian") else { return }
        UIApplication.shared.open(url)
        
    
//        let to = "support@yourdomain.com"
//        let subject = "Вопрос"
//        let body = "Здравствуйте!\n\nМоя почта: \(email)\n\nСообщение:\n"
//
//        var c = URLComponents()
//        c.scheme = "mailto"
//        c.path = to
//        c.queryItems = [
//            .init(name: "subject", value: subject),
//            .init(name: "body", value: body)
//        ]
//
//        guard let url = c.url else { return }
//
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        } else {
//            UIPasteboard.general.string = "Кому: \(to)\nТема: \(subject)\n\n\(body)"
//            mailAlertTitle = "Почта не настроена"
//            mailAlertMessage = "Адрес и текст письма скопированы в буфер обмена."
//            showMailAlert = true
//        }
    }

    private func openFacultySite() {
        guard let url = URL(string: "https://fv.bmstu.ru/") else { return }
        UIApplication.shared.open(url)
    }

    private func openSportSite() {
        guard let url = URL(string: "https://sport.bmstu.ru/") else { return }
        UIApplication.shared.open(url)
    }

    var body: some View {
        GeometryReader { geo in
            let horizontalPadding: CGFloat = 16
            let spacing: CGFloat = 24
            let totalSpacing = spacing * 2
            let available = geo.size.width - (horizontalPadding * 2) - totalSpacing
            let tile = max(72, min(120, available / 3))

            HStack(spacing: spacing) {
                tileButton(imageName: "mail", size: tile, action: openMailComposer)
                tileButton(imageName: "faculty", size: tile, action: openFacultySite)
                tileButton(imageName: "sport", size: tile, action: openSportSite)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .frame(height: 120)
        .alert(mailAlertTitle, isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mailAlertMessage)
        }
    }

    private func tileButton(imageName: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(AppColor.mainColor)
                .frame(width: size, height: size)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.65, height: size * 0.65)
                        .padding(.leading, size * 0.16),
                    alignment: .leading
                )
        }
    }
}
