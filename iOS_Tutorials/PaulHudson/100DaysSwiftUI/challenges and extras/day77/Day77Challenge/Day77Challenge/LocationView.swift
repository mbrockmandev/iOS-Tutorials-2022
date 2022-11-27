  //
  //  LocationView.swift
  //  Day77Challenge
  //
  //  Created by Michael Brockman on 11/6/22.
  //

import SwiftUI
import MapKit

  //remove examples before final
let exampleCLLocation = CLLocationCoordinate2D(latitude: 50, longitude: 0)
let exampleSpan = MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)

struct LocationView: View {
  let locationFetcher = LocationFetcher()
  
  @State var mapRegion = MKCoordinateRegion(center: exampleCLLocation, span: exampleSpan)
  @State private var locations: [Location] = []
  
  var location: CLLocationCoordinate2D {
    locationFetcher.start()
    if let location = locationFetcher.lastKnownLocation {
      print(">>> real data used")
      return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    print(">>> example data used")
    return CLLocationCoordinate2D(latitude: exampleCLLocation.latitude, longitude: exampleCLLocation.longitude)
  }
  
  var body: some View {
    
    ZStack {
      
      Map(coordinateRegion: $mapRegion)
        .ignoresSafeArea()
      
    }
    
    .onAppear {
      locations.append(Location(id: UUID(), name: "new entry", description: "new desc", latitude: location.latitude, longitude: location.longitude))
    }
        //      locationFetcher.start()
        //
        //      locations.append(Location.example)
        //      getLocation()
    
  }
  
    //  func getLocation() {
    //    let newLocation: Location
    //     if let lastKnownLocation = locationFetcher.lastKnownLocation {
    //      mapRegion = MKCoordinateRegion(center: lastKnownLocation, span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    //       print(">>> actual data used")
    //       newLocation = Location(id: UUID(), name: "new entry", description: "new desc", latitude: lastKnownLocation.latitude, longitude: lastKnownLocation.longitude)
    //
    //     } else {
    //       newLocation = Location.example
    //       print(">>> example data used")
    //     }
    //    locations.append(newLocation)
    //  }
  
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationView()
  }
}
