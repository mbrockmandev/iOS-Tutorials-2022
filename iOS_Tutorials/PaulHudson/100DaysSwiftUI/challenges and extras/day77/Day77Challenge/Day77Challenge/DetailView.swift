//
//  DetailView.swift
//  Day77Challenge
//
//  Created by Michael Brockman on 11/4/22.
//

import SwiftUI
import MapKit

struct Pin: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}


struct DetailView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var itemCollection: ItemCollection
  @State private var showEditNameView = false
  @Binding var name: String
  
  var item: Item
  
  var pins: [Pin] {
    if let location = self.item.location {
      return [Pin(coordinate: location)]
    }
    return [Pin(coordinate: exampleCLLocation)]
  }
  
  var body: some View {
    VStack {
      ZStack(alignment: .bottomLeading) {
        item.image?
          .resizable()
          .scaledToFit()
        
        Text(item.name)
          .font(.largeTitle)
          .padding()
          .foregroundColor(.white)
          .shadow(radius: 5)
        
      }
      if let location = item.location {
        Map(coordinateRegion: .constant(
          MKCoordinateRegion(center: location,
                             span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), annotationItems: pins) { item in
          MapPin(coordinate: item.coordinate)
        }
      }
    }
    .navigationTitle(item.name)
    .toolbar {
      Button("Edit") {
        showEditNameView = true
      }
    }
    .sheet(isPresented: $showEditNameView, onDismiss: saveName) {
      EditNameView(name: $name)
    }
    .onAppear {
//      if !name.isEmpty {
//        item.name = name
//      }
    }
        
  }
  
  func saveName() {
    if let index = itemCollection.items.firstIndex(of: item) {
      itemCollection.items[index].name = name
    }
    
  }
  
  func getIndex() -> Int {
    if let index = itemCollection.items.firstIndex(of: item) {
      return index
    }
    return 0
  }
  
  
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//      DetailView(inputName: .constant(Item(name: "Bob", image: UIImage(systemName: "star.fill"))))
//    }
//}
