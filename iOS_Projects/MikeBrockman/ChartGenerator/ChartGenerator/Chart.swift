//
//  Chart.swift
//  ChartGenerator
//
//  Created by Michael Brockman on 10/24/22.
//

import Foundation

class Chart {
  var chiefComplaint: String
  var historyOfPresentIllness: String
  var reviewOfSystems: String
  var mentalStatusExam: String
  
  init(chiefComplaint: String = "", historyOfPresentIllness: String = "", reviewOfSystems: String = "", mentalStatusExam: String = "") {
    self.chiefComplaint = chiefComplaint
    self.historyOfPresentIllness = historyOfPresentIllness
    self.reviewOfSystems = reviewOfSystems
    self.mentalStatusExam = mentalStatusExam
    load()
  }
  
  func save() {
    let defaults = UserDefaults.standard
    defaults.set(chiefComplaint, forKey: "chiefComplaint")
    defaults.set(historyOfPresentIllness, forKey: "historyOfPresentIllness")
    defaults.set(reviewOfSystems, forKey: "reviewOfSystems")
    defaults.set(mentalStatusExam, forKey: "mentalStatusExam")
    
  }
  
  func load() {
    let defaults = UserDefaults.standard
    self.chiefComplaint = defaults.string(forKey: "chiefComplaint") ?? ""
    self.historyOfPresentIllness = defaults.string(forKey: "historyOfPresentIllness") ?? ""
    self.reviewOfSystems = defaults.string(forKey: "reviewOfSystems") ?? ""
    self.mentalStatusExam = defaults.string(forKey: "mentalStatusExam") ?? ""
  }
  
  func reset() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "chiefComplaint")
    defaults.removeObject(forKey: "historyOfPresentIllness")
    defaults.removeObject(forKey: "reviewOfSystems")
    defaults.removeObject(forKey: "mentalStatusExam")
  }
  
}
