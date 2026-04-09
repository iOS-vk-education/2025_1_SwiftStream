import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text(Translation.Register.title)
                .font(.SFPro(33, weight: .semibold))
                .foregroundColor(Colors.MainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Text(Translation.Register.description)
                .font(.SFPro(17))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text(Translation.Register.backButton)
                    .font(.SFPro(17))
                    .foregroundColor(.white)
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                RegisterView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "ru"))
            }
            .previewDisplayName("Russian")
            
            NavigationStack {
                RegisterView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "en"))
            }
            .previewDisplayName("English")
            
            NavigationStack {
                RegisterView()
                    .tint(Colors.MainColor)
                    .environment(\.locale, Locale(identifier: "zh-Hans"))
            }
            .previewDisplayName("Chinese")
        }
    }
}
