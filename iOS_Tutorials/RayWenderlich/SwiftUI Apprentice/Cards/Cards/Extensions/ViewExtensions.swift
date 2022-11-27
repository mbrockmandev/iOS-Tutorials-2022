//
//  ViewExtensions.swift
//  Cards
//
//  Created by Michael Brockman on 10/7/22.
//

import SwiftUI

extension View {
  func resizableView(transform: Binding<Transform>) -> some View {
    return modifier(ResizableView(transform: transform))
  }
}
