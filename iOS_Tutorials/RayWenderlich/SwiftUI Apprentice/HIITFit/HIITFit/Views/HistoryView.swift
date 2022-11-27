  //
  //  HistoryView.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/3/22.
  //

import SwiftUI

struct HistoryView: View {
  
  @EnvironmentObject var history: HistoryStore
  
  @Binding var showHistory: Bool
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Button {
        showHistory.toggle()
      } label: {
        Image(systemName: "xmark.circle")
      }
      .font(.title)
      .padding(.trailing)
      VStack {
        Text("History")
          .font(.title)
          .padding()
        Form {
          ForEach(history.exerciseDays) { day in
            Section {
              ForEach(day.exercises, id: \.self) { exercise in
                Text(exercise)
              }
            } header: {
              Text(day.date.formatted(as: "MMM d"))
                .font(.headline)
            }
          }
        }
      }
    }
  }
}


struct DateView: View {
  let date: Date
  
  var body: some View {
    
    Text(date.formatted(as: "MMM d"))
  }
  
  init(date: Date = Date()) {
    self.date = date
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView(showHistory: .constant(true))
      .environmentObject(HistoryStore())
  }
  
}
