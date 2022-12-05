//
//  DataSource.swift
//  RayWenderlichLibrary
//
//  Created by Michael Brockman on 12/2/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

class DataSource {
  static let shared = DataSource()
  
  var tutorials: [TutorialCollection]
  private let decoder = PropertyListDecoder()
  
  init() {
    guard let url = Bundle.main.url(forResource: "Tutorials", withExtension: "plist"),
    let data = try? Data(contentsOf: url),
    let tutorials = try? decoder.decode([TutorialCollection].self, from: data) else {
      self.tutorials = []
      return
    }
    self.tutorials = tutorials
  }
  
}



//TutorialCollection = Section
//tutorial = item
//use tutorial cells
