//
//  String+Ext.swift
//  Project24
//
//  Created by Michael Brockman on 11/23/22.
//

import Foundation

extension String {
  //remove prefix if it exists
  func deletingPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }
  
  //remove suffix if it exists
  func deletingSuffix(_ suffix: String) -> String {
    guard self.hasSuffix(suffix) else { return self }
    return String(self.dropLast(suffix.count))
  }
  //challenge 1 done
  func withPrefix(_ prefix: String) -> String {
    guard !self.contains(prefix) else { return self }
    return String(prefix + self)
  }
  
  var capitalizedFirst: String {
    guard let firstLetter = self.first else { return "" }
    return firstLetter.uppercased() + self.dropFirst()
  }
  //challenge 2 done
  var isNumeric: Bool {
    var hasNumber = false
    for character in self {
      if character.isNumber { hasNumber = true }
    }
    return hasNumber
  }
  
  //challenge 3 done
  var lines: [String] {
    return self.components(separatedBy: "\n")
  }
}
