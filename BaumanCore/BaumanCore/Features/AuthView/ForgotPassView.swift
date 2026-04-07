import SwiftUI

struct ForgotPassView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("forgot_password_title")
                .font(.SFPro(29, weight: .semibold))
                .foregroundColor(Colors.MainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Text("forgot_password_description")
                .font(.SFPro(17))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("forgot_password_back_button")
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
        Group {
            NavigationStack {
                ForgotPassView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "ru"))
            }
            .previewDisplayName("Russian")
            
            NavigationStack {
                ForgotPassView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "en"))
            }
            .previewDisplayName("English")
            
            NavigationStack {
                ForgotPassView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "zh-Hans"))
            }
            .previewDisplayName("Chinese")
        }
    }
}
