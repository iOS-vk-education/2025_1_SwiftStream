import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var student: Student? = nil
    
    func logout() {
        MainPageViewModel.reset()
        student = nil        
        isLoggedIn = false
    }
}
