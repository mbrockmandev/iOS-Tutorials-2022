//
//  Note.swift
//  ChartingSwiftUI
//
//  Created by Michael Brockman on 11/30/22.
//

import Foundation

struct Note {
  var chiefComplaint: String = ""
  var historyOfPresentIllness: String = ""
  
  var problems: [Problem.Issue] = []
}

struct Problem: Hashable {
  enum Issue: CaseIterable {
    case depression
    case anxiety
    case PTSD
    case panic
    case mania
  }
  
  enum Severity {
    case remission
    case mild
    case moderate
    case severe
  }
  
  enum Timing {
    case never
    case always
    case intermittent
    case daily
    case weekly
  }
  
  enum Duration {
    case days
    case weeks
    case months
    case years
  }
  
  var severity: Severity
  var timing: Timing
  var duration: Duration
  var associatedFactors: String
  var relievingFactors: String
}
