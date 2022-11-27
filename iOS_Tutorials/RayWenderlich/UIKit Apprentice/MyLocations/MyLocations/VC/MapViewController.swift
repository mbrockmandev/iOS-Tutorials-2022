import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
  //MARK: - Class Properties
  var managedObjectContext: NSManagedObjectContext! {
    didSet {
      NotificationCenter.default.addObserver(
        forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
        object: managedObjectContext,
        //TODO: Change _ to notification variable and use that userInfo dictionary to figure out what has been inserted/deleted/updated -- this is the challenge at the end of ch 29 
        queue: OperationQueue.main) { notification in
        if self.isViewLoaded {
          self.updateLocations()
          
//          if let dictionary = notification.userInfo {
//            print(dictionary[NSInsertedObjectsKey] ?? "No value")
//            print(dictionary[NSUpdatedObjectsKey] ?? "No value")
//            print(dictionary[NSDeletedObjectsKey] ?? "No value")
//          }
        }
      }
    }
  }
  var locations = [Location]()

  //MARK: - IBOutlets
  @IBOutlet var mapView: MKMapView!
  
  
  //MARK: - IBActions
  @IBAction func showUser() {
    let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                    latitudinalMeters: 1000,
                                    longitudinalMeters: 1000)
    mapView.setRegion(mapView.regionThatFits(region), animated: true)
    
  }
  
  @IBAction func showLocations() {
    let theRegion = region(for: locations)
    mapView.setRegion(theRegion, animated: true)
  }
  
  //MARK: - View methods
  override func viewDidLoad() {
    super.viewDidLoad()
    updateLocations()
  }
  
  
  //MARK: - Helper methods
  func updateLocations() {
    mapView.removeAnnotations(locations)
    
    let entity = Location.entity()
    
    let fetchRequest = NSFetchRequest<Location>()
    fetchRequest.entity = entity
    
    locations = try! managedObjectContext.fetch(fetchRequest)
    mapView.addAnnotations(locations)
  }
  
  func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
    let region: MKCoordinateRegion
    
    switch annotations.count {
    case 0:
      region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                  latitudinalMeters: 1000,
                                  longitudinalMeters: 1000)
      
    case 1:
      let annotation = annotations[annotations.count - 1]
      region = MKCoordinateRegion(center: annotation.coordinate,
                                  latitudinalMeters: 1000,
                                  longitudinalMeters: 1000)
      
    default:
      var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
      var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
    
      for annotation in annotations {
        topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
        topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
        bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
        bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
      }
      
      let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                                          longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
      
      let extraSpace = 1.1
      let span = MKCoordinateSpan(
        latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace,
        longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
      
      region = MKCoordinateRegion(center: center, span: span)
    
    }
    return mapView.regionThatFits(region)
  }
  
  @objc func showLocationDetails(_ sender: UIButton) {
    performSegue(withIdentifier: "EditLocation", sender: sender)
  }
  
  //MARK: - navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditLocation" {
      let controller = segue.destination as! LocationDetailsViewController
      controller.managedObjectContext = managedObjectContext
      
      let button = sender as! UIButton
      let location = locations[button.tag]
      controller.locationToEdit = location
    }
  }
  
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Location else { return nil }
    
    let identifier = "Location"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    if annotationView == nil {
      let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      
      markerView.isEnabled = true
      markerView.canShowCallout = true
      markerView.animatesWhenAdded = false
      markerView.markerTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
      
      let rightButton = UIButton(type: .detailDisclosure)
      rightButton.addTarget(self, action: #selector(showLocationDetails(_:)), for: .touchUpInside)
      markerView.rightCalloutAccessoryView = rightButton
      
      annotationView = markerView
    }
    
    if let annotationView = annotationView {
      annotationView.annotation = annotation
      
      let button = annotationView.rightCalloutAccessoryView as! UIButton
      if let index = locations.firstIndex(of: annotation as! Location) {
        button.tag = index
      }
    }
    return annotationView
  }
}
