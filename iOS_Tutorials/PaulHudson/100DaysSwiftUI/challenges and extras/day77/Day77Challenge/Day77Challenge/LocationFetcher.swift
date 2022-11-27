//
//  LocationFetcher.swift
//  Day77Challenge
//
//  Created by Michael Brockman on 11/6/22.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
  let manager = CLLocationManager()
  var lastKnownLocation: CLLocationCoordinate2D?
  
  override init() {
    super.init()
    manager.delegate = self
  }
  
  func start() {
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    lastKnownLocation = locations.first?.coordinate
  }
}
