//
//  Capital.swift
//  Project16
//
//  Created by Michael Brockman on 10/24/22.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  
  //original had title: String
  init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
    self.title = title
    self.coordinate = coordinate
    self.info = info
  }

}
