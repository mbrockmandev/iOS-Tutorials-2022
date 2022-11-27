  //
  //  ContentView.swift
  //  SwiftUITutorial
  //
  //  Created by Michael Brockman on 8/28/22.
  //

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "swift")
        .resizable()
        .padding(.all)
        .frame(width: 100.0, height: 100.0)
        .background(Color.orange)
      Text("Hello, world!")
        .kerning(5.0)
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        .padding()
      
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
