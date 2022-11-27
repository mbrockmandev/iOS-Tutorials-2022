//
//  Array+Ext.swift
//  Project24
//
//  Created by Michael Brockman on 11/27/22.
//

import Foundation

extension Array where Element: Comparable {
  mutating func remove(item: Element) {
    let index = self.firstIndex { $0 == item }
    if let index {
      self.remove(at: index)
    }
  }
}

//Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

