import Foundation

struct News: Identifiable, Hashable {
    let id: String
    let title: String
    let imageURL: URL?
    let pageURL: URL?
}
