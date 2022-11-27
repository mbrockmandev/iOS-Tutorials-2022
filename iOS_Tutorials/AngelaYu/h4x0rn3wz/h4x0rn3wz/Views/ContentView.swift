  //
  //  ContentView.swift
  //  h4x0rn3wz
  //
  //  Created by Michael Brockman on 8/30/22.
  //

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var networkManager = NetworkManager()
  
  var body: some View {
    NavigationView {
      List(networkManager.posts) { post in
        NavigationLink(destination: DetailView(url: post.url)) {
          HStack {
            Text(String(post.points))
            Text(post.title)
          }
          
        }
        
      }
      .navigationBarTitle("h4x0r n3wz")
    }
    .onAppear {
      networkManager.fetchData()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
