import Foundation
import FirebaseFirestoreSwift


struct Classroom: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let number: String
    let coordinateX: Double
    let coordinateY: Double
    let neighbors: [String]

    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        return lhs.number == rhs.number
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}

struct ClassroomWithFloor: Hashable {
    let classroom: Classroom
    let floor: String
}

struct Floor: Codable, Identifiable {
    @DocumentID var id: String?
    let number: String
    let name: String
    let imageName: String

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case name
        case imageName = "imagename"
    }
}
