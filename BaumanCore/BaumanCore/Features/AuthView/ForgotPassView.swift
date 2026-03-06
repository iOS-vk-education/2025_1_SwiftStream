import SwiftUI

struct ForgotPassView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Восстановление пароля")
                .font(.SFPro(29, weight: .semibold))
                .foregroundColor(Colors.MainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Text("Для восстановления пароля необходимо обратиться в деканат Вашего факультета или отправить письмо на почту support@bmstu.ru")
                .font(.SFPro(17))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Вернуться")
                    .font(.SFPro(17))
                    .foregroundColor(Colors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Colors.MainColor)
                    .cornerRadius(13)
            }
            .padding(.horizontal, 21)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ForgotPassView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPassView()
                .tint(Colors.MainColor)
        }
    }
}
