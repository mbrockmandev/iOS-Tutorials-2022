//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/25/22.
//

import Foundation

extension Date {
  
  func convertToMonthYearFormat() -> String {
    formatted(.dateTime.month().year())
  }
}
