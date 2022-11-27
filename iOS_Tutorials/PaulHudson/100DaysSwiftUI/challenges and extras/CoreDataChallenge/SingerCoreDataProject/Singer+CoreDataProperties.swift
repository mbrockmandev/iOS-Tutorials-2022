  //
  //  Singer+CoreDataProperties.swift
  //  SingerCoreDataProject
  //
  //  Created by Michael Brockman on 10/29/22.
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
    firstName ?? "Unknown fname"
  }
  
  var wrappedLastName: String {
    lastName ?? "Unknown lname"
  }
  
}

extension Singer : Identifiable {
  
}
