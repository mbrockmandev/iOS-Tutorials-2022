  //
  //  ContentView.swift
  //  SingerCoreDataProject
  //
  //  Created by Michael Brockman on 10/29/22.
  //

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) var moc
  @State private var lastNameFilter = "A"
  @State private var filterType = FilterType.contains
  @State private var sortDescriptors = [SortDescriptor<Singer>]()
  
  var body: some View {
    
    VStack {
      FilteredList(type: filterType, filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
        Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
      }
      
      
      
      VStack(spacing: 8) {
        Button("Add Examples") {
          let taylor = Singer(context: moc)
          taylor.firstName = "Taylor"
          taylor.lastName = "Swift"
          
          let ed = Singer(context: moc)
          ed.firstName = "Ed"
          ed.lastName = "Sheeran"
          
          let adele = Singer(context: moc)
          adele.firstName = "Adele"
          adele.lastName = "Adkins"
          
          try? moc.save()
        }
        
        HStack {
          Button("Show A") {
            lastNameFilter = "A"
          }
          Button("Show S") {
            lastNameFilter = "S"
          }
        }
        
        HStack {
          Button("Begins with") {
            filterType = .beginsWith
          }
          
          Button("Contains") {
            filterType = .contains
          }
        }
        
        
        HStack {
          Button("Sort A-Z") {
            sortDescriptors = [SortDescriptor(\.firstName)]
          }
          
          Button("Sort Z-A") {
            sortDescriptors = [SortDescriptor(\.firstName, order: .reverse)]
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
