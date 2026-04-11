import UIKit

enum QRStorage {
    private static let fileName = "user_qr.jpg"

    private static var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }

    static func save(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Ошибка сохранения QR: \(error.localizedDescription)")
        }
    }

    static func load() -> UIImage? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    static func delete() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Ошибка удаления QR: \(error.localizedDescription)")
        }
    }
}
