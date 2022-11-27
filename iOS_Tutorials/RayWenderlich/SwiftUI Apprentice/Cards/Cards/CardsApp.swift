  //
  //  CardsApp.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/6/22.
  //

import SwiftUI

@main
struct CardsApp: App {
  @StateObject var store = CardStore(defaultData: true)
  @StateObject var viewState = ViewState()
  
  var body: some Scene {
    WindowGroup {
      CardsView()
        .environmentObject(viewState)
        .environmentObject(store)
    }
  }
}
