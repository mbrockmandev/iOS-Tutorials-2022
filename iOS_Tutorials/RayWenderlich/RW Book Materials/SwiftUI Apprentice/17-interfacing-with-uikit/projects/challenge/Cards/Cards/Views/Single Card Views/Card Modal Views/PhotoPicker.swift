/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @Binding var images: [UIImage]

  func makeUIViewController(context: Context) -> some UIViewController {
    // 1
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    // 2
    configuration.selectionLimit = 0
    // 3
    let picker =
      PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }

  func makeCoordinator() -> PhotosCoordinator {
    PhotosCoordinator(parent: self)
  }

  class PhotosCoordinator: NSObject,
    PHPickerViewControllerDelegate {
    var parent: PhotoPicker

    init(parent: PhotoPicker) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      let itemProviders = results.map(\.itemProvider)
      for item in itemProviders {
        // load the image from the item here
        // 1
        if item.canLoadObject(ofClass: UIImage.self) {
          // 2
          item.loadObject(ofClass: UIImage.self) { image, error in
            // 3
            if let error = error {
              print("Error!", error.localizedDescription)
            } else {
              // 4
              DispatchQueue.main.async {
                if let image = image as? UIImage {
                  self.parent.images.append(image)
                }
              }
            }
          }
        }
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct PhotoPicker_Previews: PreviewProvider {
  static var previews: some View {
    PhotoPicker(images: .constant([UIImage]()))
  }
}
