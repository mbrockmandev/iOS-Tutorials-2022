  //
  //  HIITFitApp.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

@main
struct HIITFitApp: App {
  @State private var showAlert = false
  @StateObject private var historyStore: HistoryStore
  
  init() {
    let historyStore: HistoryStore
    do {
      historyStore = try HistoryStore(withChecking: true)
    } catch {
      showAlert = true
      print("Could not load history data")
      historyStore = HistoryStore()
    }
    _historyStore = StateObject(wrappedValue: historyStore)
  }
  
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(historyStore)
        .onAppear {
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("History"),
                message: Text(
                """
                Unfortunately we can't load your past history.
                Email support:
                support@thisApp.com
                """
                ))
        }
    }
  }
}


