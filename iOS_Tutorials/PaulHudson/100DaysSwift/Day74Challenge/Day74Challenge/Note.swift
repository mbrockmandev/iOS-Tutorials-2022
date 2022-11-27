//
//  Note.swift
//  Day74Challenge
//
//  Created by Michael Brockman on 11/15/22.
//

import Foundation

struct Note: Codable {
  var title: String
  var body: String
  
  static let example = [
    Note(title: "title1", body: "body1"),
    Note(title: "title2", body: "body2"),
    Note(title: "title3", body: "body3"),
  ]
}
