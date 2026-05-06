struct Semester {
    var id: String
    var titleLocalized: [String: String]
    var subjects: [SemesterSubject]

    func localizedTitle(languageCode: String) -> String {
        localizedValue(from: titleLocalized, languageCode: languageCode)
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

struct SemesterSubject {
    var id: String
    var nameLocalized: [String: String]
    var gradeLocalized: [String: String]

    func localizedName(languageCode: String) -> String {
        localizedValue(from: nameLocalized, languageCode: languageCode)
    }

    func localizedGrade(languageCode: String) -> String {
        localizedValue(from: gradeLocalized, languageCode: languageCode)
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
