import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    let sourceType: UIImagePickerController.SourceType
    let allowsEditing: Bool
    let onImagePicked: ((UIImage) -> Void)?

    init(
        image: Binding<UIImage?>,
        sourceType: UIImagePickerController.SourceType = .photoLibrary,
        allowsEditing: Bool = true,
        onImagePicked: ((UIImage) -> Void)? = nil
    ) {
        self._image = image
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
        self.onImagePicked = onImagePicked
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = allowsEditing
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context: Context) { }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage

            parent.image = selectedImage

            if let selectedImage {
                parent.onImagePicked?(selectedImage)
            }

            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
