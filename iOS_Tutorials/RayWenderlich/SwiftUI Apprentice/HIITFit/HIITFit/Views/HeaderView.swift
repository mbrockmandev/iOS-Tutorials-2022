  //
  //  HeaderView.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

struct HeaderView: View {
  @Binding var selectedTab: Int
  let titleText: String
  
  var body: some View {

    ZStack {
      VStack {
        Text(titleText)
          .font(.largeTitle)
          .foregroundColor(.white)
          .bold()
        HStack {
          ForEach(0 ..< Exercise.exercises.count) { index in
            let fill = index == selectedTab
            ZStack {
              Circle()
                .frame(width: 16, height: 16)
              Circle()
                .frame(width: 32, height: 32)
                .opacity(fill ? 0.5 : 0)
            }
            .onTapGesture {
              selectedTab = index
            }
            .foregroundColor(.white)
          }
        }
        .font(.title2)
      }
    }
  }
}


struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HeaderView(selectedTab: .constant(0), titleText: "Squat")
      HeaderView(selectedTab: .constant(1), titleText: "Step Up")
    }
    .previewLayout(.sizeThatFits)
    
  }
}
