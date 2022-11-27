//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Michael Brockman on 10/22/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
  @StateObject private var dataController = DataController()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
