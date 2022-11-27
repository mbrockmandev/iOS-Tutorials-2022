  //
  //  ScrollViewExample.swift
  //  Moonshot
  //
  //  Created by Michael Brockman on 10/16/22.
  //

import SwiftUI

struct MoonshotExampleContent: View {
  var body: some View {
    NavigationView {
      List(0..<100) { row in
        NavigationLink {
          Text("Detail View")
        } label: {
          Text("Hello")
            .padding()
        }
      }
      .navigationTitle("SwiftUI")
    }
  }
}

struct ButtonView: View {
  var body: some View {
    Button("Decode JSON") {
      let input = """
      {
        "name": "Taylor Swift",
        "address": {
          "street": "555, Taylor Swift Avenue",
          "city": "Nashville"
        }
      }
"""
    }
  }
}

struct ScrollViewExample_Previews: PreviewProvider {
  static var previews: some View {
    MoonshotExampleContent()
  }
}
