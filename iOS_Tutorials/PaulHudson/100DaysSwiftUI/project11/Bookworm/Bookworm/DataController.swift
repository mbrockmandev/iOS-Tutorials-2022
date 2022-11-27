//
//  DataController.swift
//  Bookworm
//
//  Created by Michael Brockman on 10/20/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "Bookworm")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
  
}
