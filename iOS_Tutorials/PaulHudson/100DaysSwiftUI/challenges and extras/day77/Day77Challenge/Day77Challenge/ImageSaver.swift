  //
  //  ImageSaver.swift
  //  Day77Challenge
  //
  //  Created by Michael Brockman on 11/3/22.
  //

import UIKit

class ImageSaver: NSObject {

  
  func saveImageToDirectory(image: UIImage, id: UUID) {
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      let url =  Item.documentsDirectory.appendingPathComponent("\(id).jpg")
      
      do {
        try jpegData.write(to: url, options: [.atomic, .completeFileProtection])
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
