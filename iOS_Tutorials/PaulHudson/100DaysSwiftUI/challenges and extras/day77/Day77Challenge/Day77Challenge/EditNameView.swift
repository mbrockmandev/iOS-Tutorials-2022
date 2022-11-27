  //
  //  EditNameView.swift
  //  Day77Challenge
  //
  //  Created by Michael Brockman on 11/5/22.
  //

import SwiftUI

struct EditNameView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var itemCollection: ItemCollection
  @Binding var name: String
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section("Rename the Photo") {
            TextField("Name:", text: $name)
          }
        }
        Button("Delete Item") {
            //needs to be updated
          removeItem()
          dismiss()
        }
        
      }
      .toolbar {
        Button("Done") {
          dismiss()
        }
        .padding()
      }
    }
    
  }
  
  func removeItem() {
    let index = itemCollection.items.firstIndex { item in
      item.name == name
    }
    if let index {
      itemCollection.items.remove(at: index)
    }
  }
  
  
}
