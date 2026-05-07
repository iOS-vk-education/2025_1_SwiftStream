import Foundation
import FirebaseFirestore
import FirebaseAuth

class StudentViewModel: ObservableObject {

    @Published var subjects: [SubjectData] = []
    @Published var semesters: [Semester] = []
    @Published var student: Student?

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


        group.enter()
        userRef.collection("subjects").getDocuments { snapshot, error in

            if let docs = snapshot?.documents {

                let subjectsGroup = DispatchGroup()

                for doc in docs {

                    subjectsGroup.enter()

                    let data = doc.data()
                    
                    let id = doc.documentID
                    let nameLocalized = self.localizedMap(from: data["name"])
                    let progress = data["progress"] as? String ?? ""


                    doc.reference.collection("lessons").getDocuments { lessonsSnapshot, _ in

                        var lessons: [Lesson] = []

                        if let lessonDocs = lessonsSnapshot?.documents {

                            lessons = lessonDocs.map { lDoc in

                                let lData = lDoc.data()
                                
                                return Lesson(
                                    id: lDoc.documentID,
                                    titleLocalized: self.localizedMap(from: lData["title"]),
                                    date: lData["date"] as? String ?? "",
                                    statusLocalized: self.localizedMap(from: lData["status"])
                                )
                            }

                          
                            lessons.sort {
                                Self.dayMonthValue($0.date) < Self.dayMonthValue($1.date)
                            }
                        }

                        let subject = SubjectData(
                            id: id,
                            nameLocalized: nameLocalized,
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


        group.enter()
        userRef.collection("semesters").getDocuments { snapshot, error in

            if let docs = snapshot?.documents {

                let semestersGroup = DispatchGroup()

                for doc in docs {

                    semestersGroup.enter()

                    let data = doc.data()

                    let semesterID = doc.documentID
                    let titleLocalized = self.localizedMap(from: data["title"])

                    doc.reference.collection("subjects").getDocuments { subjectsSnapshot, _ in

                        var semesterSubjects: [SemesterSubject] = []

                        if let subjectDocs = subjectsSnapshot?.documents {

                            semesterSubjects = subjectDocs.map { sDoc in

                                let sData = sDoc.data()

                                return SemesterSubject(
                                    id: sDoc.documentID,
                                    nameLocalized: self.localizedMap(from: sData["name"]),
                                    gradeLocalized: self.localizedMap(from: sData["grade"])
                                )
                            }

                  
                            semesterSubjects.sort {
                                Self.extractNumber($0.id) < Self.extractNumber($1.id)
                            }
                        }
                        
                        let semester = Semester(
                            id: semesterID,
                            titleLocalized: titleLocalized,
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

        
            self.subjects = loadedSubjects.sorted {
                Self.extractNumber($0.id) < Self.extractNumber($1.id)
            }

          
            self.semesters = loadedSemesters.sorted {
                Self.extractSemesterNumber($0.id) > Self.extractSemesterNumber($1.id)
            }
        }
    }
    private func localizedString(from value: Any?) -> String {
        if let string = value as? String {
            return string
        }

        if let map = value as? [String: String] {
            return map["ru"]
            ?? map["en"]
            ?? map["zh"]
            ?? map.values.first
            ?? ""
        }

        if let map = value as? [String: Any] {
            return map["ru"] as? String
            ?? map["en"] as? String
            ?? map["zh"] as? String
            ?? map.values.compactMap { $0 as? String }.first
            ?? ""
        }

        return ""
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

   
    private static func extractNumber(_ id: String) -> Int {

        let numbers = id.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        return Int(numbers) ?? 0
    }

    
    private static func extractSemesterNumber(_ id: String) -> Int {

        let number = id.replacingOccurrences(of: "semester", with: "")
        return Int(number) ?? 0
    }
}
