//
//  SuccessView.swift
//  HIITFit
//
//  Created by Michael Brockman on 10/3/22.
//

import SwiftUI

struct SuccessView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @Binding var selectedTab: Int
  
    var body: some View {
      ZStack {
        VStack(spacing: 4) {
          Spacer()
          Image(systemName: "hand.raised.fill")
            .resizedToFill(width: 75, height: 75)
            .foregroundColor(.purple)
            .padding()
          Text("High Five!")
            .font(.largeTitle)
            .fontWeight(.black)
            .bold()
          Text("Good job completing all four exercises!\nRemember tomorrow's another day.\nSo eat well and get some rest.")
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
          
          Spacer()
          Button {
            selectedTab = 9
            presentationMode.wrappedValue.dismiss()
          } label: {
            Text("Continue")
              .padding(.bottom)
          }

        }
      }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
      SuccessView(selectedTab: .constant(3))
    }
}
