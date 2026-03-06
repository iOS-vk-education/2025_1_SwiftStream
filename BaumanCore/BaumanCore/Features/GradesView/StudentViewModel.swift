import Foundation
import FirebaseFirestore
import FirebaseAuth

class StudentViewModel: ObservableObject {

    @Published var subjects: [SubjectData] = []
    @Published var semesters: [Semester] = []

    private let db = Firestore.firestore()

    func fetchStudent() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("UID не найден")
            return
        }

        let userRef = db.collection("users").document(uid)

        var loadedSubjects: [SubjectData] = []
        var loadedSemesters: [Semester] = []

        let group = DispatchGroup()

        // текущая
        group.enter()
        userRef.collection("subjects").getDocuments { snapshot, error in

            if let docs = snapshot?.documents {

                let subjectsGroup = DispatchGroup()

                for doc in docs {

                    subjectsGroup.enter()

                    let data = doc.data()

                    let id = doc.documentID
                    let name = data["name"] as? String ?? ""
                    let progress = data["progress"] as? String ?? ""

                    doc.reference.collection("lessons").getDocuments { lessonsSnapshot, _ in

                        var lessons: [Lesson] = []

                        if let lessonDocs = lessonsSnapshot?.documents {

                            lessons = lessonDocs.map { lDoc in

                                let lData = lDoc.data()

                                return Lesson(
                                    id: lDoc.documentID,
                                    title: lData["title"] as? String ?? "",
                                    date: lData["date"] as? String ?? "",
                                    status: lData["status"] as? String ?? ""
                                )
                            }

                            // сортировка уроков по дню и месяцу
                            lessons.sort {
                                Self.dayMonthValue($0.date) < Self.dayMonthValue($1.date)
                            }
                        }

                        let subject = SubjectData(
                            id: id,
                            name: name,
                            progress: progress,
                            lessons: lessons
                        )

                        loadedSubjects.append(subject)

                        subjectsGroup.leave()
                    }
                }

                subjectsGroup.notify(queue: .main) {
                    group.leave()
                }

            } else {
                group.leave()
            }
        }

        // семестры
        group.enter()
        userRef.collection("semesters").getDocuments { snapshot, error in

            if let docs = snapshot?.documents {

                let semestersGroup = DispatchGroup()

                for doc in docs {

                    semestersGroup.enter()

                    let data = doc.data()

                    let semesterID = doc.documentID
                    let title = data["title"] as? String ?? ""

                    doc.reference.collection("subjects").getDocuments { subjectsSnapshot, _ in

                        var semesterSubjects: [SemesterSubject] = []

                        if let subjectDocs = subjectsSnapshot?.documents {

                            semesterSubjects = subjectDocs.map { sDoc in

                                let sData = sDoc.data()

                                return SemesterSubject(
                                    id: sDoc.documentID,
                                    name: sData["name"] as? String ?? "",
                                    grade: sData["grade"] as? String ?? ""
                                )
                            }

                            // сортировка предметов внутри семестра
                            semesterSubjects.sort {
                                Self.extractNumber($0.id) < Self.extractNumber($1.id)
                            }
                        }

                        let semester = Semester(
                            id: semesterID,
                            title: title,
                            subjects: semesterSubjects
                        )

                        loadedSemesters.append(semester)

                        semestersGroup.leave()
                    }
                }

                semestersGroup.notify(queue: .main) {
                    group.leave()
                }

            } else {
                group.leave()
            }
        }

        
        group.notify(queue: .main) {

            // сортировка текущих предметов
            self.subjects = loadedSubjects.sorted {
                Self.extractNumber($0.id) < Self.extractNumber($1.id)
            }

            // сортировка семестров по убыванию номера
            self.semesters = loadedSemesters.sorted {
                Self.extractSemesterNumber($0.id) > Self.extractSemesterNumber($1.id)
            }
        }
    }

    // сортировка lessons по дате
    private static func dayMonthValue(_ dateString: String) -> Int {

        let normalized = dateString
            .replacingOccurrences(of: "-", with: ".")
            .split(separator: ".")

        guard normalized.count >= 2,
              let day = Int(normalized[0]),
              let month = Int(normalized[1]) else {
            return 0
        }

        return month * 100 + day
    }

    // сортировка предметов в текущих
    private static func extractNumber(_ id: String) -> Int {

        let numbers = id.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        return Int(numbers) ?? 0
    }

    // сортировка семестров
    private static func extractSemesterNumber(_ id: String) -> Int {

        let number = id.replacingOccurrences(of: "semester", with: "")
        return Int(number) ?? 0
    }
}
