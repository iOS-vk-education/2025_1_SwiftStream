import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var appState: AppState

    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Вход в аккаунт")
                .font(.SFPro(33))
                .foregroundColor(AppColor.mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)

            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Электронная почта")
                        .font(.SFPro(17))
                        .foregroundColor(.black)

                    TextField(
                        "",
                        text: $login,
                        prompt: Text("Введите email")
                            .font(.SFPro(17))
                            .foregroundColor(AppColor.lightlightGrey)
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColor.lightlightGrey, lineWidth: 1)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Пароль")
                        .font(.SFPro(17))
                        .foregroundColor(.black)

                    HStack {
                        if isPasswordVisible {
                            TextField(
                                "",
                                text: $password,
                                prompt: Text("Введите пароль")
                                    .font(.SFPro(17))
                                    .foregroundColor(AppColor.lightlightGrey)
                            )
                        } else {
                            SecureField(
                                "",
                                text: $password,
                                prompt: Text("Введите пароль")
                                    .font(.SFPro(17))
                                    .foregroundColor(AppColor.lightlightGrey)
                            )
                        }

                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(AppColor.lightlightGrey)
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColor.lightlightGrey, lineWidth: 1)
                    )
                }

                NavigationLink {
                    ForgotPassView()
                } label: {
                    Text("Забыли пароль?")
                        .font(.SFPro(17))
                        .foregroundColor(AppColor.mainColor)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                errorMessage = ""
                attemptLogin()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                    }
                    Text(isLoading ? "Вход..." : "Войти в аккаунт →")
                        .font(.SFPro(17, weight: .semibold))
                        .foregroundColor(AppColor.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .disabled(isLoading)
            .frame(height: 56)
            .background(isLoading ? AppColor.mainColor.opacity(0.7) : AppColor.mainColor)
            .cornerRadius(13)
            .padding(.horizontal, 24)

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
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .disabled(isLoading)
    }

    private func attemptLogin() {
        guard isValidEmail(login) else {
            errorMessage = "Пожалуйста, введите действительный email."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Пароль должен содержать не менее 6 символов."
            return
        }

        isLoading = true
        errorMessage = ""

        Auth.auth().signIn(withEmail: login, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error as NSError? {
                    // Печатаем детали для отладки
                    print("Ошибка Firebase Auth:")
                    print("Код: \(error.code)")
                    print("Домен: \(error.domain)")
                    print("Локализованное описание: \(error.localizedDescription)")
                                        
                    let errorCode = error.code
                                        
                    switch errorCode {
                    case 17004: // Неверный пароль
                        fallthrough
                    case 17005: // Слишком много попыток
                        fallthrough
                    case 17006: // Пользователь не найден
                        fallthrough
                    case 17007: // Неверный email
                        fallthrough
                    case 17008: // Email уже используется
                        fallthrough
                    case 17009: // Слабый пароль
                        fallthrough
                    case 17010: // Пользователь отключен
                        fallthrough
                    case 17011: // Операция не разрешена
                        self.errorMessage = "Неверный email или пароль. Проверьте введенные данные."
                        
                    case -1009: // Нет интернета (ошибка сети iOS)
                        self.errorMessage = "Ошибка сети. Проверьте подключение к интернету."
                        
                    default:
                        self.errorMessage = "Неверный email или пароль. Проверьте введенные данные."
                    }
                } else {
                    print("Успешный вход для: \(self.login)")
                    self.appState.isLoggedIn = true
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return NavigationStack {
            LoginView()
                .environmentObject(appState)
                .tint(AppColor.mainColor)
        }
    }
}
