import UIKit

final class AvatarStorage {
    private static let fileName = "user_avatar.jpg"
    private static let maxFileSize: Int = 300_000
    private static let maxCompressionIterations = 10

    private static var fileURL: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(fileName)
    }

    static func save(_ image: UIImage?) {
        guard let image = image,
              let url = fileURL else { return }

        var compression: CGFloat = 0.9
        var data: Data?

        for _ in 0..<maxCompressionIterations {
            data = image.jpegData(compressionQuality: compression)
            if let data = data, data.count <= maxFileSize { break }
            compression -= 0.1
        }

        guard let finalData = data else { return }
        try? finalData.write(to: url)
    }

    static func load() -> UIImage? {
        guard let url = fileURL,
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func delete() {
        guard let url = fileURL else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
