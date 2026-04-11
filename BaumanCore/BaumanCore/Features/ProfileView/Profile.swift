import SwiftUI

struct Profile: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL
    @AppStorage("userSelectedTheme") private var selectedThemeRawValue = 0
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0
    @StateObject private var vm = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var showDeleteAlert = false

    private let themeOptions: [LocalizedStringKey] = [
        Translation.Profile.themeSystem,
        Translation.Profile.themeLight,
        Translation.Profile.themeDark
    ]

    private let languageOptions: [LocalizedStringKey] = [
        Translation.Profile.languageRussian,
        Translation.Profile.languageEnglish,
        Translation.Profile.languageChinese
    ]

    var body: some View {
        VStack(spacing: 0) {
            profileHeader

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    profileCard

                    HStack {
                        Text(Translation.Profile.group)
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

                    HStack {
                        Text(Translation.Profile.personalNumber)
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

                    HStack {
                        Text(Translation.Profile.appTheme)
                            .font(.SFPro(15, weight: .semibold))
                            .foregroundColor(Colors.black)

                        Spacer()

                        Picker("", selection: $selectedThemeRawValue) {
                            ForEach(0..<themeOptions.count, id: \.self) { index in
                                Text(themeOptions[index])
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

                    HStack {
                        Text(Translation.Profile.appLanguage)
                            .font(.SFPro(15, weight: .semibold))
                            .foregroundColor(Colors.black)

                        Spacer()

                        Picker("", selection: $selectedLanguageRawValue) {
                            ForEach(0..<languageOptions.count, id: \.self) { index in
                                Text(languageOptions[index])
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

                    SupportBlock(openURL: openURL)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.MainColor, lineWidth: 0.7)
                        )

                    Button {
                        appState.logout()
                    } label: {
                        Text(Translation.Profile.logout)
                            .font(.SFPro(15, weight: .semibold))
                            .foregroundColor(Colors.MainColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, 12)

                    Spacer(minLength: 80)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 17)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            vm.loadIfNeeded()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                image: $vm.avatar,
                sourceType: .photoLibrary,
                allowsEditing: true
            ) { selectedImage in
                let userID = vm.student?.studentID.isEmpty ?? true
                    ? "anonymous"
                    : vm.student?.studentID ?? "anonymous"

                Task {
                    await AvatarStorage.save(selectedImage, userID: userID)
                }
            }
        }
    }

    private var profileHeader: some View {
        HStack {
            Text(Translation.Profile.title)
                .fontWeight(.bold)
                .font(.system(size: 30))
                .foregroundColor(Colors.black)

            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .background(Color.clear)
    }

    private var profileCard: some View {
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
            .alert(Translation.Profile.deleteAvatarTitle, isPresented: $showDeleteAlert) {
                Button(Translation.Profile.cancel, role: .cancel) { }
                Button(Translation.Profile.delete, role: .destructive) {
                    vm.deleteAvatar()
                }
            } message: {
                Text(Translation.Profile.deleteAvatarMessage)
            }

            VStack(alignment: .leading, spacing: 4) {
                if let name = vm.student?.name {
                    Text(name)
                        .font(.SFPro(21))
                        .foregroundColor(Colors.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(Translation.Profile.loading)
                        .font(.SFPro(21))
                        .foregroundColor(Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(vm.student?.email ?? "")
                    .font(.SFPro(14))
                    .foregroundColor(Colors.LightGray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Colors.MainColor, lineWidth: 0.7)
        )
    }
}

private struct SupportBlock: View {
    let openURL: OpenURLAction

    private let phoneDisplay = "8(499)263-63-63"
    private let phoneDigits = "84992636363"
    private let email = "support@bmstu.ru"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Translation.Profile.supportService)
                .font(.SFPro(15, weight: .semibold))
                .foregroundColor(Colors.black)

            HStack {
                Text(Translation.Profile.phone)
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
                Text(Translation.Profile.email)
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
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .environmentObject(AppState())
                .previewDisplayName("Chinese")
        }
    }
}
