struct Student {
    var nameLocalized: [String: String]
    var faculty: String
    var groupLocalized: [String: String]
    var studentID: String
    var email: String
    var subjects: [SubjectData]
    var semesters: [Semester]

    func localizedName(languageCode: String) -> String {
        let code = Self.normalizedLanguageCode(languageCode)

        return nameLocalized[code]
        ?? nameLocalized["ru"]
        ?? nameLocalized["en"]
        ?? nameLocalized["zh"]
        ?? nameLocalized.values.first
        ?? ""
    }

    func localizedGroup(languageCode: String) -> String {
        let code = Self.normalizedLanguageCode(languageCode)

        return groupLocalized[code]
        ?? groupLocalized["ru"]
        ?? groupLocalized["en"]
        ?? groupLocalized["zh"]
        ?? groupLocalized.values.first
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
