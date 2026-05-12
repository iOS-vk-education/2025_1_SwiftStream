import SwiftUI
import FirebaseAuth

struct MainPage: View {
    @State private var showQR = false
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = MainPageViewModel()
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0

    private var currentLanguageCode: String {
        switch selectedLanguageRawValue {
        case 1:
            return "en"
        case 2:
            return "zh"
        default:
            return "ru"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ImageCarousel()
                .padding(.top, 8)

            ThreeBlueLinks()
                .padding(.top, 20)
            
            if let student = appState.student,
               !student.localizedName(languageCode: currentLanguageCode).isEmpty {
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
        guard let student = appState.student else {
            return ""
        }

        let fullName = student.localizedName(languageCode: currentLanguageCode)

        guard !fullName.isEmpty else {
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
                        Text(Translation.MainPage.pass)
                            .foregroundColor(Colors.white)
                            .font(.system(size: 17, weight: .semibold))
                    )
            }
        }
    }

    struct HeaderView: View {
        let studentName: String

        @StateObject private var dateManager = ScheduleDateManager()
        @StateObject private var scheduleVM = ScheduleViewModel()

        private var todayLessonsCount: Int {
            guard dateManager.currentDayIndex != 7 else {
                return 0
            }

            return scheduleVM
                .getLessons(
                    for: dateManager.currentDayIndex,
                    week: dateManager.currentWeek
                )
                .count
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                (Text(Translation.MainPage.greeting) + Text(", \(studentName)!"))
                    .font(.system(size: 34, weight: .bold))
                    .padding(.bottom, 2)

                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)

                Text(Date.now, format: .dateTime.day().month(.wide))
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)

                Text(LocalizedStringKey("main_lessons_count \(todayLessonsCount)"))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.top, 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .onAppear {
                dateManager.updateRealDate()
                scheduleVM.fetchScheduleForCurrentUser()
            }
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BottomBarView(selectedTab: 1)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "ru"))
                .previewDisplayName("Russian")

            BottomBarView(selectedTab: 1)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")

            BottomBarView(selectedTab: 1)
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .environmentObject(AppState())
                .previewDisplayName("Chinese")
        }
    }
}
