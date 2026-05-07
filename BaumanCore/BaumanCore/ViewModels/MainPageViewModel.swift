import Foundation

@MainActor
final class MainPageViewModel: ObservableObject {
    private static var hasLoaded = false

    func loadIfNeeded(appState: AppState) {
        guard appState.isLoggedIn else { return }
        guard !MainPageViewModel.hasLoaded else { return }

        MainPageViewModel.hasLoaded = true

        FirebaseService().fetchStudent { [weak appState] fetchedStudent in
            Task { @MainActor in
                guard let appState = appState else { return }

                guard appState.isLoggedIn else { return }

                if let fetchedStudent = fetchedStudent {
                    appState.student = fetchedStudent
                } else {
                    MainPageViewModel.hasLoaded = false
                }
            }
        }
    }

    static func reset() {
        hasLoaded = false
    }
}
