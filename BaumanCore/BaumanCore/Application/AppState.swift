import SwiftUI

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var student: Student? = nil
}
