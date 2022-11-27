  //
  //  ContentView.swift
  //  HabitTracker
  //
  //  Created by Michael Brockman on 10/18/22.
  //

import SwiftUI

struct ContentView: View {
  @StateObject var activities = ActivityList()
  @State private var showAddPage = false
  
  var body: some View {
    NavigationView {
      VStack {
        List(activities.list, id: \.self) { activity in
          NavigationLink {
            DetailView(activities: activities)
          } label: {
            HStack {
              Text(activity.title)
              Spacer()
              Text(activity.description)
            }
          }
        }
        .onChange(of: activities.list[activities.list.count - 1]) { newValue in
//          self.activities.list.append(newValue)
//          Activity(id: UUID(), title: newValue.list[0].title, description: newValue.list[0].description, completions: 0)
          try? self.activities.saveData()
          print(">>> Saving... from content view")
        }
      }
      .navigationTitle("Activities!")
      .toolbar {
        Button {
          showAddPage = true
        } label: {
          Text("Add")
        }
        .sheet(isPresented: $showAddPage) {
          AddView(activities: activities)
        }
      }
    }
    .onAppear {
      try? activities.loadData()
    }
  }
  
}

  //extension Binding {
  //  func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
  //    Binding { //get:
  //      self.wrappedValue
  //    } set: { newValue in
  //      self.wrappedValue = newValue
  //      handler(newValue)
  //    }
  //  }
  //}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.dark)
    
  }
}
