  //
  //  ViewController.swift
  //  Project16
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
  
//  var userViewChoice: MKMapConfiguration = MKStandardMapConfiguration()
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let washington = Capital(title: "Washington,_D.C.", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    
    mapView.addAnnotation(london)
    mapView.addAnnotation(oslo)
    mapView.addAnnotation(paris)
    mapView.addAnnotation(rome)
    mapView.addAnnotation(washington)
    
    presentViewChoice()
    
  }
  
  func presentViewChoice() {
    let ac = UIAlertController(title: "View Options", message: "Please choose a view option.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { action in
      self.mapView.preferredConfiguration = MKImageryMapConfiguration()
    }))
    ac.addAction(UIAlertAction(title: "Default", style: .default, handler: { action in
      self.mapView.preferredConfiguration = MKStandardMapConfiguration()
    }))
    present(ac, animated: true)
    
    
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //1
    guard annotation is Capital else { return nil }
    
    //2
    let identifier = "Capital"
    
    //3
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    
    
    if annotationView == nil {
      //4
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true

      //5
      let btn = UIButton(type: .detailDisclosure)
      annotationView?.rightCalloutAccessoryView = btn
//      annotationView?.pinTintColor = UIColor(ciColor: .green)
    } else {
      annotationView?.annotation = annotation
    }
    annotationView?.pinTintColor = UIColor(ciColor: .green)
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let capital = view.annotation as? Capital else { return }
    guard let placeName = capital.title else { return }
//    let placeInfo = capital.info
    
    navigationController?.pushViewController(DetailWebView(place: placeName), animated: true)
    
//    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    present(ac, animated: true)
  }
  
  
}

