  //
  //  BookwormApp.swift
  //  Bookworm
  //
  //  Created by Michael Brockman on 10/20/22.
  //

import SwiftUI

@main
struct BookwormApp: App {
  @StateObject private var dataController = DataController()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
  }
}
