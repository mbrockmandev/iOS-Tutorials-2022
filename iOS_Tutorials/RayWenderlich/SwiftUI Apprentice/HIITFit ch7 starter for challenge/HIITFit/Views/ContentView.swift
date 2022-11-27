  //
  //  ContentView.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 9
  @State private var history = HistoryStore()
  
  var body: some View {
    
    TabView(selection: $selectedTab) {
      WelcomeView(history: history, selectedTab: $selectedTab)
        .tag(9)
      ForEach(0 ..< Exercise.exercises.count) { index in
        ExerciseView(selectedTab: $selectedTab, history: $history, index: index)
          .tag(index)
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

