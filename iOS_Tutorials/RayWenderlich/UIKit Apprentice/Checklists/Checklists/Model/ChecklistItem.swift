//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Michael Brockman on 9/15/22.
//

import Foundation

class ChecklistItem: Equatable, Codable {
  var text: String
  var checked: Bool
  
  init(text: String = "", checked: Bool = false) {
    self.text = text
    self.checked = checked
  }
  
  static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
    lhs.text == rhs.text
  }
}
