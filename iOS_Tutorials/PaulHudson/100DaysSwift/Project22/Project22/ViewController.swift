//
//  ViewController.swift
//  Project22
//
//  Created by Michael Brockman on 11/16/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  var locationManager: CLLocationManager?
  var lastDistance: Distance?
  var beaconDetected: Bool = false
  
  enum Distance {
    case far, near, immediate, unknown
  }
  
  @IBOutlet weak var distanceReading: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    
    view.backgroundColor = .gray
    
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedAlways {
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          startScanning()
        }
      }
    }
  }

  func startScanning() {
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "MyBeacon")
    let constraint = CLBeaconIdentityConstraint(uuid: uuid)
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(satisfying: constraint)
      //customized for deprecated code
  }
  
  func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    if let beacon = beacons.first {
      update(distance: beacon.proximity)
    } else {
      update(distance: .unknown)
    }
  }
  
  func update(distance: CLProximity) {
    UIView.animate(withDuration: 0.8) {
      switch distance {
      case .far:
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
        self.lastDistance = .far
      case .near:
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
        self.lastDistance = .near
      case .immediate:
        self.view.backgroundColor = .red
        self.distanceReading.text = "RIGHT HERE"
        self.lastDistance = .immediate
      case .unknown:
        fallthrough
      @unknown default:
        self.view.backgroundColor = .black
        self.distanceReading.text = "UNKNOWN!"
        self.lastDistance = .unknown
      }
    }
  }
  
  
}

