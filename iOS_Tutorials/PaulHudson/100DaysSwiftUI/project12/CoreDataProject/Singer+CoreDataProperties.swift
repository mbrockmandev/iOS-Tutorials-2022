//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Michael Brockman on 10/22/22.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
  
  var wrappedFirstName: String {
    firstName ?? "Uknown"
  }
  
  var wrappedLastName: String {
    lastName ?? "Unknown"
  }

}

