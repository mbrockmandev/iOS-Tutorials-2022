  //
  //  MissionView.swift
  //  Moonshot
  //
  //  Created by Michael Brockman on 10/16/22.
  //

import SwiftUI

struct MissionView: View {
  let mission: Mission
  let astronauts: [String: Astronaut]
  
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack {
          Image(mission.image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: geo.size.width * 0.6)
            .padding(.top)

          VStack(alignment: .leading) {
            HorizontalLineView()
            Text("Mission Highlights")
              .font(.title.bold())
              .padding(.bottom, 5)
            Text(mission.description)
            HorizontalLineView()
            Text("Crew")
              .font(.title.bold())
              .padding(.bottom, 5)
          }
          .padding(.horizontal)

          CrewHScrollView(mission: mission, astronauts: astronauts)
        }
        .padding(.bottom)
      }
    }
    .navigationTitle(mission.displayName)
    .navigationBarTitleDisplayMode(.inline)
    .background(.darkBackground)
  }
  
  init(mission: Mission, astronauts: [String: Astronaut]) {
    self.mission = mission
    self.astronauts = astronauts
  }
  
}

//MARK: - previews
struct MissionView_Previews: PreviewProvider {
  static let missions: [Mission] = Bundle.main.decode("missions.json")
  static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
  
  static var previews: some View {
    MissionView(mission: missions[0], astronauts: astronauts)
      .preferredColorScheme(.dark)
  }
}



//MARK: - broken out subviews -- can refactor into other files
struct HorizontalLineView: View {
  var body: some View {
    Rectangle()
      .frame(height: 2)
      .foregroundColor(.lightBackground)
      .padding(.vertical)
  }
}

struct CrewHScrollView: View {
  let mission: Mission
  
  struct CrewMember {
    let role: String
    let astronaut: Astronaut
  }
  
  let crew: [CrewMember]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(crew, id: \.role) { crewMember in
          NavigationLink {
            AstronautView(astronaut: crewMember.astronaut)
          } label: {
            HStack {
              ZStack {
                Image(crewMember.astronaut.id)
                  .resizable()
                  .frame(width: 104, height: 72)
                  .clipShape(Circle())
                  .overlay(Circle().strokeBorder(.white, lineWidth: 1))
                if crewMember.role == "Commander" || crewMember.role == "Command Pilot" {
                  Image(systemName: "star.fill")
                    .offset(x: -35, y: -20)
                    .foregroundColor(.yellow)
                }
              }
              VStack(alignment: .leading) {
                Text(crewMember.astronaut.name)
                  .foregroundColor(.white)
                  .font(.headline)
                Text(crewMember.role)
                  .foregroundColor(.secondary)
              }
            }
            .padding(.horizontal)
          }
        }
      }
    }
  }
  
  init(mission: Mission, astronauts: [String: Astronaut]) {
    self.mission = mission
    self.crew = mission.crew.map { member in
      if let astronaut = astronauts[member.name] {
        return CrewMember(role: member.role, astronaut: astronaut)
      } else {
        fatalError("Missing \(member.name)")
      }
    }
  }
}
