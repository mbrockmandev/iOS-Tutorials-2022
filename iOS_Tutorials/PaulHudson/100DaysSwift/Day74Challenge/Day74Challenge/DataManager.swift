//
//  FileManager.swift
//  Day74Challenge
//
//  Created by Michael Brockman on 11/15/22.
//

import Foundation

struct DataManager {
  static let savePath = URL.documentsDirectory.appendingPathComponent("SaveData")
  
  static func load() -> [Note] {
    if let data = try? Data(contentsOf: savePath) {
      if let decoded = try? JSONDecoder().decode([Note].self, from: data) {
        return decoded
      }
    }
    return Note.example
  }
  
  static func save(_ notes: [Note]) {
    if let data = try? JSONEncoder().encode(notes) {
      try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
    }
  }
  
}

