//
//  DetailView.swift
//  HabitTracker
//
//  Created by Michael Brockman on 10/18/22.
//

import SwiftUI

struct DetailView: View {
  @ObservedObject var activities: ActivityList
  
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(activities: ActivityList())
    }
}
