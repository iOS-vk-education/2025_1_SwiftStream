import Foundation

enum StudentLookup {

    private static let students: [Student] = [
        Student(
            name: "Подобедов Владислав Владимирович",
            faculty: "ФН",
            group: "ФН12-71Б",
            studentID: "pvv22f019",
            email: "vlad@student.bmstu.ru",
            password: "q"
        )
    ]

    static func find(by login: String, password: String) -> Student? {
        let key = login.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let pass = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !key.isEmpty, !pass.isEmpty else { return nil }

        return students.first {
            ($0.email.lowercased() == key || $0.studentID.lowercased() == key) && $0.password == pass
        }
    }
}
