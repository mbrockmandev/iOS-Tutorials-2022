  //
  //  ContentView.swift
  //  ChartingSwiftUI
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import SwiftUI

struct ContentView: View {
  @State private var chiefComplaint: String
  @State private var historyOfPresentIllness: String
  @State private var reviewOfSystems: String
  @State private var mentalStatusExam: String
  
  var body: some View {
    ZStack {
      VStack {
        TextField("Chief Complaint:", text: $chiefComplaint)
        
        
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundColor(.accentColor)
        Text("Hello, world!")
      }
      .padding()
    }
    
  }
}

//struct ContentView_Previews: PreviewProvider {
//  @State static var chiefComplaint: String = "Depression"
//  @State static var historyOfPresentIllness: String = "MDD"
//  @State static var reviewOfSystems: String = "Headaches, dizziness"
//  @State static var mentalStatusExam: String = "chipper"
//  
//  static var previews: some View {
//    ContentView()
//  }
//}
