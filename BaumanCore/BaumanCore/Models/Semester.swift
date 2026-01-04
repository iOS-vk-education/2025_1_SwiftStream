struct Semester {
    var id: String
    var title: String
    var subjects: [SemesterSubject]
}

struct SemesterSubject {
    var id: String
    var name: String
    var grade: String
}
