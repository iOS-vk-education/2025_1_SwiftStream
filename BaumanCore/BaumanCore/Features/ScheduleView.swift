import SwiftUI

struct ScheduleView: View {
    
    @State private var selectedDay: Int = 1
    @State private var selectedTab: Int = 2
    
    let days: [(id: Int, name: String)] = [
        (1, "ПН"),
        (2, "ВТ"),
        (3, "СР"),
        (4, "ЧТ"),
        (5, "ПТ"),
        (6, "СБ")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Расписание")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Группа: ФН12-71Б")
                    Text("10 неделя, знаменатель")
                }
                .foregroundColor(.gray)
            }
            .padding(.top, 20)
            
            HStack(spacing: 12) {
                ForEach(days, id: \.id) { day in
                    Button(action: {
                        selectedDay = day.id
                        print("\(day.name) and  \(day.id)")
                    }) {
                        Text(day.name)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 50, height: 50)
                            .background(
                                selectedDay == day.id
                                ? Color(.gradesBlue)
                                :Color.clear
                            )
                            .foregroundColor(selectedDay == day.id ? .white : .black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedDay == day.id
                                        ? Color(.gradesBlue)
                                        :Color.gray.opacity(0.4),
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(12)
                        
                    }
                }
            }
            .padding(.vertical, 15)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
