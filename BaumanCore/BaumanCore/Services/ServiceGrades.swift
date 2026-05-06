import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    
    
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
    
    func fetchStudent(completion: @escaping (Student?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Пользователь не авторизован")
            completion(nil)
            return
        }
        
        print("Firestore: Запрос для UID = \(uid)")
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            
            if let error = error {
                print("Ошибка Firestore: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("Документ не найден в коллекции 'users'")
                print("Проверьте в Firebase Console: Firestore → users → \(uid)")
                completion(nil)
                return
            }
            
            guard let data = snapshot.data() else {
                print("Не удалось получить данные из документа")
                completion(nil)
                return
            }
            
            print("Документ получен! Данные: \(data)")
            
            let nameLocalized = self.localizedMap(from: data["name"])
            let groupLocalized = self.localizedMap(from: data["groupLocalized"])
            let faculty = data["faculty"] as? String ?? ""
            let studentID = data["studentID"] as? String ?? ""
            let email = data["email"] as? String ?? ""

            print("Извлечено имя: '\(nameLocalized)'")
            print("Извлечена группа: '\(groupLocalized)'")
            
            var subjects: [SubjectData] = []
            if let subjectsData = data["subjects"] as? [[String: Any]] {
                for subjectDict in subjectsData {
                    let name = subjectDict["name"] as? String ?? ""
                    let progress = subjectDict["progress"] as? String ?? "0/100"
                    var lessons: [Lesson] = []
                    
                    if let lessonsArray = subjectDict["lessons"] as? [[String: Any]] {
                        for lessonDict in lessonsArray {
                            let lesson = Lesson(
                                id: UUID().uuidString,
                                title: lessonDict["title"] as? String ?? "",
                                date: lessonDict["date"] as? String ?? "",
                                status: lessonDict["status"] as? String ?? ""
                            )
                            lessons.append(lesson)
                        }
                    }
                    subjects.append(SubjectData(id: UUID().uuidString, name: name, progress: progress, lessons: lessons))
                }
            }
            
            var semesters: [Semester] = []
            if let semestersData = data["semesters"] as? [[String: Any]] {
                for semesterDict in semestersData {
                    let title = semesterDict["title"] as? String ?? ""
                    var semesterSubjects: [SemesterSubject] = []
                    
                    if let subjectsArray = semesterDict["subjects"] as? [[String: Any]] {
                        for subDict in subjectsArray {
                            let name = subDict["name"] as? String ?? ""
                            let grade = subDict["grade"] as? String ?? ""
                            semesterSubjects.append(SemesterSubject(id: UUID().uuidString, name: name, grade: grade))
                        }
                    }
                    semesters.append(Semester(id: UUID().uuidString, title: title, subjects: semesterSubjects))
                }
            }
            
            let student = Student(
                nameLocalized: nameLocalized,
                faculty: faculty,
                groupLocalized: groupLocalized,
                studentID: studentID,
                email: email,
                subjects: subjects,
                semesters: semesters
            )

            print("Student создан успешно: \(student.localizedName(languageCode: "ru"))")
            completion(student)
        }
    }
}
