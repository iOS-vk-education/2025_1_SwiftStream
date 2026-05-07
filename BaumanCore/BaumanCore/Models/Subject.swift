struct SubjectData {
    var id: String
    var nameLocalized: [String: String]
    var progress: String
    var lessons: [Lesson]

    func localizedName(languageCode: String) -> String {
        localizedValue(from: nameLocalized, languageCode: languageCode)
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
