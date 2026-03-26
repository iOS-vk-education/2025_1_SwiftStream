import Foundation
import UIKit

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var student: Student?
    @Published var avatar: UIImage?

    private var hasLoadedStudent = false
    private let firebaseService = FirebaseService()
    
    func loadIfNeeded() {
        guard !hasLoadedStudent else { return }
        hasLoadedStudent = true
        
        firebaseService.fetchStudent { [weak self] fetchedStudent in
            guard let self = self else { return }
            self.student = fetchedStudent
            
            if let studentID = fetchedStudent?.studentID, !studentID.isEmpty {
                Task {
                    self.avatar = await AvatarStorage.load(userID: studentID)
                }
            }
        }
    }
    

    func deleteAvatar() {
        avatar = nil

        let userID: String
        if let id = student?.studentID, !id.isEmpty {
            userID = id
        } else {
            userID = "anonymous"
        }
        
        AvatarStorage.delete(userID: userID)
    }
    
    func refresh() {
        hasLoadedStudent = false
        loadIfNeeded()
    }
}
