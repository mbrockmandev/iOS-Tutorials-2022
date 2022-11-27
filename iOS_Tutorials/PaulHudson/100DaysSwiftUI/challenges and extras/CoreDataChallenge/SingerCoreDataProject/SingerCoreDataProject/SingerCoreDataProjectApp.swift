//
//  SingerCoreDataProjectApp.swift
//  SingerCoreDataProject
//
//  Created by Michael Brockman on 10/29/22.
//

import SwiftUI

@main
struct SingerCoreDataProjectApp: App {
  @StateObject private var dataController = DataController()
  
    var body: some Scene {
      WindowGroup {
            ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
