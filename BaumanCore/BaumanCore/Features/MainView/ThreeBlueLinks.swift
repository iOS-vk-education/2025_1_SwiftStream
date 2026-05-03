import SwiftUI

struct ThreeBlueLinks: View {
    
    private let studentURL = URL(string: "https://student.bmstu.ru/?Skin=hPronto-&altLanguage=russian")
    private let facultyURL = URL(string: "https://bmstu.ru")
    private let sportURL = URL(string: "https://sport.bmstu.ru/")

    var body: some View {
        HStack(spacing: 16) {
            LinkButton(
                systemImageName: "envelope",
                url: studentURL,
                accessibilityLabel: "Сайт почты МГТУ"
            )

            LinkButton(
                systemImageName: "building.columns",
                url: facultyURL,
                accessibilityLabel: "Сайт МГТУ"
            )

            LinkButton(
                systemImageName: "sportscourt",
                url: sportURL,
                accessibilityLabel: "Сайт физкультурной подготовки"
            )
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
}

private struct LinkButton: View {
    let systemImageName: String
    let url: URL?
    let accessibilityLabel: String
    
    var body: some View {
        Button {
            if let url = url {
                UIApplication.shared.open(url)
            }
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Colors.MainColor)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: systemImageName)
                        .font(.system(size: 50, weight: .thin))
                        .foregroundColor(.white)
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}
