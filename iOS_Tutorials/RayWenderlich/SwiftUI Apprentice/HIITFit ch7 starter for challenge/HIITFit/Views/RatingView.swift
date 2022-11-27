  //
  //  RatingView.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

struct RatingView: View {
  let maximumRating = 5
  let onColor = Color.red
  let offColor = Color.gray
  
  @Binding var rating: Int
  
  var body: some View {
    HStack {
      ForEach(1 ..< maximumRating + 1) { index in
        Image(systemName: "waveform.path.ecg")
          .foregroundColor(
            index > rating ? offColor : onColor)
          .onTapGesture {
            rating = index
          }
      }
    }
    .font(.largeTitle)
  }
}

struct RatingView_Previews: PreviewProvider {
  static var previews: some View {
    
    RatingView(rating: .constant(1))
      .previewLayout(.sizeThatFits)
  }
}
