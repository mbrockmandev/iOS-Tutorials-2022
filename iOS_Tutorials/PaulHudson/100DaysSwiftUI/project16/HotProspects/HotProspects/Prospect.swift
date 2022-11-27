//
//  Prospect.swift
//  HotProspects
//
//  Created by Michael Brockman on 11/7/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
  var id = UUID()
  var name = "Anonymous"
  var emailAddress = ""
  var dateAdded = Date()
  fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
  @Published private(set) var people: [Prospect]
  let saveKey = "SavedData"
  
  enum SortingOptions {
    case name
    case mostRecent
  }
  
  init() {
    //decoding using file manager/documents directory
    let url = URL.documentsDirectory.appendingPathComponent(saveKey, conformingTo: .utf8PlainText)
    
    if let data = try? Data(contentsOf: url) {
      if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
        people = decoded
        return
      }
    }
    people = []
    
      
      //decoding using userdefaults
//    if let data = UserDefaults.standard.data(forKey: saveKey) {
//      if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//        people = decoded
//        return
//      }
//    }
//    people = []
  }
  
  func toggle(_ prospect: Prospect) {
    objectWillChange.send()
    prospect.isContacted.toggle()
    save()
  }
  
  private func save() {
    let fileIOController = FileIOController()
    do {
      try fileIOController.write(people, toDocumentNamed: saveKey)
    } catch {
      print("Problem writing to disk.")
    }
    
//    if let encoded = try? JSONEncoder().encode(people) {
//      FileManager.default.setValue(encoded, forKey: saveKey)
//      UserDefaults.standard.set(encoded, forKey: saveKey)
//    }
  }
  
  func add(_ prospect: Prospect) {
    people.append(prospect)
    save()
  }
  
  func sort(by sort: SortingOptions) {
    
    switch sort {
    case .name:
      people = people.sorted(by: {
        $0.name < $1.name
      })
    case .mostRecent:
      people = people.sorted(by: {
        $0.dateAdded > $1.dateAdded
      })
    }
  }
  
}

struct FileIOController {
  func write<T: Encodable>(_ value: T, toDocumentNamed documentName: String, encodedUsing encoder: JSONEncoder = .init()) throws {
    let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = folderURL.appendingPathComponent(documentName)
    let data = try encoder.encode(value)
    try data.write(to: fileURL)
  }
}
