import SwiftUI

struct Profile: View {
    @State private var student = Student(
        name: "Подобедов Владислав Владимирович",
        faculty: "ФН",
        group: "ФН12-71Б",
        studentID: "pvv22f019",
        email: "vlad@stundent.bmstu.ru"
    )
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 5) {
                    HStack(alignment: .center, spacing: 30) {
                        Image("user")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        
                        Text(student.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        infoRow("Факультет:", student.faculty)
                        infoRow("Группа:", student.group)
                        infoRow("Личный номер:", student.studentID)
                        infoRow("Email:", student.email)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            Spacer(minLength: 0)
            

        }
        .navigationTitle("Личный кабинет")
    }
    
    
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
        .font(.subheadline)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 4)
    }
}
