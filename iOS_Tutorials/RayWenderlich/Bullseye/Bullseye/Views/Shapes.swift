//
//  Shapes.swift
//  Bullseye
//
//  Created by Michael Brockman on 8/9/22.
//

import SwiftUI

struct Shapes: View {
  @State private var wideShapes = true
  
  var body: some View {
    VStack {
      
      if !wideShapes {
        Circle()
          .strokeBorder(Color.blue, lineWidth: 5.0)
          .frame(width: 200, height: 100.0)        
      }
      RoundedRectangle(cornerRadius: 20.0)
        .fill(Color.blue)
        .frame(width: wideShapes ? 200 : 100, height: 100, alignment: .center)
      Capsule()
        .fill(Color.blue)
        .frame(width: wideShapes ? 200 : 100, height: 100, alignment: .center)
      Ellipse()
        .fill(Color.blue)
        .frame(width: wideShapes ? 200 : 100, height: 100, alignment: .center)
      Button("Animate") {
        withAnimation {
          wideShapes.toggle()
        }
      }
      
    }
    .background(Color.green)
  }
}

struct Shapes_Previews: PreviewProvider {
  static var previews: some View {
    Shapes()
  }
}
