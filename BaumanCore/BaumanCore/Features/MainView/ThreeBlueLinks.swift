import SwiftUI

struct ThreeBlueLinks: View {
    
    private let studentURL = URL(string: "https://student.bmstu.ru/?Skin=hPronto-&altLanguage=russian")
    private let facultyURL = URL(string: "https://fv.bmstu.ru/")
    private let sportURL = URL(string: "https://sport.bmstu.ru/")

    var body: some View {
        Grid(horizontalSpacing: 16) {
            GridRow {
                LinkButton(
                    imageName: "mail",
                    url: studentURL,
                    accessibilityLabel: "Студенческий портал"
                )
                LinkButton(
                    imageName: "faculty",
                    url: facultyURL,
                    accessibilityLabel: "Сайт факультета"
                )
                LinkButton(
                    imageName: "sport",
                    url: sportURL,
                    accessibilityLabel: "Спортивный сайт"
                )
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 100)
    }
}

// Вспомогательный компонент для одной кнопки
private struct LinkButton: View {
    let imageName: String
    let url: URL?
    let accessibilityLabel: String
    
    var body: some View {
        Button {
            // Открываем ссылку, если она валидна
            if let url = url {
                UIApplication.shared.open(url)
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Colors.MainColor)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60),
                    alignment: .center
                )
        }
        .accessibilityLabel(accessibilityLabel) 
    }
}
