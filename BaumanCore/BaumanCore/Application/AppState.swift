import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var student: Student? = nil

    func setLoggedIn(student: Student) {
        self.student = student
        self.isLoggedIn = true
    }

    func logout() {
        self.student = nil
        self.isLoggedIn = false
    }
}
