  //
  //  Countries.swift
  //  Day59
  //
  //  Created by Michael Brockman on 10/23/22.
  //

import Foundation

struct Countries: Codable {
  var results: [Country]
  
  static let offlineList: [Country] = [
    Country.init(name: "Japan"),
    Country.init(name: "Finland"),
    Country.init(name: "Germany"),
    Country.init(name: "Italy"),
    Country.init(name: "France"),
  ]
}
