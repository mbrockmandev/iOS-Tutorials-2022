//
//  InfoView.swift
//  BrockmanCard
//
//  Created by Michael Brockman on 8/15/22.
//

import SwiftUI

struct InfoView: View {
  let text: String
  let icon: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .foregroundColor(.white)
        .frame(maxWidth: 350, maxHeight: 50)
      HStack {
        Image(systemName: icon)
          .foregroundColor(.green)
        Text(text)
      }
    }
  }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "937-581-4652", icon: "phone.fill")
        .previewLayout(.sizeThatFits)
    }
}
