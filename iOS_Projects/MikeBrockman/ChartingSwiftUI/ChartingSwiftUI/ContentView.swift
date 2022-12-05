  //
  //  ContentView.swift
  //  ChartingSwiftUI
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import SwiftUI

struct ContentView: View {
  @State private var note = Note()
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Text("CC:")
          TextField("Why is the patient here?", text: $note.chiefComplaint)
        }
        HStack {
          Text("HPI:")
          TextField("", text: $note.historyOfPresentIllness)
        }
        HStack {
          Picker("Problems:", selection: $note.problems) {
            ForEach(Problem.Issue.allCases, id: \.self) { problem in
              Text(String(describing: problem))
            }
          }
          .pickerStyle(.navigationLink)
          
        }
      
      }
      .padding()
    }
    
  }
}

struct ContentViewPreview: PreviewProvider {
  
  static var previews: some View {
    ContentView()
  }
}

