//
//  Item.swift
//  Project30
//
//  Created by Michael Brockman on 11/28/22.
//  Copyright © 2022 Hudzilla. All rights reserved.
//

import UIKit

struct Item {
  var id: UUID
  var image: String
  var count: Int
  
  var uiImage: UIImage? {
    guard let jpegImage,
          let image = UIImage(data: jpegImage) else {
      return nil
    }
    return image
  }
  
  var jpegImage: Data? {
    guard let image = UIImage(named: image) else { return nil }
    return image.jpegData(compressionQuality: 0.8)
  }
}

extension Item: Codable {
  
}
