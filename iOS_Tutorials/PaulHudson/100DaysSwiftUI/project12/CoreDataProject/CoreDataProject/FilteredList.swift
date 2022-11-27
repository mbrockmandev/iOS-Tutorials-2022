//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Michael Brockman on 10/22/22.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
  @FetchRequest var fetchRequest: FetchedResults<T>
  
  
  let content: (T) -> Content
  
    var body: some View {
      List(fetchRequest, id: \.self) { item in
        self.content(item)
      }
    }
  
  init(type: FilterType = .contains, filterKey: String, filterValue: String, sortDescriptors: [SortDescriptor<T>] = [], @ViewBuilder content: @escaping (T) -> Content) {
    _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(type.rawValue) %@", filterKey, filterValue))
    self.content = content
  }
  
//  init(type: FilterType = .contains, filterKey: String, filterValue: String, sortDescriptors: [SortDescriptor<T>] = [], @ViewBuilder content: @escaping (T) -> Content) {
//    _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K \(type.rawValue) %@", filterKey, filterValue))
//    self.content = content
//  }
  
}


enum FilterType: String {
  case beginsWith = "BEGINSWITH"
  case contains = "CONTAINS[c]"
}


struct FilteredList_Previews: PreviewProvider {
  
    static var previews: some View {
      FilteredList(filterKey: "lastName", filterValue: "S") { (item: Singer) in
        Text("\(item.wrappedFirstName) \(item.wrappedLastName)")
      }
    }
}

