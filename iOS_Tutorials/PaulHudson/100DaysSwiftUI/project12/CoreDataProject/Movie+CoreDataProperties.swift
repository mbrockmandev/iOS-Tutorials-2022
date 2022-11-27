//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Michael Brockman on 10/22/22.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
  //could add: public var wrappedTitle: String { title ?? "Unknown Title" }
    @NSManaged public var director: String?
    @NSManaged public var year: Int16

}

extension Movie : Identifiable {

}
