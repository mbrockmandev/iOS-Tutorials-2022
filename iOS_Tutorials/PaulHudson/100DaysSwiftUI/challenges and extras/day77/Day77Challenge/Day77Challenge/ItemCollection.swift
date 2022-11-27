//
//  ItemCollection.swift
//  Day77Challenge
//
//  Created by Michael Brockman on 11/5/22.
//

import Foundation

class ItemCollection: ObservableObject {
  @Published var items = [Item]() {
    didSet {
      let encoder = JSONEncoder()
      
      if let encoded = try? encoder.encode(items) {
        let url = Item.documentsDirectory.appendingPathComponent("items.json")
        try? encoded.write(to: url, options: [.atomic, .completeFileProtection])
//        print(">>> items saved.")
      } else {
        fatalError("ERROR! COULD NOT ENCODE")
      }
    }
  }
  
  init() {
    let file = "items.json"
    let url = Item.documentsDirectory.appendingPathComponent("items.json")
    
    guard let data = try? Data(contentsOf: url) else {
      print(">>> no \(file) file so empty array it is.")
      self.items = []
      return
    }
    
    let decoder = JSONDecoder()
    guard let decodedItems = try? decoder.decode([Item].self, from: data) else {
      fatalError("Failed to decode \(file)")
    }
    self.items = decodedItems
  }
  
  func append(_ item: Item) {
    self.items.append(item)
    print(">>> item added")
  }
  
  func removeItem(_ item: Item) {
    
    let index = items.firstIndex { newItem in
      item.name == newItem.name
    }
    if let index {
      items.remove(at: index)
      print(">>> item removed")
    }
    
  }
  
  func indexOf(_ item: Item) -> Int? {
    items.firstIndex(of: item)
  }
  
  
  

}
