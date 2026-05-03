struct Lesson: Identifiable {
    var id: String
    var title: String
    var date: String
    var status: String
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
