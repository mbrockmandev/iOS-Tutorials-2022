//
//  String+AddText.swift
//  MyLocations
//
//  Created by Michael Brockman on 9/23/22.
//

import Foundation

extension String {
  mutating func add(text: String?, separatedBy separator: String = "") {
    if let text = text {
      if !isEmpty {
        self += separator
      }
      self += text
    }
  }
}
