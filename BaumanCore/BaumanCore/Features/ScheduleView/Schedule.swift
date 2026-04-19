import SwiftUI

struct Schedule: View {
    @StateObject private var dateManager = ScheduleDateManager()
    @StateObject private var scheduleVM = ScheduleViewModel()
    @StateObject private var studentVM = StudentViewModel()
    @State private var selectedTab: Int = 2
    @State private var lastSelectedWeek: Int = 1
    @State private var lastSelectedDay: Int = 1

    var days: [(id: Int, name: String, dayNumber: String)] {
        [
            (1, "ПН", dateManager.getDayNumberForDay(dayIndex: 1)),
            (2, "ВТ", dateManager.getDayNumberForDay(dayIndex: 2)),
            (3, "СР", dateManager.getDayNumberForDay(dayIndex: 3)),
            (4, "ЧТ", dateManager.getDayNumberForDay(dayIndex: 4)),
            (5, "ПТ", dateManager.getDayNumberForDay(dayIndex: 5)),
            (6, "СБ", dateManager.getDayNumberForDay(dayIndex: 6)),
            (7, "ВС", dateManager.getDayNumberForDay(dayIndex: 7))
        ]
    }

    var currentSelectedDay: Int? {
        if lastSelectedWeek == dateManager.currentWeek && lastSelectedDay >= 1 {
            return lastSelectedDay
        }
        return nil
    }

    var filteredLessons: [ScheduleLesson] {
        scheduleVM.getLessons(for: lastSelectedDay, week: lastSelectedWeek)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("Расписание")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Группа: \(scheduleVM.groupName)")
                    Text(dateManager.weekTitle)
                }
                .foregroundColor(.gray)
            }
            .padding(.top, 40)

            HStack(spacing: 10) {
                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    Button(action: {
                        lastSelectedWeek = dateManager.currentWeek
                        lastSelectedDay = day.id
                    }) {
                        VStack(spacing: 4) {
                            Text(day.name)
                                .font(.system(size: 13, weight: .medium))
                            Text(day.dayNumber)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(width: 44, height: 50)
                        .background(
                            currentSelectedDay == day.id
                            ? Colors.MainColor
                            : (
                                dateManager.currentDayIndex == day.id &&
                                dateManager.currentWeek == lastSelectedWeek
                                ? Color.gray.opacity(0.3)
                                : Color.clear
                            )
                        )
                        .foregroundColor(currentSelectedDay == day.id ? .white : Colors.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.8), lineWidth: 2)
                        )
                        .cornerRadius(12)
                    }
                    .opacity(dateManager.animateDayButtons ? 0 : 1)
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
                        lastSelectedWeek = dateManager.currentWeek
                    } else if value.translation.width > 40 {
                        dateManager.prevWeek()
                        lastSelectedWeek = dateManager.currentWeek
                    }
                }
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if lastSelectedDay == 7 {
                        Text("Выходной")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 300)

                    } else if filteredLessons.isEmpty {
                        Text("Нет занятий")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 300)

                    } else {
                        ForEach(filteredLessons) { lesson in
                            LessonCardView(
                                type: mapType(lesson.type),
                                timeStart: lesson.timeStart,
                                timeEnd: lesson.timeEnd,
                                subject: lesson.subject,
                                teacher: lesson.teacher,
                                classroom: lesson.classroom
                            )
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal)
        .onAppear {
            dateManager.updateRealDate()

            lastSelectedWeek = dateManager.currentWeek
            lastSelectedDay = dateManager.currentDayIndex

            studentVM.fetchStudent()
            scheduleVM.fetchScheduleForCurrentUser()
        }
    }

    func mapType(_ type: String) -> LessonType {
        switch type.lowercased() {
        case "lecture", "лекция":
            return .lecture
        case "seminar", "семинар":
            return .seminar
        case "lab", "лабораторная", "лабораторная работа":
            return .lab
        default:
            return .lecture
        }
    }
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 2)
    }
}
