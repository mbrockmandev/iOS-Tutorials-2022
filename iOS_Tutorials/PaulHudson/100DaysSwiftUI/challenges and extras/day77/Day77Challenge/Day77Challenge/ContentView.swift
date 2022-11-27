  //
  //  ContentView.swift
  //  Day77Challenge
  //
  //  Created by Michael Brockman on 11/3/22.
  //

import SwiftUI

struct ContentView: View {
    //MARK: - Properties
  @ObservedObject var itemCollection = ItemCollection()
  @State private var name = ""
  @State private var image: UIImage?
  @State private var newImage: UIImage?
  @State private var showEditNameView = false
  @State var showPhotoPickerView = false
  let locationFetcher = LocationFetcher()
  
  let cols = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
    //MARK: - Body
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: cols, alignment: .center) {
          ForEach(itemCollection.items.sorted()) { item in
            NavigationLink {
              DetailView(name: $name, item: item).environmentObject(itemCollection)
            } label: {
              ZStack(alignment: .bottomLeading) {
                item.image?
                  .resizable()
                  .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 150)
                  .cornerRadius(10)
                Text(item.name)
                  .font(.caption)
                  .fontWeight(.bold)
                  .padding(8)
                  .foregroundColor(.white)
                  .shadow(radius: 10)
              }
            }
          }
        }
      }
      .navigationTitle("Photo List")
      .toolbar {
        Button("Add") {
          showPhotoPickerView = true
        }
        .padding([.leading, .bottom])
        .sheet(isPresented: $showPhotoPickerView, onDismiss: loadImage) {
          ImagePicker(image: $newImage)
        }
      }
      .sheet(isPresented: $showEditNameView, onDismiss: saveImage) {
        EditNameView(name: $name)
      }
    }
  }
  
  func loadImage() {
    guard let newImage else { return }
    locationFetcher.start()
    image = newImage
    
//    self.image = image
    showEditNameView = true
    print(">>> IMAGE: \(String(describing: image))")
//    print(">>> LoadImage has run")
  }
  
  func saveImage() {
    guard let image else { return }
    var newItem = Item(name: name)
    newItem.writeImageToDisk(image: image)
    if let location = locationFetcher.lastKnownLocation {
      newItem.setLocation(location: location)
    }
    
    itemCollection.append(newItem)
    name = ""
  }
  
  func getIndex(of item: Item) -> Int {
    if let index = itemCollection.items.firstIndex(of: item) {
      return index
    }
    return 0
  }
}




struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
