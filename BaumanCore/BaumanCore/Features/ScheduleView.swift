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
                                ? Color(hex: "2932D9")
                                :Color.clear
                            )
                            .foregroundColor(selectedDay == day.id ? .white : .black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedDay == day.id
                                        ? Color(hex: "1F27A5")
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
        
        TabView(selection: $selectedTab){
            Color.clear
                .tag(0)
                .tabItem{
                    Image(systemName: "map")
                    Text("Маршрут")
                }
            Color.clear
                .tag(1)
                .tabItem{
                    Image(systemName: "house")
                    Text("Главная")
                }
            Color.clear
                .tag(2)
                .tabItem{
                    Image(systemName: "calendar")
                    Text("Расписание")
                }
            Color.clear
                .tag(3)
                .tabItem{
                    Image(systemName: "chart.bar")
                    Text("Успеваемость")
                }
            Color.clear
                .tag(4)
                .tabItem{
                    Image(systemName: "person")
                    Text("Аккаунт")
                }
        }
        .onChange(of: selectedTab){ newValue in
            switch newValue{
                case 0: print("0")
                case 1: print("1")
                case 2: print("2")
                case 3: print("3")
                case 4: print("4")
                default: break
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
