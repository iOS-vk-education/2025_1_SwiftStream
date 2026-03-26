import SwiftUI

struct Profile: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL
    @AppStorage("userSelectedTheme") private var selectedThemeRawValue = 0
    @StateObject private var vm = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Профиль")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 35)
                    .padding(.horizontal, 16)
                
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
                        
                        Button { showImagePicker = true } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .background(Circle().fill(Colors.MainColor))
                        }
                    }
                    .onTapGesture { showImagePicker = true }
                    .onLongPressGesture {
                        if vm.avatar != nil {
                            showDeleteAlert = true
                        }
                    }
                    .alert("Удалить аватарку?", isPresented: $showDeleteAlert) {
                        Button("Отмена", role: .cancel) { }
                        Button("Удалить", role: .destructive) {
                            vm.deleteAvatar()
                        }
                    } message: {
                        Text("Вы действительно хотите удалить фото профиля?")
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.student?.name ?? "Загрузка...")
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
                        userID: vm.student?.studentID.isEmpty ?? true ? "anonymous" : vm.student?.studentID ?? "anonymous"
                    )
                }
    
                HStack {
                    Text("Группа:")
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
                    Text("Личный номер:")
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
                    Text("Тема приложения:")
                        .font(.SFPro(15, weight: .semibold))
                        .foregroundColor(Colors.black)

                    Spacer()

                    Picker("", selection: $selectedThemeRawValue) {
                        ForEach(0..<3) { index in
                            Text(self.themeOptions[index])
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
                    appState.isLoggedIn = false
                } label: {
                    Text("Выйти из аккаунта")
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

    private let themeOptions = ["Системная", "Светлая", "Темная"]
    
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
            Text("Служба поддержки университета:")
                .font(.SFPro(15, weight: .semibold))
                .foregroundColor(Colors.black)

            HStack {
                Text("Телефон:")
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
                Text("E-mail:")
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
        let appState = AppState()
        return BottomBarView(selectedTab: 4)
            .environmentObject(appState)
    }
}
