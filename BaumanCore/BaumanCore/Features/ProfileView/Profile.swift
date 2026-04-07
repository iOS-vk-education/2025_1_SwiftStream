import SwiftUI

struct Profile: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL
    @AppStorage("userSelectedTheme") private var selectedThemeRawValue = 0
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0
    @StateObject private var vm = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var showDeleteAlert = false

    private let themeOptions = ["theme_system", "theme_light", "theme_dark"]
    private let languageOptions = ["language_russian", "language_english", "language_chinese"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("profile_title")
                    .font(.SFPro(33, weight: .regular))
                    .foregroundColor(Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 60)
                    .padding(.horizontal, 24)

                HStack(spacing: 15) {
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let image = vm.avatar {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())

                        Button {
                            showImagePicker = true
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .background(Circle().fill(Colors.MainColor))
                        }
                    }
                    .onTapGesture {
                        showImagePicker = true
                    }
                    .onLongPressGesture {
                        if vm.avatar != nil {
                            showDeleteAlert = true
                        }
                    }
                    .alert("delete_avatar_title", isPresented: $showDeleteAlert) {
                        Button("cancel", role: .cancel) { }
                        Button("delete", role: .destructive) {
                            vm.deleteAvatar()
                        }
                    } message: {
                        Text("delete_avatar_message")
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.student?.name ?? String(localized: "loading"))
                            .font(.SFPro(21))
                            .foregroundColor(Colors.black)

                        Text(vm.student?.email ?? "")
                            .font(.SFPro(14))
                            .foregroundColor(Colors.LightGray)
                    }

                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Colors.MainColor, lineWidth: 0.7)
                )
                .padding(.horizontal, 17)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(
                        image: $vm.avatar,
                        userID: vm.student?.studentID.isEmpty ?? true
                            ? "anonymous"
                            : vm.student?.studentID ?? "anonymous"
                    )
                }

                HStack {
                    Text("group")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)

                    Spacer()

                    Text(vm.student?.group ?? "")
                        .font(.SFPro(15))
                        .foregroundColor(Colors.black)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.MainColor, lineWidth: 0.7)
                )
                .padding(.horizontal, 17)

                HStack {
                    Text("personal_number")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)

                    Spacer()

                    Text(vm.student?.studentID ?? "")
                        .font(.SFPro(15))
                        .foregroundColor(Colors.black)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.MainColor, lineWidth: 0.7)
                )
                .padding(.horizontal, 17)

                HStack {
                    Text("app_theme")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)

                    Spacer()

                    Picker("", selection: $selectedThemeRawValue) {
                        ForEach(0..<themeOptions.count, id: \.self) { index in
                            Text(LocalizedStringKey(themeOptions[index]))
                                .tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.SFPro(15))
                    .labelsHidden()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.MainColor, lineWidth: 0.7)
                )
                .padding(.horizontal, 17)

                HStack {
                    Text("app_language")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)

                    Spacer()

                    Picker("", selection: $selectedLanguageRawValue) {
                        ForEach(0..<languageOptions.count, id: \.self) { index in
                            Text(LocalizedStringKey(languageOptions[index]))
                                .tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.SFPro(15))
                    .labelsHidden()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.MainColor, lineWidth: 0.7)
                )
                .padding(.horizontal, 17)

                SupportBlock(openURL: openURL)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.MainColor, lineWidth: 0.7)
                    )
                    .padding(.horizontal, 17)

                Button {
                    appState.logout()
                } label: {
                    Text("logout")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.MainColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)

                Spacer(minLength: 80)
            }
        }
        .onChange(of: selectedThemeRawValue) { _ in
            updateTheme()
        }
        .onAppear {
            updateTheme()
            vm.loadIfNeeded()
        }
    }

    private func updateTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        switch selectedThemeRawValue {
        case 0:
            window.overrideUserInterfaceStyle = .unspecified
        case 1:
            window.overrideUserInterfaceStyle = .light
        case 2:
            window.overrideUserInterfaceStyle = .dark
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}

private struct SupportBlock: View {
    let openURL: OpenURLAction

    private let phoneDisplay = "8(499)263-63-63"
    private let phoneDigits = "84992636363"
    private let email = "support@bmstu.ru"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("support_service")
                .font(.SFPro(15, weight: .semibold))
                .foregroundColor(Colors.black)

            HStack {
                Text("phone")
                    .font(.SFPro(15))
                    .foregroundColor(Colors.black)

                Spacer()

                Button {
                    if let url = URL(string: "tel://\(phoneDigits)") {
                        openURL(url)
                    }
                } label: {
                    Text(phoneDisplay)
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)
                        .underline()
                }
            }

            HStack {
                Text("email")
                    .font(.SFPro(15))
                    .foregroundColor(Colors.black)

                Spacer()

                Button {
                    if let url = URL(string: "mailto:\(email)") {
                        openURL(url)
                    }
                } label: {
                    Text(email)
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)
                        .underline()
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "ru"))
                .previewDisplayName("Russian")

            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")

            BottomBarView(selectedTab: 4)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .previewDisplayName("Chinese")
        }
    }
}
