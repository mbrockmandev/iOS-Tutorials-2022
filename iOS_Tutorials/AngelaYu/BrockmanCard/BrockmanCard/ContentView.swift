  //
  //  ContentView.swift
  //  BrockmanCard
  //
  //  Created by Michael Brockman on 8/6/22.
  //

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Color(red: 0.00, green: 0.82, blue: 0.79)
        .ignoresSafeArea()
      LayoutView()
    }
  }
}



struct LayoutView: View {
  var body: some View {
    VStack(spacing: 10) {
      
      Image("me")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 250, height: 150, alignment: .center)
        .clipShape(Circle())
        .overlay(
          Circle().stroke(Color.white, lineWidth: 5)
        )
      Text("Michael Brockman")
        .font(Font.custom("ShadowsIntoLight", size: 48))
        .bold()
        .foregroundColor(.white)
      Text("iOS Developer")
        .font(Font.custom("Montserrat", size: 20))
        .bold()
        .foregroundColor(.white)
      Divider()
      
      InfoView(text: "+1 (937) 581-4652", icon: "phone.fill")
      InfoView(text: "mbrockmandev@gmail.com", icon: "envelope.fill")
      
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
