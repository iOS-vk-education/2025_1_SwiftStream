import SwiftUI
import FirebaseAuth

struct MainPage: View {
    @State private var showQR = false
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = MainPageViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ImageCarousel()
                .padding(.top, 8)

            ThreeBlueLinks()
                .padding(.top, 20)
            
            if let name = appState.student?.name, !name.isEmpty {
                HeaderView(studentName: studentName())
                    .padding(.top, 40)
                    .transition(.opacity)
            } else {
                Color.clear
                    .frame(height: 120)
            }

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
            vm.loadIfNeeded(appState: appState)
        }
    }
    
    private func studentName() -> String {
        guard let fullName = appState.student?.name, !fullName.isEmpty else {
            return ""
        }
        
        let parts = fullName.split(separator: " ")
        
        if parts.count > 1 {
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
                    .foregroundColor(Colors.MainColor)
                    .overlay(
                        Text("Пропуск")
                            .foregroundColor(Colors.white)
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

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return BottomBarView(selectedTab: 1)
            .environmentObject(appState)
    }
}
