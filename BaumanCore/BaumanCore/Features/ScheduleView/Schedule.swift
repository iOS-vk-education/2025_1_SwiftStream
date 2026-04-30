//import SwiftUI
//
//struct Schedule: View {
//    @StateObject private var dateManager = ScheduleDateManager()
//    @State private var selectedTab: Int = 2
//    @State private var lastSelectedWeek: Int = 1
//    @State private var lastSelectedDay: Int = 1
//    @State private var selectedClassroom: String?
//    @State private var showRouteOptions = false
//    @EnvironmentObject var appState: AppState
//    @Environment(\.colorScheme) var colorScheme
//
//    var days: [(id: Int, nameKey: LocalizedStringKey, dayNumber: String)] {
//        [
//            (1, Translation.Schedule.monday, dateManager.getDayNumberForDay(dayIndex: 1)),
//            (2, Translation.Schedule.tuesday, dateManager.getDayNumberForDay(dayIndex: 2)),
//            (3, Translation.Schedule.wednesday, dateManager.getDayNumberForDay(dayIndex: 3)),
//            (4, Translation.Schedule.thursday, dateManager.getDayNumberForDay(dayIndex: 4)),
//            (5, Translation.Schedule.friday, dateManager.getDayNumberForDay(dayIndex: 5)),
//            (6, Translation.Schedule.saturday, dateManager.getDayNumberForDay(dayIndex: 6))
//        ]
//    }
//
//    var currentSelectedDay: Int? {
//        if lastSelectedWeek == dateManager.currentWeek && lastSelectedDay >= 0 {
//            return lastSelectedDay
//        }
//        return nil
//    }
//
//    var lessonsCount: Int {
//        if lastSelectedDay == 0 {
//            return 0
//        }
//        let mod = lastSelectedDay % 3
//        return mod == 0 ? 3 : mod
//    }
//
//    var body: some View {
//        ZStack {
//            VStack(alignment: .leading) {
//                VStack(alignment: .leading) {
//                    Text(Translation.Schedule.title)
//                        .fontWeight(.bold)
//                        .font(.system(size: 30))
//                        .padding(.bottom, 5)
//
//                    VStack(alignment: .leading, spacing: 2) {
//                        (
//                            Text(Translation.Schedule.group) +
//                            Text(": ФН12-71Б")
//                        )
//
//                        Text(dateManager.weekTitle)
//                    }
//                    .foregroundColor(.gray)
//                }
//                .padding(.top, 20)
//
//                HStack(spacing: 12) {
//                    ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
//                        Button(action: {
//                            lastSelectedWeek = dateManager.currentWeek
//                            lastSelectedDay = day.id
//                        }) {
//                            VStack(spacing: 4) {
//                                Text(day.nameKey)
//                                    .font(.system(size: 14, weight: .medium))
//
//                                Text(day.dayNumber)
//                                    .font(.system(size: 18, weight: .bold))
//                            }
//                            .frame(width: 50, height: 50)
//                            .background(
//                                currentSelectedDay == day.id
//                                ? Colors.MainColor
//                                : (
//                                    dateManager.currentDayIndex == day.id &&
//                                    dateManager.currentWeek == lastSelectedWeek &&
//                                    dateManager.currentDayIndex != 0
//                                    ? Color.gray.opacity(0.3)
//                                    : Color.clear
//                                )
//                            )
//                            .foregroundColor(currentSelectedDay == day.id ? .white : Colors.black)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(
//                                        Color.gray.opacity(0.8),
//                                        lineWidth: 2
//                                    )
//                            )
//                            .cornerRadius(12)
//                        }
//                        .opacity(dateManager.animateDayButtons ? 0 : 1)
//                        .offset(y: dateManager.animateDayButtons ? 15 : 0)
//                        .animation(
//                            .easeOut(duration: 0.4)
//                                .delay(Double(index) * 0.05),
//                            value: dateManager.animateDayButtons
//                        )
//                    }
//                }
//                .padding(.vertical, 15)
//                .gesture(
//                    DragGesture().onEnded { value in
//                        if value.translation.width < -40 {
//                            dateManager.nextWeek()
//                        } else if value.translation.width > 40 {
//                            dateManager.prevWeek()
//                        }
//                    }
//                )
//
//                VStack(spacing: 16) {
//                    if lessonsCount == 0 {
//                        Text(Translation.Schedule.noLessonsSunday)
//                            .font(.title2)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    } else {
//                        ForEach(0..<lessonsCount, id: \.self) { index in
//                            let type: LessonType = {
//                                switch index % 3 {
//                                case 0: return .lecture
//                                case 1: return .seminar
//                                default: return .lab
//                                }
//                            }()
//
//                            let classrooms = ["703а", "907", "440", "1206"]
//                            let times = [("09:00", "10:30"), ("10:45", "12:15"), ("12:30", "14:00"), ("14:15", "15:45")]
//                            let subjects = ["Философия", "Иностранный язык", "Биомеханика", "Клиническая терапия и хирургия"]
//                            let teachers = ["Катков О.Н.", "Токарева С.А.", "Завьялов Р.А.", "Панилов П.А."]
//
//                            LessonCardView(
//                                type: type,
//                                timeStart: times[index % times.count].0,
//                                timeEnd: times[index % times.count].1,
//                                subject: subjects[index % subjects.count],
//                                teacher: teachers[index % teachers.count],
//                                classroom: classrooms[index % classrooms.count],
//                                onClassroomTap: { classroom in
//                                    selectedClassroom = classroom
//                                    showRouteOptions = true
//                                }
//                            )
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//            .padding()
//
//            if showRouteOptions, let classroom = selectedClassroom {
//                Color.black.opacity(0.3)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        showRouteOptions = false
//                    }
//
//                VStack(spacing: 16) {
//                    Text(classroom)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(colorScheme == .dark ? .white : .black)
//                        .padding(.top)
//
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            appState.pendingFromLocation = classroom
//                            appState.selectedTab = 0
//                            showRouteOptions = false
//                        }) {
//                            Text(Translation.Schedule.fromHere)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(width: 120, height: 50)
//                                .background(Colors.MainColor)
//                                .cornerRadius(10)
//                        }
//
//                        Button(action: {
//                            appState.pendingToLocation = classroom
//                            appState.selectedTab = 0
//                            showRouteOptions = false
//                        }) {
//                            Text(Translation.Schedule.toHere)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(width: 120, height: 50)
//                                .background(Colors.MainColor)
//                                .cornerRadius(10)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom)
//                }
//                .background(Color(UIColor.systemBackground))
//                .cornerRadius(16)
//                .shadow(radius: 10)
//                .padding(.horizontal, 20)
//            }
//        }
//        .onAppear {
//            dateManager.updateRealDate()
//            lastSelectedWeek = dateManager.currentWeek
//            if dateManager.currentDayIndex != 0 {
//                lastSelectedDay = dateManager.currentDayIndex
//            } else {
//                lastSelectedDay = 0
//            }
//        }
//    }
//}
//
//struct Schedule_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            BottomBarView(selectedTab: 2)
//                .environmentObject(AppState())
//                .environment(\.locale, Locale(identifier: "ru"))
//                .previewDisplayName("Russian")
//
//            BottomBarView(selectedTab: 2)
//                .environmentObject(AppState())
//                .environment(\.locale, Locale(identifier: "en"))
//                .previewDisplayName("English")
//
//            BottomBarView(selectedTab: 2)
//                .environment(\.locale, Locale(identifier: "zh-Hans"))
//                .environmentObject(AppState())
//                .previewDisplayName("Chinese")
//        }
//    }
//}
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
        Group {
            BottomBarView(selectedTab: 2)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "ru"))
                .previewDisplayName("Russian")

            BottomBarView(selectedTab: 2)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")

            BottomBarView(selectedTab: 2)
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .environmentObject(AppState())
                .previewDisplayName("Chinese")
        }
    }
}
