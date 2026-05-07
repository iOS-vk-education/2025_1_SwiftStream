import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var appState: AppState

    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage: LocalizedStringKey? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text(Translation.Login.title)
                .font(.SFPro(33))
                .foregroundColor(Colors.MainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)

            Group {
                if let errorMessage {
                    Text(errorMessage)
                } else {
                    Text(" ")
                }
            }
            .foregroundColor(.red)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 20, alignment: .topLeading)
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(Translation.Login.emailLabel)
                        .font(.SFPro(17))
                        .foregroundColor(Colors.black)

                    TextField(
                        "",
                        text: $login,
                        prompt: Text(Translation.Login.emailPlaceholder)
                            .font(.SFPro(17))
                            .foregroundColor(Colors.LightLightGray)
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Colors.LightLightGray, lineWidth: 1)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(Translation.Login.passwordLabel)
                        .font(.SFPro(17))
                        .foregroundColor(Colors.black)

                    HStack {
                        if isPasswordVisible {
                            TextField(
                                "",
                                text: $password,
                                prompt: Text(Translation.Login.passwordPlaceholder)
                                    .font(.SFPro(17))
                                    .foregroundColor(Colors.LightLightGray)
                            )
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .textContentType(.password)
                        } else {
                            SecureField(
                                "",
                                text: $password,
                                prompt: Text(Translation.Login.passwordPlaceholder)
                                    .font(.SFPro(17))
                                    .foregroundColor(Colors.LightLightGray)
                            )
                            .textContentType(.password)
                        }

                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(Colors.LightLightGray)
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Colors.LightLightGray, lineWidth: 1)
                    )
                }

                NavigationLink {
                    ForgotPassView()
                } label: {
                    Text(Translation.Login.forgotPassword)
                        .font(.SFPro(17))
                        .foregroundColor(Colors.MainColor)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                errorMessage = nil
                attemptLogin()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding(.leading, 15)
                    }

                    if isLoading {
                        Text(Translation.Login.loginButtonLoading)
                            .font(.SFPro(17, weight: .semibold))
                            .foregroundColor(Colors.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(Translation.Login.loginButton)
                            .font(.SFPro(17, weight: .semibold))
                            .foregroundColor(Colors.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(isLoading)
            .frame(height: 56)
            .background(isLoading ? Colors.MainColor.opacity(0.7) : Colors.MainColor)
            .cornerRadius(13)
            .padding(.horizontal, 24)

            HStack(spacing: 0) {
                Text(Translation.Login.noAccount)
                    .font(.SFPro(17))
                    .foregroundColor(Colors.LightGray)

                NavigationLink {
                    RegisterView()
                } label: {
                    Text(Translation.Login.createAccount)
                        .font(.SFPro(17))
                        .foregroundColor(Colors.MainColor)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .disabled(isLoading)
    }

    private func attemptLogin() {
        guard isValidEmail(login) else {
            errorMessage = Translation.Login.invalidEmail
            return
        }

        guard password.count >= 6 else {
            errorMessage = Translation.Login.passwordLength
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: login, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error as NSError? {
                    print("Ошибка Firebase Auth:")
                    print("Код: \(error.code)")
                    print("Домен: \(error.domain)")
                    print("Локализованное описание: \(error.localizedDescription)")

                    switch error.code {
                    case 17004, 17005, 17006, 17007, 17008, 17009, 17010, 17011:
                        self.errorMessage = Translation.Login.invalidCredentials

                    case -1009:
                        self.errorMessage = Translation.Login.networkError

                    default:
                        self.errorMessage = Translation.Login.invalidCredentials
                    }
                } else {
                    print("Успешный вход для: \(self.login)")
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()

        Group {
            NavigationStack {
                LoginView()
                    .environmentObject(appState)
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "ru"))
            }
            .previewDisplayName("Russian")

            NavigationStack {
                LoginView()
                    .environmentObject(appState)
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "en"))
            }
            .previewDisplayName("English")

            NavigationStack {
                LoginView()
                    .environmentObject(appState)
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "zh-Hans"))
            }
            .previewDisplayName("Chinese")
        }
    }
}
