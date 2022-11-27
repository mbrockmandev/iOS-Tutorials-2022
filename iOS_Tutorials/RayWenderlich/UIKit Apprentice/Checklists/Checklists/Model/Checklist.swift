//
//  Checklist.swift
//  Checklists
//
//  Created by Michael Brockman on 9/16/22.
//

import UIKit

class Checklist: NSObject, Codable {
  var name: String
  var items = [ChecklistItem]()
  var iconName = ""
  
  init(name: String = "", iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
  }
}
