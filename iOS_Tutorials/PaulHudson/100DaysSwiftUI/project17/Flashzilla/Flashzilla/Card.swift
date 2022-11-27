//
//  Card.swift
//  Flashzilla
//
//  Created by Michael Brockman on 11/9/22.
//

import Foundation

struct Card: Codable, Identifiable, Hashable, Equatable {
  var id = UUID()
  let prompt: String
  let answer: String
  
  static let example = Card(prompt: "Who played the 13th doctor in Doctor Who?", answer: "Jodie Whittaker")
}


//struct FileIOController {
//  func write<T: Encodable>(_ value: T, toDocumentNamed documentName: String, encodedUsing encoder: JSONEncoder = .init()) throws {
//    let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let fileURL = folderURL.appendingPathComponent(documentName)
//    let data = try encoder.encode(value)
//    try data.write(to: fileURL)
//  }
//
//  func read<T: Decodable>(_ value: T, fromDocumentNamed documentName: String, decodedUsing decoder: JSONDecoder = .init()) throws {
//    let url = URL.documentsDirectory.appendingPathComponent(documentName)
//    let decoded = try decoder.decode(value.self as! T.Type, from: Data(contentsOf: url))
//  }
//}

//let url = URL.documentsDirectory.appendingPathComponent("Cards", conformingTo: .utf8PlainText)
//
//if let data = try? Data(contentsOf: url) {
//  if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//    cards = decoded
//  }
//  }
