//
//  ContentView.swift
//  Dicee
//
//  Created by Michael Brockman on 8/15/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
      ZStack {
        Image("background")
          .resizable()
          .edgesIgnoringSafeArea(.all)
        VStack {
//          Spacer()
          Image("diceeLogo")
          Spacer()
          
          HStack {
            DiceView(n: 1)
            DiceView(n: 1)
          }
          .padding(.horizontal)
          Spacer()
          Button(action: {
            
          }) {
            Text("Roll!")
              .font(.system(size: 50))
              .fontWeight(.heavy)
              .foregroundColor(.white)
              .padding(.horizontal)
          }
          .background(Color.red)
//          Spacer()
        }
       
      }
        
    }
}

struct DiceView: View {
  let n: Int
  var body: some View {
    Image("dice\(n)")
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .padding()
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

