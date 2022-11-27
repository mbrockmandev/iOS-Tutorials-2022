//
//  Activity.swift
//  HabitTracker
//
//  Created by Michael Brockman on 10/18/22.
//

import Foundation

struct Activity: Codable, Identifiable, Equatable, Hashable {
  ///The Activity Struct stores an ID (UUID), a title, a brief description, and the number of times this task has been completed. 
  static func == (lhs: Activity, rhs: Activity) -> Bool {
    lhs.id == rhs.id
  }
  
  var id: UUID = UUID()
  var title: String
  var description: String
  var completions: Int = 0
  
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static let defaultList = [
    Activity(id: UUID(), title: "Testing", description: "This is a description1", completions: 1),
    Activity(id: UUID(), title: "Testing2", description: "This is a description2", completions: 2),
    Activity(id: UUID(), title: "Testing3", description: "This is a description3", completions: 3),
    Activity(id: UUID(), title: "Testing4", description: "This is a description4", completions: 4),
  ]
}


