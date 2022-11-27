  //
  //  Operators.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/7/22.
  //

import SwiftUI

func + (lhs: CGSize, rhs: CGSize) -> CGSize {
  CGSize(width: lhs.width + rhs.width,
         height: lhs.height + rhs.height)
}

func * (lhs: CGSize, rhs: CGSize) -> CGSize {
  CGSize(width: lhs.width * rhs.width,
         height: lhs.height * rhs.height)
}

func * (lhs: CGSize, rhs: Double) -> CGSize {
  CGSize(width: lhs.width * rhs,
         height: lhs.height * rhs)
}
