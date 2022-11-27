  //
  //  ActivityList.swift
  //  HabitTracker
  //
  //  Created by Michael Brockman on 10/18/22.
  //
//TODO: Add functionality to remove items from list, also customize the detail view for adding items. 
import SwiftUI

class ActivityList: ObservableObject, Equatable {
  ///Class ActivityList is an ObservableObject meant to be passed from view to view without need to copy values. It has one property: "list" which is an array of Activity.
  ///Note: an empty initializer will provide default data.
  @Published var list: [Activity]
  
  enum CodingKeys: CodingKey {
    case list
  }
  
  static func == (lhs: ActivityList, rhs: ActivityList) -> Bool {
    lhs.list == rhs.list
  }
  
  enum FileError: Error {
    case loadFailure
    case saveFailure
    case urlFailure
  }
  
  func getURL() -> URL? {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return documentsURL.appendingPathExtension("userList.plist")
  }
  
  func saveData() throws {
    guard let dataURL = getURL() else { throw FileError.urlFailure }

    print(">>> Saving data called")
    
    let plistData = list.map { [$0.id.uuidString, $0.title, $0.description] }
    
    do {
      let data = try PropertyListSerialization.data(fromPropertyList: plistData, format: .binary, options: .zero)
      try data.write(to: dataURL, options: .atomic)
    } catch {
      throw FileError.saveFailure
    }
    
  }
  
  func loadData() throws {
    guard let dataURL = getURL() else {
      throw FileError.loadFailure
    }
    print(">>> Loading data")
  
    do {
      if let data = try? Data(contentsOf: dataURL) {
        let plistData = try PropertyListSerialization.propertyList(from: data, format: nil)
        let convertedPlistData = plistData as? [[Any]] ?? []
        
        list = convertedPlistData.map {
          Activity(id: $0[0] as? UUID ?? UUID(), title: $0[1] as! String, description: $0[2] as! String)
        }
      }
    } catch {
      throw FileError.loadFailure
    }
    
  }
  
  func deleteActivity() {
    
  }
  
  init(list: [Activity]) {
    self.list = list
  }
  
  init() {
    self.list = [
      Activity(id: UUID(), title: "Testing", description: "This is a description1", completions: 1),
      Activity(id: UUID(), title: "Testing2", description: "This is a description1", completions: 2),
      Activity(id: UUID(), title: "Testing3", description: "This is a description1", completions: 3),
      Activity(id: UUID(), title: "Testing4", description: "This is a description1", completions: 4),
    ]
  }
}
