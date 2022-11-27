//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Michael Brockman on 10/30/22.
//

import UIKit

class ImageSaver: NSObject {
  var successHandler: (() -> Void)?
  var errorHandler: ((Error) -> Void)?
  
  func writeToPhotoAlbum(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
  }
  
  @objc func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error {
      errorHandler?(error)
    } else {
      successHandler?()
    }
  }
}
