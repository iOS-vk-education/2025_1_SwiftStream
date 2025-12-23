import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL

    @State private var login = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    @State private var showLoginError = false
    @State private var loginErrorText = ""

    private func recoverPassword() {
        if let url = URL(string: "https://sso.bmstu.ru/portal4/account/recover") {
            openURL(url)
        }
    }

    private func signIn() {
        let l = login.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !l.isEmpty else {
            loginErrorText = "Поле «Логин» не может быть пустым"
            showLoginError = true
            return
        }

        guard !p.isEmpty else {
            loginErrorText = "Поле «Пароль» не может быть пустым"
            showLoginError = true
            return
        }

        guard let student = StudentLookup.find(by: l, password: p) else {
            loginErrorText = "Неверный логин или пароль"
            showLoginError = true
            return
        }

        appState.setLoggedIn(student: student)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Вход в аккаунт")
                .font(.SFPro(33))
                .foregroundColor(AppColor.mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    LabeledField(
                        title: "Логин",
                        placeholder: "Введите логин",
                        text: $login
                    )

                    LabeledPasswordField(
                        title: "Пароль",
                        placeholder: "Введите пароль",
                        text: $password,
                        isVisible: $isPasswordVisible
                    )

                    Button(action: recoverPassword) {
                        Text("Забыли пароль?")
                            .font(.SFPro(17))
                            .foregroundColor(AppColor.mainColor)
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }

            PrimaryButton(title: "Войти в аккаунт →", action: signIn)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                .alert("Ошибка", isPresented: $showLoginError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(loginErrorText)
                }

            HStack(spacing: 0) {
                Text("Нет аккаунта?")
                    .font(.SFPro(17))
                    .foregroundColor(AppColor.lightGrey)

                NavigationLink {
                    RegisterView()
                } label: {
                    Text(" Создать")
                        .font(.SFPro(17))
                        .foregroundColor(AppColor.mainColor)
                }
            }
            .padding(.bottom, 24)
        }
    }
}

private struct LabeledField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.SFPro(17))
                .foregroundColor(.black)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .font(.SFPro(17))
                    .foregroundColor(AppColor.lightlightGrey)
            )
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColor.lightlightGrey, lineWidth: 1)
            )
        }
    }
}

private struct LabeledPasswordField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.SFPro(17))
                .foregroundColor(.black)

            HStack(spacing: 12) {
                Group {
                    if isVisible {
                        TextField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .font(.SFPro(17))
                                .foregroundColor(AppColor.lightlightGrey)
                        )
                    } else {
                        SecureField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .font(.SFPro(17))
                                .foregroundColor(AppColor.lightlightGrey)
                        )
                    }
                }

                Button { isVisible.toggle() } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(AppColor.lightlightGrey)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColor.lightlightGrey, lineWidth: 1)
            )
        }
    }
}

private struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.SFPro(17, weight: .semibold))
                .foregroundColor(AppColor.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColor.mainColor)
                .cornerRadius(13)
        }
        .buttonStyle(.plain)
    }
}
