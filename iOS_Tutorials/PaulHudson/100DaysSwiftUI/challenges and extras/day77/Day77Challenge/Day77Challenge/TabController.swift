//
//  TabController.swift
//  Day77Challenge
//
//  Created by Michael Brockman on 11/4/22.
//

import Foundation

enum Tab {
  case detail
  case addPhoto
  case list
}

class TabController: ObservableObject {
  @Published var activeTab = Tab.list
  
  func open(_ tab: Tab) {
    activeTab = tab
  }
}
