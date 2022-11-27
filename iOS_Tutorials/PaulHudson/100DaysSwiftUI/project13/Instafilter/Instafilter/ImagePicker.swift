//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Michael Brockman on 10/30/22.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
//  this line prompts for stubs to conform to protocl UIViewControllerRepresentable of type PHPickerViewController
//  typealias UIViewControllerType = PHPickerViewController
  
  @Binding var image: UIImage?
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      //image picked
      //1- tell picker we are done, dismiss yourself
      picker.dismiss(animated: true)
      
      //2- exit if user made no selection
      guard let provider = results.first?.itemProvider else { return }
      
      //3- otherwise grab result from results
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, _ in
          self.parent.image = image as? UIImage
        }
      }
      
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
    //nothing to see here for this app
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
}
