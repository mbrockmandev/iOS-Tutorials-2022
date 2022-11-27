  //
  //  AddView.swift
  //  HabitTracker
  //
  //  Created by Michael Brockman on 10/18/22.
  //

import SwiftUI

struct AddView: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var activities: ActivityList
  @State var newTitle: String = ""
  @State var newDescription: String = ""
  
  var body: some View {
    VStack {
      Form {
        Section(header: Text("Title")) {
          TextField("Add a title:", text: $newTitle)
        }
        Section(header: Text("Description")) {
          TextField("Add a description:", text: $newDescription)
        }
        Button {
          activities.list.append(Activity(title: newTitle, description: newDescription))
          dismiss()
        } label: {
          Text("Submit")
        }
    }
  }
}
}

struct AddView_Previews: PreviewProvider {
  static var previews: some View {
    AddView(activities: ActivityList(list: Activity.defaultList))
  }
}
