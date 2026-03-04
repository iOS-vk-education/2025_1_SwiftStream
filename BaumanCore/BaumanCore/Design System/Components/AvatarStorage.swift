import UIKit

final class AvatarStorage {
    private static let maxCompressionQuality: CGFloat = 0.7
    private static let maxSize: CGFloat = 800

    private static func fileURL(for userID: String) -> URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("avatar_\(userID).jpg")
    }

    static func save(_ image: UIImage?, userID: String) async {
        guard let image = image, let url = fileURL(for: userID) else { return }

        let resized = resize(image, to: maxSize)
        guard let data = resized.jpegData(compressionQuality: maxCompressionQuality) else { return }

        do {
            try data.write(to: url)
        } catch {
            print("Ошибка при сохранении аватара для \(userID): \(error)")
        }
    }

    static func load(userID: String) async -> UIImage? {
        guard let url = fileURL(for: userID) else { return nil }

        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Ошибка при загрузке аватара для \(userID): \(error)")
            return nil
        }
    }

    static func delete(userID: String) {
        guard let url = fileURL(for: userID) else { return }
        try? FileManager.default.removeItem(at: url)
    }

    private static func resize(_ image: UIImage, to maxSize: CGFloat) -> UIImage {
        let ratio = max(image.size.width, image.size.height) / maxSize
        guard ratio > 1 else { return image }

        let newSize = CGSize(
            width: image.size.width / ratio,
            height: image.size.height / ratio
        )

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
    }
}
