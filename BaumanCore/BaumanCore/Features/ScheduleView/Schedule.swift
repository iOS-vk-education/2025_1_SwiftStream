import SwiftUI

struct Schedule: View {
    @StateObject private var dateManager = ScheduleDateManager()
    @StateObject private var scheduleVM = ScheduleViewModel()
    @StateObject private var studentVM = StudentViewModel()

    @State private var selectedTab: Int = 2
    @State private var lastSelectedWeek: Int = 1
    @State private var lastSelectedDay: Int = 1

    @State private var selectedClassroom: String?
    @State private var showRouteOptions = false

    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme

    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0

    private var currentLanguageCode: String {
        switch selectedLanguageRawValue {
        case 1:
            return "en"
        case 2:
            return "zh"
        default:
            return "ru"
        }
    }

    var days: [(id: Int, name: LocalizedStringKey, dayNumber: String)] {
        [
            (1, Translation.Schedule.monday, dateManager.getDayNumberForDay(dayIndex: 1)),
            (2, Translation.Schedule.tuesday, dateManager.getDayNumberForDay(dayIndex: 2)),
            (3, Translation.Schedule.wednesday, dateManager.getDayNumberForDay(dayIndex: 3)),
            (4, Translation.Schedule.thursday, dateManager.getDayNumberForDay(dayIndex: 4)),
            (5, Translation.Schedule.friday, dateManager.getDayNumberForDay(dayIndex: 5)),
            (6, Translation.Schedule.saturday, dateManager.getDayNumberForDay(dayIndex: 6)),
            (7, Translation.Schedule.sunday, dateManager.getDayNumberForDay(dayIndex: 7))
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
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(Translation.Schedule.title)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .padding(.bottom, 5)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(Translation.Schedule.group) + Text(" \(scheduleVM.localizedGroupName(languageCode: currentLanguageCode))")
                        Text(dateManager.weekTitle)
                    }
                    .foregroundColor(.gray)
                }
                .padding(.top, 36)
                .padding(.leading, 6) //тут

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
                            Text(Translation.Schedule.noLessonsSunday)
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 300)

                        } else if filteredLessons.isEmpty {
                            Text(Translation.Schedule.noLessons)
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 300)

                        } else {
                            ForEach(filteredLessons) { lesson in
                                LessonCardView(
                                    type: mapType(lesson.typeKey),
                                    typeTitle: lesson.localizedType(languageCode: currentLanguageCode),
                                    timeStart: lesson.timeStart,
                                    timeEnd: lesson.timeEnd,
                                    subject: lesson.localizedSubject(languageCode: currentLanguageCode),
                                    teacher: lesson.localizedTeacher(languageCode: currentLanguageCode),
                                    classroom: lesson.localizedClassroom(languageCode: currentLanguageCode),
                                    languageCode: currentLanguageCode,
                                    onClassroomTap: { classroom in
                                        selectedClassroom = classroom
                                        showRouteOptions = true
                                    }
                                )
                            }
                        }

                        Spacer(minLength: 80)
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal)

            if showRouteOptions, let classroom = selectedClassroom {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showRouteOptions = false
                    }

                VStack(spacing: 16) {
                    Text(classroom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.top)

                    HStack(spacing: 20) {
                        Button(action: {
                            appState.pendingFromLocation = classroom
                            appState.selectedTab = 0
                            showRouteOptions = false
                        }) {
                            Text(Translation.Schedule.fromHere)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Colors.MainColor)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            appState.pendingToLocation = classroom
                            appState.selectedTab = 0
                            showRouteOptions = false
                        }) {
                            Text(Translation.Schedule.toHere)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Colors.MainColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            dateManager.updateRealDate()

            lastSelectedWeek = dateManager.currentWeek
            lastSelectedDay = dateManager.currentDayIndex

            studentVM.fetchStudent()
            scheduleVM.fetchScheduleForCurrentUser()
        }
    }

    func mapType(_ typeKey: String) -> LessonType {
        switch typeKey {
        case "lecture":
            return .lecture
        case "seminar":
            return .seminar
        case "lab":
            return .lab
        default:
            return .lecture
        }
    }
}
