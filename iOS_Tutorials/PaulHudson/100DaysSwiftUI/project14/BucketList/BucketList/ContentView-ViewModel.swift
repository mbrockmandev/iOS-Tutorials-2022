  //
  //  ContentView-ViewModel.swift
  //  BucketList
  //
  //  Created by Michael Brockman on 11/2/22.
  //

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
  @MainActor class ViewModel: ObservableObject {
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
    @Published private(set) var locations: [Location]
    @Published var selectedPlace: Location?
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @Published var isUnlocked = false
    @Published var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationError = false
    
    init() {
      do {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
      } catch {
        locations = []
      }
    }
    
    func addLocation() {
      let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
      locations.append(newLocation)
      save()
    }
    
    func update(location: Location) {
      guard let selectedPlace else { return }
      if let index = locations.firstIndex(of: selectedPlace) {
        locations[index] = location
      }
      save()
    }
    
    func save() {
      do {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: savePath, options: [.atomic, .completeFileProtection])
      } catch {
        print("Unable to save data.")
      }
    }
    
    func authenticate() {
      let context = LAContext()
      var error: NSError?
      
      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to unlock your places."
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
          if success {
            Task { @MainActor in
              self.isUnlocked = true
            }
          } else {
            Task { @MainActor in
              self.authenticationError = "There was a problem authenaticating. Please try again."
              self.isShowingAuthenticationError = true
            }
          }
        }
      } else {
        authenticationError = "Sorry, your device does not support biometrics."
        isShowingAuthenticationError = true
      }
    }
  }
}
