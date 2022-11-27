//
//  Transform.swift
//  Cards
//
//  Created by Michael Brockman on 10/7/22.
//

import SwiftUI

struct Transform {
  var size = CGSize(width: Settings.defaultElementSize.width, height: Settings.defaultElementSize.height)
  var rotation: Angle = .zero
  var offset: CGSize = .zero
}
