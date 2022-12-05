  //
  //  DataManager.swift
  //  Project30
  //
  //  Created by Michael Brockman on 11/28/22.
  //  Copyright © 2022 Hudzilla. All rights reserved.
  //

import Foundation

enum DataManager {
  
  static let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  static func load() -> [Item] {
    if let data = try? Data(contentsOf: savePath) {
      if let decoded = try? JSONDecoder().decode([Item].self, from: data) {
        return decoded
      }
    }
    return []
  }
  
  static func save(_ items: [Item]) {
    if let data = try? JSONEncoder().encode(items) {
      try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
    }
  }
  
}
