  //
  //  DataController.swift
  //  Bookworm
  //
  //  Created by Paul Hudson on 23/11/2021.
  //

import CoreData
import Foundation

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "SingerCoreDataProject")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
        return
      }
      
      self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
  }
}