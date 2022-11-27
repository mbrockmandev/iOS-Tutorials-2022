  //
  //  ContentView.swift
  //  Moonshot
  //
  //  Created by Michael Brockman on 10/15/22.
  //

import SwiftUI

struct ContentView: View {
//  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
//  let missions: [Mission] = Bundle.main.decode("missions.json")
  
  
  @State private var astronauts: [String: Astronaut] = [:]
  @State private var missions: [Mission] = []
  
  @State private var showGrid: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        Group {
          if showGrid {
            MissionGridView(astronauts: astronauts, missions: missions)
          } else {
            MissionListView(astronauts: astronauts, missions: missions)
          }
        }
        .navigationTitle("NASA Missions")
        .toolbar {
          ToolbarItem {
            Button("Switch Views") {
              showGrid.toggle()
            }
          }
        }
      }
      .preferredColorScheme(.dark)
    }
    .onAppear {
      loadData()
    }
    
  }
  
  func loadData() {
    let path = FileManager.getDocumentsDirectory()
    let astronautsURL = path.appendingPathComponent("astronauts.json")
    let missionsURL = path.appendingPathComponent("missions.json")
    astronauts = FileManager.decode(astronautsURL)
    missions = FileManager.decode(missionsURL)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct MissionGridView: View {
  let astronauts: [String: Astronaut]
  let missions: [Mission]
  let columns = [
    GridItem(.adaptive(minimum: 150))
  ]
  
  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(missions) { mission in
        NavigationLink {
          MissionView(mission: mission, astronauts: astronauts)
        } label: {
          VStack {
            Image(mission.image)
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .padding()
            
            VStack {
              Text(mission.displayName)
                .font(.headline)
              Text(mission.formattedLaunchDate)
                .font(.caption)
                .opacity(0.5)
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.lightBackground)
          }
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(.lightBackground))
        }
        
      }
    }
    .navigationTitle("Moonshot")
    .background(.darkBackground)
    .padding([.horizontal, .bottom])
  }
  
  init(astronauts: [String: Astronaut], missions: [Mission]) {
    self.astronauts = astronauts
    self.missions = missions
  }
}

struct MissionListView: View {
  let astronauts: [String: Astronaut]
  let missions: [Mission]
  
  @Environment(\.defaultMinListRowHeight) var minRowHeight
  
  var body: some View {
    
    List {
      ForEach(missions) { mission in
        NavigationLink {
          MissionView(mission: mission, astronauts: astronauts)
        } label: {
          HStack {
            Image(mission.image)
              .resizable()
              .scaledToFit()
              .frame(width: 60, height: 60)
              .padding()
            
            VStack {
              Text(mission.displayName)
                .font(.title2)
              Text(mission.formattedLaunchDate)
                .font(.callout)
                .opacity(0.5)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
          }
          .background(.lightBackground)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(.lightBackground))
          .padding(.leading)
        }
      }
    }
    .frame(minHeight: minRowHeight * 15)
    .listStyle(.plain)
    .listRowBackground(Color.darkBackground)
    .padding([.bottom])
  }
  
  init(astronauts: [String: Astronaut], missions: [Mission]) {
    self.astronauts = astronauts
    self.missions = missions
  }
}
