  //
  //  Item.swift
  //  Day77Challenge
  //
  //  Created by Michael Brockman on 11/4/22.
  //

import SwiftUI
import CoreLocation

struct Item: Codable, Identifiable, Equatable, Comparable {
  static let example = Item(UUID(), name: "Taylor Swift")
  static let defaultImage = Image(uiImage: UIImage(systemName: "star.fill")!)
  static let documentsDirectory = URL.documentsDirectory
    //  static let documentsDirectory = FileManager.default.urls(for: .userDirectory, in: .userDomainMask).first!
  
  var id: UUID
  var name: String
  var latitude: CLLocationDegrees?
  var longitude: CLLocationDegrees?
  
  var location: CLLocationCoordinate2D? {
    guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
    
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  var image: Image? {
    let url = Item.documentsDirectory.appendingPathComponent("\(id).jpg")
    
    do {
      guard let uiImage = try UIImage(data: Data(contentsOf: url)) else {
        print("Error creating UIImage from url \(url)")
        return nil
      }
      
      return Image(uiImage: uiImage)
      
    } catch {
      print(error.localizedDescription)
      
    }
    return nil
  }
  
  init(_ id: UUID = UUID(), name: String) {
    self.id = id
    self.name = name
  }
  
  static func == (lhs: Item, rhs: Item) -> Bool {
    lhs.id == rhs.id
  }
  
  static func < (lhs: Item, rhs: Item) -> Bool {
    lhs.name < rhs.name
  }
  
  mutating func setLocation(location: CLLocationCoordinate2D) {
    self.latitude = location.latitude
    self.longitude = location.longitude
  }
  
  mutating func writeImageToDisk(image: UIImage) {
    let imageSaver = ImageSaver()
    imageSaver.saveImageToDirectory(image: image, id: id)
  }
    
}
