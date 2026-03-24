import Foundation

@MainActor
final class MainPageViewModel: ObservableObject {
    private static var hasLoaded = false
    
    func loadIfNeeded(appState: AppState) {
        // Если уже загружали — выходим сразу
        guard !MainPageViewModel.hasLoaded else { return }
        MainPageViewModel.hasLoaded = true
        
        FirebaseService().fetchStudent { [weak appState] fetchedStudent in
            guard let appState = appState else { return }
            if let fetchedStudent = fetchedStudent {
                appState.student = fetchedStudent
            }
        }
    }
    
    static func reset() {
        hasLoaded = false
    }
}
