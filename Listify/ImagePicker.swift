import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = context.coordinator
        return imagePickerViewController
    }
    func makeCoordinator() -> Coordinator {
       return ImagePickerCoordinator(self)
    }
}

class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var parent: ImagePicker
    init(_ parent: ImagePicker) {
        self.parent = parent
        super.init()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return}
        self.parent.image = image
        picker.dismiss(animated: true)
    }
}
