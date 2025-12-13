import SwiftUI

struct QRView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            VStack {
                Spacer()
                Image("QR")
                    .resizable()
                    .scaledToFit()
                Spacer()
            }

            Button {
                dismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "chevron.left")
                    Text("Назад")
                }
                .foregroundColor(AppColor.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(AppColor.mainColor)
                .clipShape(Capsule())
            }
            .padding(.leading, 24)
            .padding(.bottom, 28)
        }
    }
}
