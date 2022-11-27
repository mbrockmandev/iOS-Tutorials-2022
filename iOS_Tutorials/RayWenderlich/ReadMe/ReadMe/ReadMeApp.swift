  //
  //  ReadMeApp.swift
  //  ReadMe
  //
  //  Created by Michael Brockman on 8/23/22.
  //

import SwiftUI

@main
struct ReadMeApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView().environmentObject(Library())
    }
  }
}
