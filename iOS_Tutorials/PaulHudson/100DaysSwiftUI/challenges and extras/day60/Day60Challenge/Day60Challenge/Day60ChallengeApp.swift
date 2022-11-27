  //
  //  Day60ChallengeApp.swift
  //  Day60Challenge
  //
  //  Created by Michael Brockman on 10/29/22.
  //

import SwiftUI

@main
struct Day60ChallengeApp: App {
  @StateObject private var userStore = UserStore()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(userStore)
    }
  }
}
