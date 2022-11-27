//
//  ContentView.swift
//  Day60Challenge
//
//  Created by Michael Brockman on 10/29/22.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var userStore: UserStore
  
    var body: some View {
      NavigationView {
        List {
          ForEach(userStore.users) { user in
            NavigationLink {
              //
            } label: {
              Text(user.name)
            }
          }
        }
      }
      .task {
        await userStore.fetchContents()
      }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(UserStore())
    }
}
