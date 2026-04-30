import SwiftUI
import FirebaseAuth

@MainActor
final class AppState: ObservableObject {
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    @Published var isAuthResolved: Bool = false
    @Published var student: Student? = nil
    @Published var selectedTab: Int = 0
    @Published var pendingFromLocation: String?
    @Published var pendingToLocation: String?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.isAuthResolved = true

            if user == nil {
                self.student = nil
                MainPageViewModel.reset()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Ошибка выхода из аккаунта: \(error.localizedDescription)")
        }
    }

    deinit {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }
}
