import Foundation
import SwiftUI

struct Lesson: Identifiable {
    var id: String
    var titleLocalized: [String: String]
    var date: String
    var statusLocalized: [String: String]

    func localizedTitle(languageCode: String) -> String {
        localizedValue(from: titleLocalized, languageCode: languageCode)
    }

    func localizedStatus(languageCode: String) -> String {
        localizedValue(from: statusLocalized, languageCode: languageCode)
    }

    func localizedStatusColor(languageCode: String) -> Color {
        let status = localizedStatus(languageCode: languageCode)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if status.contains("посещ")
            || status.contains("attended")
            || status.contains("已出勤") {
            return .green
        }

        if status.contains("пропущ")
            || status.contains("absent")
            || status.contains("未出勤") {
            return .red
        }

        return .gray
    }

    private func localizedValue(from map: [String: String], languageCode: String) -> String {
        let code = Self.normalizedLanguageCode(languageCode)

        return map[code]
        ?? map["ru"]
        ?? map["en"]
        ?? map["zh"]
        ?? map.values.first
        ?? ""
    }

    private static func normalizedLanguageCode(_ languageCode: String) -> String {
        if languageCode.hasPrefix("zh") {
            return "zh"
        }

        if languageCode.hasPrefix("en") {
            return "en"
        }

        return "ru"
    }
}

struct ScheduleLesson: Identifiable {
    var id: String

    var subjectLocalized: [String: String]
    var teacherLocalized: [String: String]
    var typeLocalized: [String: String]

    var classroom: String
    var timeStart: String
    var timeEnd: String
    var day: Int
    var week: Int
    var order: Int

    func localizedSubject(languageCode: String) -> String {
        localizedValue(from: subjectLocalized, languageCode: languageCode)
    }

    func localizedTeacher(languageCode: String) -> String {
        localizedValue(from: teacherLocalized, languageCode: languageCode)
    }

    func localizedType(languageCode: String) -> String {
        localizedValue(from: typeLocalized, languageCode: languageCode)
    }

    var typeKey: String {
        let rawType = (
            typeLocalized["en"]
            ?? typeLocalized["ru"]
            ?? typeLocalized["zh"]
            ?? typeLocalized.values.first
            ?? ""
        )
        .lowercased()
        .trimmingCharacters(in: .whitespacesAndNewlines)

        if rawType.contains("lab")
            || rawType.contains("laborator")
            || rawType.contains("лаборатор")
            || rawType.contains("实验") {
            return "lab"
        }

        if rawType.contains("seminar")
            || rawType.contains("семинар")
            || rawType.contains("研讨") {
            return "seminar"
        }

        if rawType.contains("lecture")
            || rawType.contains("лекция")
            || rawType.contains("讲座") {
            return "lecture"
        }

        print("Неизвестный тип пары:", rawType)
        return "lecture"
    }

    private func localizedValue(from map: [String: String], languageCode: String) -> String {
        let code = Self.normalizedLanguageCode(languageCode)

        return map[code]
        ?? map["ru"]
        ?? map["en"]
        ?? map["zh"]
        ?? map.values.first
        ?? ""
    }

    private static func normalizedLanguageCode(_ languageCode: String) -> String {
        if languageCode.hasPrefix("zh") {
            return "zh"
        }

        if languageCode.hasPrefix("en") {
            return "en"
        }

        return "ru"
    }
}

struct ScheduleLesson: Identifiable {
    var id: String
    var subject: String
    var teacher: String
    var classroom: String
    var timeStart: String
    var timeEnd: String
    var type: String
    var day: Int
    var week: Int
    var order: Int
}
