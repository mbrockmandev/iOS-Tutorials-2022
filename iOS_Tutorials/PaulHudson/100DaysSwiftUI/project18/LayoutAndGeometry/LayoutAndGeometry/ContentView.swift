//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Michael Brockman on 11/11/22.
//

import SwiftUI


struct ContentView: View {
  let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
  @State private var myOpacity = 1.0
  
  var body: some View {
    GeometryReader { fullView in
      ScrollView(.vertical) {
        ForEach(0..<50) { index in
          GeometryReader { geo in
            Text("Row #\(index) - height: \(geo.frame(in: .global).minY)")
              .font(.title)
              .frame(maxWidth: //challenge 2
                geo.frame(in: .global).minY > 150
                ? geo.frame(in: .global).minY * 1.0
                : fullView.size.width / 2
              )
              .background(
                Color(//challenge 3
                  hue: min(geo.frame(in: .global).minY / fullView.size.height, 1.0),
                  saturation: 1.0,
                  brightness: 1.0))
//                colors[index % 7])
              .opacity( //challenge 1
                geo.frame(in: .global).minY > 200
                ? myOpacity
                : myOpacity * geo.frame(in: .global).minY / 200
              )
                
                
                
              .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
            
          }
          .frame(height: 40)
        }
      }
    }
    
  }
}
//}
//struct OuterView: View {
//  var body: some View {
//    VStack {
//      Text("Top")
//      InnerView()
//        .background(.green)
//      Text("Bottom")
//    }
//
//  }
//
//}
//
//struct InnerView: View {
//  var body: some View {
//    HStack {
//      Text("Left")
//      GeometryReader { geo in
//        Text("Center")
//          .background(.blue)
//          .onTapGesture {
//            print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
//            print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
//            print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
//          }
//      }
//      .background(.orange)
//      Text("Right")
//    }
//  }
//}
//
//struct ContentView: View {
//  var body: some View {
//    OuterView()
//      .background(.red)
//      .coordinateSpace(name: "Custom")
//  }
//}
//
//extension VerticalAlignment {
//  enum MidAccountAndName: AlignmentID {
//    static func defaultValue(in d: ViewDimensions) -> CGFloat {
//      d[.top]
//    }
//  }
//  static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
