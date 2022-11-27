//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Michael Brockman on 11/13/22.
//

import Foundation

class Favorites: ObservableObject {
  private var resorts: Set<String>
//  private let saveKey = "Favorites"
  private let savePath = URL.documentsDirectory.appendingPathComponent("Favorites.json")
  
  init() {
    //load save data here
    
    if let data = try? Data(contentsOf: savePath) {
      if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
        resorts = decoded
        print(">>> Successfully loaded data: \(resorts)")
        return
      }
    }
    resorts = []
  }
  
  func contains(_ resort: Resort) -> Bool {
    resorts.contains(resort.id)
  }
  
  func add(_ resort: Resort) {
    objectWillChange.send()
    resorts.insert(resort.id)
    save()
  }
  
  func remove(_ resort: Resort) {
    objectWillChange.send()
    resorts.remove(resort.id)
    save()
  }
  
  func save() {
    if let data = try? JSONEncoder().encode(resorts) {
      try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
      print(">>> Successfully saved data: \(resorts) to: \(savePath)")
    }
  }
  
}
