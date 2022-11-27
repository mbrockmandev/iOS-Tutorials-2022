  //
  //  AstronautView.swift
  //  Moonshot
  //
  //  Created by Michael Brockman on 10/16/22.
  //

import SwiftUI

struct AstronautView: View {
  let astronaut: Astronaut
  
  var body: some View {
    ScrollView {
      LazyVStack {
        Image(astronaut.id)
          .resizable()
          .scaledToFit()
        
        Text(astronaut.description)
          .padding()
      }
    }
    .background(.darkBackground)
    .navigationTitle(astronaut.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct AstronautView_Previews: PreviewProvider {
  static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
  
  static var previews: some View {
    AstronautView(astronaut: astronauts["aldrin"]!)
      .preferredColorScheme(.dark)
  }
}
