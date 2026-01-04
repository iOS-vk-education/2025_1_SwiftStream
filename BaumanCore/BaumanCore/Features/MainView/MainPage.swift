import SwiftUI

struct MainPage: View {
    @State private var showQR = false
    @State private var student: Student? = nil
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            ImageCarousel()
                .padding(.top, 8)

            if let email = appState.student?.email, !email.isEmpty {
                ThreeBlueLinks(email: email)
                    .padding(.top, 20)
            }

            HeaderView(studentName: studentName())
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
        .onAppear {
            FirebaseService().fetchStudent { fetchedStudent in
                if let fetchedStudent = fetchedStudent {
                    self.student = fetchedStudent
                    self.appState.student = fetchedStudent
                    }
                }
            }
        }
    
    private func studentName() -> String {
            guard let fullName = student?.name else { return "" }
            let parts = fullName.split(separator: " ")
            if parts.count >= 2 {
                return String(parts[1])
            } else {
                return fullName
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
        let studentName: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("Привет, \(studentName)!")
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
