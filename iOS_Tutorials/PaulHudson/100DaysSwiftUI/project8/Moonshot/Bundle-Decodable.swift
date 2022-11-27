//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Michael Brockman on 10/16/22.
//

import Foundation

extension Bundle {
  func decode<T: Codable>(_ file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate \(file) in bundle.")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to locate \(file) in bundle.")
    }
    
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.dateFormat = "y-MM-dd"
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    guard let loaded = try? decoder.decode(T.self, from: data) else { fatalError("Failed to locate \(file) in bundle.")
    }
    
    return loaded
  }
}

//maybe this works? borrowed logic from day 68 for
extension FileManager {
  
  ///provides URL for generic func decode which allows us to load and decode and Codable compliant data structures in app bundle using FileManager.
  static func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
  }
  
  ///use with getDocumentsDirectory() to return a URL
  static func decode<T: Codable>(_ file: URL) -> T {
    guard let data = try? Data(contentsOf: file) else {
      fatalError("Failed to locate \(file) in files.")
    }
    
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.dateFormat = "y-MM-dd"
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    guard let loaded = try? decoder.decode(T.self, from: data) else {
      fatalError("Failed to load data from file.")
    }
    
    return loaded
    
    
  }
  
}
