  //
  //  ImageExtension.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

extension Image {
  func resizedToFill(width: CGFloat, height: CGFloat) -> some View {
    return self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: width, height: height)
  }
}
