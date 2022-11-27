  //
  //  ContentView.swift
  //  testingUIBuild
  //
  //  Created by Michael Brockman on 9/27/22.
  //

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack() {
      HStack(alignment: .center, spacing: 8) {
        Image(systemName: "circle.fill")
      }
      VStack(alignment: .leading, spacing: 8) {
        Text("Name")
        Text("Name")
        Text("Name")
        Text("Name")
        Text("Name")
        Text("Name")
        Text("Name")
        Text("Arist Name")
        
        HStack {
          Text("Kind:")
          Spacer()
          Text("Kind Value")
        }
        HStack {
          Text("Genre:")
          Spacer()
          Text("Genre Value")
        }
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
