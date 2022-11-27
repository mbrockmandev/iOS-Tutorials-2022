  //
  //  ScrollViewExample.swift
  //  Moonshot
  //
  //  Created by Michael Brockman on 10/16/22.
  //

import SwiftUI

struct MoonshotExampleContent: View {
  let layout = [
    GridItem(.adaptive(minimum: 80, maximum: 120)),
    GridItem(.adaptive(minimum: 80, maximum: 120)),
    GridItem(.adaptive(minimum: 80, maximum: 120))
  ]
      
  var body: some View {
    ScrollView(.horizontal) {
      LazyHGrid(rows: layout) {
        ForEach(0..<1000) {
          Text("Item \($0)")
        }
      }
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
      let data = Data(input.utf8)
      let decoder = JSONDecoder()
      if let user = try? decoder.decode(User.self, from: data) {
        print(user.address.street)
      }
    }
  }
}

struct User: Codable {
  let name: String
  let address: Address
}

struct Address: Codable {
  let street: String
  let city: String
}

struct ScrollViewExample_Previews: PreviewProvider {
  static var previews: some View {
    MoonshotExampleContent()
  }
}
