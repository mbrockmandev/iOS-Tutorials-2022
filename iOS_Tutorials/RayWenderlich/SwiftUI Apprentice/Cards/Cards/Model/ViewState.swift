//
//  ViewState.swift
//  Cards
//
//  Created by Michael Brockman on 10/6/22.
//

import SwiftUI

class ViewState: ObservableObject {
  var selectedCard: Card?
  @Published var showAllCards = true {
    didSet {
      if showAllCards {
        selectedCard = nil
      }
    }
  }
  
  convenience init(card: Card) {
    self.init()
    showAllCards = false
    selectedCard = card
  }
}
