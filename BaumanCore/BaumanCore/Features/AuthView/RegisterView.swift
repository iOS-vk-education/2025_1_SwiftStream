import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Создание аккаунта")
                .font(.SFPro(33, weight: .semibold))
                .foregroundColor(AppColor.mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Text("Для получения персонального логина и пароля необходимо обратиться в деканат Вашего факультета")
                .font(.SFPro(17))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Вернуться")
                    .font(.SFPro(17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColor.mainColor)
                    .cornerRadius(13)
            }
            .padding(.horizontal, 21)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
                .tint(AppColor.mainColor)
        }
    }
}
