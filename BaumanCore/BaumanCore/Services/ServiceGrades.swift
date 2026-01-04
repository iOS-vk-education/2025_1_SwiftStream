import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseService {
    
    func fetchStudent(completion: @escaping (Student?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Ошибка: пользователь не залогинен")
            completion(nil)
            return
        }
        
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let value = snapshot.value as? [String: Any] else {
                print("Ошибка: не удалось получить словарь из snapshot")
                completion(nil)
                return
            }
            
            let name = value["name"] as? String ?? ""
            let faculty = value["faculty"] as? String ?? ""
            let group = value["group"] as? String ?? ""
            let studentID = value["studentID"] as? String ?? ""
            let email = value["email"] as? String ?? ""
            
            var subjects: [SubjectData] = []
            if let subjectsDict = value["subjects"] as? [String: Any] {
                for (_, subjectData) in subjectsDict {
                    if let subjectDict = subjectData as? [String: Any] {
                        let name = subjectDict["name"] as? String ?? ""
                        let progress = subjectDict["progress"] as? String ?? "0/100"
                        var lessons: [Lesson] = []
                        if let lessonsDict = subjectDict["lessons"] as? [String: Any] {
                            for (_, lessonData) in lessonsDict {
                                if let lessonDict = lessonData as? [String: Any] {
                                    let lesson = Lesson(
                                        id: UUID().uuidString,
                                        title: lessonDict["title"] as? String ?? "",
                                        date: lessonDict["date"] as? String ?? "",
                                        status: lessonDict["status"] as? String ?? ""
                                    )
                                    lessons.append(lesson)
                                }
                            }
                        }
                        subjects.append(SubjectData(id: UUID().uuidString, name: name, progress: progress, lessons: lessons))
                    }
                }
            }
            
            var semesters: [Semester] = []
            if let semestersDict = value["semesters"] as? [String: Any] {
                for (_, semesterData) in semestersDict {
                    if let semesterDict = semesterData as? [String: Any] {
                        let title = semesterDict["title"] as? String ?? ""
                        var semesterSubjects: [SemesterSubject] = []
                        if let subjectsDict = semesterDict["subjects"] as? [String: Any] {
                            for (_, subjectData) in subjectsDict {
                                if let subDict = subjectData as? [String: Any] {
                                    let name = subDict["name"] as? String ?? ""
                                    let grade = subDict["grade"] as? String ?? ""
                                    semesterSubjects.append(SemesterSubject(id: UUID().uuidString, name: name, grade: grade))
                                }
                            }
                        }
                        semesters.append(Semester(id: UUID().uuidString, title: title, subjects: semesterSubjects))
                    }
                }
            }
            
            let student = Student(
                name: name,
                faculty: faculty,
                group: group,
                studentID: studentID,
                email: email,
                subjects: subjects,
                semesters: semesters
            )
            
            completion(student)
        }
    }
}



