import Foundation
import FirebaseFirestore
import FirebaseAuth

class ScheduleViewModel: ObservableObject {

    @Published var lessons: [ScheduleLesson] = []
    @Published var groupName: String = ""
    @Published var groupLocalized: [String: String] = [:]

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
            let groupLocalized = self.localizedMap(from: data["groupLocalized"])

            if group.isEmpty {
                print("У пользователя не указана группа. Верни поле group в Firebase.")
                return
            }

            DispatchQueue.main.async {
                self.groupName = group
                self.groupLocalized = groupLocalized
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
                        subjectLocalized: self.localizedMap(from: item["subject"]),
                        teacherLocalized: self.localizedMap(from: item["teacher"]),
                        typeLocalized: self.localizedMap(from: item["type"]),
                        classroom: item["room"] as? String ?? "",
                        classroomLocalized: self.localizedMap(from: item["roomLocalized"]),
                        timeStart: item["startTime"] as? String ?? "",
                        timeEnd: item["endTime"] as? String ?? "",
                        day: mappedDay,
                        week: 0,
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
                    print("Пара: \(lesson.localizedSubject(languageCode: "ru")), day=\(lesson.day), start=\(lesson.timeStart)")
                }
            }
    }

    func getLessons(for day: Int, week: Int) -> [ScheduleLesson] {
        lessons.filter {
            $0.day == day && ($0.week == 0 || $0.week == week)
        }
        .sorted { $0.timeStart < $1.timeStart }
    }

    func localizedGroupName(languageCode: String) -> String {
        let code = normalizedLanguageCode(languageCode)

        return groupLocalized[code]
        ?? groupLocalized["ru"]
        ?? groupLocalized["en"]
        ?? groupLocalized["zh"]
        ?? groupName
    }

    private func localizedMap(from value: Any?) -> [String: String] {
        if let map = value as? [String: String] {
            return map
        }

        if let map = value as? [String: Any] {
            var result: [String: String] = [:]

            for (key, value) in map {
                if let stringValue = value as? String {
                    result[key] = stringValue
                }
            }

            return result
        }

        return [:]
    }

    private func normalizedLanguageCode(_ languageCode: String) -> String {
        if languageCode.hasPrefix("zh") {
            return "zh"
        }

        if languageCode.hasPrefix("en") {
            return "en"
        }

        return "ru"
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
