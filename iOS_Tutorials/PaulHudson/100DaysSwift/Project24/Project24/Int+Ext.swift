//
//  Int+Ext.swift
//  Project24
//
//  Created by Michael Brockman on 11/27/22.
//

import Foundation

extension Int {
  func times(_ theClosure:() -> Void) {
    guard self > 0 else { return }
    for _ in 1...self {
      theClosure()
    }
  }
}

//Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
