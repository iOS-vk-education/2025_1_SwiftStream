import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Вход в аккаунт")
                .font(.SFPro(33))
                .foregroundColor(AppColor.mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Логин")
                        .font(.SFPro(17))
                        .foregroundColor(.black)
                    
                    TextField(
                        "",
                        text: $login,
                        prompt: Text("Введите логин")
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
                
                Button {
                } label: {
                    Text("Забыли пароль?")
                        .font(.SFPro(17))
                        .foregroundColor(AppColor.mainColor)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                appState.isLoggedIn = true
            } label: {
                Text("Войти в аккаунт →")
                    .font(.SFPro(17, weight: .semibold))
                    .foregroundColor(AppColor.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColor.mainColor)
                    .cornerRadius(13)
            }
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
