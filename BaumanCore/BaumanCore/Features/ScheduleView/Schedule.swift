import SwiftUI



struct Schedule: View {

    @StateObject private var dateManager = ScheduleDateManager()
    @State private var selectedDay: Int = 1
    @State private var selectedTab: Int = 2

    var days: [(id: Int, name: String, dayNumber: String)] {
        [
            (1, "ПН", dateManager.getDayNumberForDay(dayIndex: 1)),
            (2, "ВТ", dateManager.getDayNumberForDay(dayIndex: 2)),
            (3, "СР", dateManager.getDayNumberForDay(dayIndex: 3)),
            (4, "ЧТ", dateManager.getDayNumberForDay(dayIndex: 4)),
            (5, "ПТ", dateManager.getDayNumberForDay(dayIndex: 5)),
            (6, "СБ", dateManager.getDayNumberForDay(dayIndex: 6))
        ]
    }

    var LessonsCount: Int {
        let mod = selectedDay % 3
        return mod == 0 ? 3 : mod
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Расписание")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Группа: ФН12-71Б")
                    Text(dateManager.weekTitle)
                }
                .foregroundColor(.gray)
            }
            .padding(.top, 20)


            HStack(spacing: 12) {
                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    Button(action: {
                        selectedDay = day.id
                        print("\(day.name) and \(day.id)")
                    }) {
                        VStack(spacing: 4) {
                            Text(day.name)
                                .font(.system(size: 14, weight: .medium))
                            Text(day.dayNumber)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(width: 50, height: 50)
                        .background(
                            selectedDay == day.id
                            ? Color(red: 0.16, green: 0.19, blue: 0.85)
                            : Color.clear
                        )
                        .foregroundColor(selectedDay == day.id ? .white : .black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedDay == day.id
                                    ? Color(red: 0.16, green: 0.19, blue: 0.85)
                                    : Color.gray.opacity(0.4),
                                    lineWidth: 2
                                )
                        )
                        .cornerRadius(12)
                    }
                    .opacity(dateManager.animateDayButtons ? 0 : 2)
                    .offset(y: dateManager.animateDayButtons ? 15 : 0)
                    .animation(
                        .easeOut(duration: 0.4)
                        .delay(Double(index) * 0.05),
                        value: dateManager.animateDayButtons
                    )
                }
            }
            .padding(.vertical, 15)
            .gesture(
                DragGesture().onEnded { value in
                    if value.translation.width < -40 {
                        dateManager.nextWeek()
                    } else if value.translation.width > 40 {
                        dateManager.prevWeek()
                    }
                }
            )


            VStack(spacing: 16) {
                ForEach(0..<LessonsCount, id: \.self) { index in
                    let type: LessonType = {
                        switch index % 3 {
                        case 0: return .lecture
                        case 1: return .seminar
                        default: return .lab
                        }
                    }()

                    LessonCardView(
                        type: type,
                        timeStart: "10:\(index)0",
                        timeEnd: "11:\(index)5",
                        subject: "Окружающий мир",
                        teacher: "Иванов Иван Иванович",
                        classroom: "21\(index)л"
                    )
                }
            }
            .padding(.bottom, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onAppear {
            selectedDay = dateManager.currentDayIndex
        }
        .onChange(of: dateManager.currentWeek) { _ in
            selectedDay = dateManager.currentDayIndex
        }
    }
}


struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 2)
    }
}

// сделать переключение недели без синей кнопки. при нажатии на другую дату актуальную отрисовывать серым
