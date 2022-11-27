//
//  ColorExtensions.swift
//  Cards
//
//  Created by Michael Brockman on 10/7/22.
//

import SwiftUI

extension Color {
  static let colors: [Color] = [
    .green, .red, .blue, .gray, .yellow, .pink, .orange, .purple
  ]
  
  static func random() -> Color {
    colors.randomElement() ?? .black
  }
}
