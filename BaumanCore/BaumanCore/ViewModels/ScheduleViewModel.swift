//
//  ScheduleViewModel.swift
//  BaumanCore
//
//  Created by Иван Агошков.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ScheduleViewModel: ObservableObject {

    @Published var lessons: [ScheduleLesson] = []
    @Published var groupName: String = ""

    private let db = Firestore.firestore()

    func fetchScheduleForCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("UID не найден")
            return
        }

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Ошибка загрузки пользователя:", error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else {
                print("Документ пользователя не найден")
                return
            }

            let group = data["group"] as? String ?? ""

            if group.isEmpty {
                print("У пользователя не указана группа")
                return
            }

            DispatchQueue.main.async {
                self.groupName = group
            }

            self.fetchSchedule(group: group)
        }
    }

    func fetchSchedule(group: String) {
        db.collection("yourgroup")
            .document(group)
            .getDocument { [weak self] snapshot, error in

                guard let self = self else { return }

                if let error = error {
                    print("Ошибка загрузки расписания:", error.localizedDescription)
                    return
                }

                guard let data = snapshot?.data() else {
                    print("Документ расписания не найден для группы \(group)")
                    return
                }

                guard let lessonsArray = data["lessons"] as? [[String: Any]] else {
                    print("Поле lessons отсутствует или имеет неверный формат")
                    return
                }

                var loadedLessons: [ScheduleLesson] = []

                for (index, item) in lessonsArray.enumerated() {
                    let dayString = item["day"] as? String ?? ""
                    let mappedDay = self.mapDayStringToInt(dayString)

                    let lesson = ScheduleLesson(
                        id: "\(group)_\(index)",
                        subject: item["subject"] as? String ?? "",
                        teacher: item["teacher"] as? String ?? "",
                        classroom: item["room"] as? String ?? "",
                        timeStart: item["startTime"] as? String ?? "",
                        timeEnd: item["endTime"] as? String ?? "",
                        type: item["type"] as? String ?? "Лекция",
                        day: mappedDay,
                        week: 0,      // 0 = показывать на любой неделе
                        order: index
                    )

                    loadedLessons.append(lesson)
                }

                loadedLessons.sort { lhs, rhs in
                    if lhs.day == rhs.day {
                        return lhs.timeStart < rhs.timeStart
                    }
                    return lhs.day < rhs.day
                }

                DispatchQueue.main.async {
                    self.lessons = loadedLessons
                }

                print("Загружено пар: \(loadedLessons.count)")
                for lesson in loadedLessons {
                    print("Пара: \(lesson.subject), day=\(lesson.day), start=\(lesson.timeStart)")
                }
            }
    }

    func getLessons(for day: Int, week: Int) -> [ScheduleLesson] {
        lessons.filter {
            $0.day == day && ($0.week == 0 || $0.week == week)
        }
        .sorted { $0.timeStart < $1.timeStart }
    }

    private func mapDayStringToInt(_ day: String) -> Int {
        switch day.lowercased() {
        case "mon": return 1
        case "tue": return 2
        case "wed": return 3
        case "thu": return 4
        case "fri": return 5
        case "sat": return 6
        default: return 0
        }
    }
}
