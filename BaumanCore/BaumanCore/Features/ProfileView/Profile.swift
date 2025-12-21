import SwiftUI

struct Profile: View {
    @EnvironmentObject var appState: AppState
    @State private var student = Student(
        name: "Подобедов Владислав Владимирович",
        faculty: "ФН",
        group: "ФН12-71Б",
        studentID: "pvv22f019",
        email: "vlad@student.bmstu.ru"
    )
        
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Профиль")
                .font(.SFPro(33, weight: .regular))
                .foregroundColor(AppColor.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            HStack(spacing: 15) {
                Image("user")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(student.name)
                        .font(.SFPro(21))
                        .foregroundColor(.black)
                    
                    Text(student.email)
                        .font(.SFPro(14))
                        .foregroundColor(AppColor.lightGrey)
                }
                
                Spacer()
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColor.mainColor, lineWidth: 0.5)
            )
            .padding(.horizontal, 17)
            
            HStack {
                Text("Группа:")
                    .font(.SFPro(15, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(student.group)
                    .font(.SFPro(15))
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColor.mainColor, lineWidth: 0.5)
            )
            .padding(.horizontal, 17)
            
            HStack {
                Text("Личный номер:")
                    .font(.SFPro(15, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(student.studentID)
                    .font(.SFPro(15))
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColor.mainColor, lineWidth: 0.5)
            )
            .padding(.horizontal, 17)
            
            Button {
                appState.isLoggedIn = false
            } label: {
                Text("Выйти из аккаунта")
                    .font(.SFPro(15, weight: .semibold))
                    .foregroundColor(AppColor.mainColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            Spacer()
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
