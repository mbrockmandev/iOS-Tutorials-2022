  //  //
  //  //  ImagePicker.swift
  //  //  Day77Challenge
  //  //
  //  //  Created by Michael Brockman on 11/3/22.
  //  //
  //
  //import PhotosUI
  //import SwiftUI
  //
  //struct ImagePicker: UIViewControllerRepresentable {
  //
  //  @Binding var inputImage: UIImage
  //
  //  class Coordinator: NSObject, PHPickerViewControllerDelegate {
  //    var parent: ImagePicker
  //
  //    init(_ parent: ImagePicker) {
  //      self.parent = parent
  //    }
  //
  //    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
  //      picker.dismiss(animated: true)
  //
  //      guard let provider = results.first?.itemProvider else { return }
  //
  //      if provider.canLoadObject(ofClass: UIImage.self) {
  //        provider.loadObject(ofClass: UIImage.self) { image, _  in
  //          Task {
  //            await MainActor.run {
  //              self.parent.inputImage = image ?? UIImage(systemName: "star.fill")!
  //              print(">>> picker has run inputImage: \(String(describing: self.parent.inputImage)) and image: \(String(describing: image))")
  //            }
  //          }
  //        }
  //      }
  //    }
  //  }//end Coordinator class
  //
  //  func makeUIViewController(context: Context) -> PHPickerViewController {
  //    var config = PHPickerConfiguration()
  //    config.filter = .images
  //
  //    let picker = PHPickerViewController(configuration: config)
  //    picker.delegate = context.coordinator
  //    return picker
  //  }
  //
  //  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
  //
  //  }
  //
  //  func makeCoordinator() -> Coordinator {
  //    Coordinator(self)
  //  }
  //
  //}

  //
  //  ImagePicker.swift
  //  Instafilter
  //
  //  Created by Paul Hudson on 01/12/2021.
  //

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      
      if results.isEmpty {
        picker.dismiss(animated: true)
        return
      }
      
      
      guard let provider = results.first?.itemProvider else { return }
      
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, _ in
          self.parent.image = image as? UIImage
//          print(">>> picker run.")
//          print(">>> \(String(describing: self.parent.image))")
//          print(">>> \(String(describing: image))")
        }
      }
      
      picker.dismiss(animated: true)
    }
  }
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    
    
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}
