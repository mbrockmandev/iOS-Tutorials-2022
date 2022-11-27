//
//  WrapperClass.swift
//  CupcakeCorner
//
//  Created by Michael Brockman on 10/20/22.
//

import Foundation

class WrapperClass: ObservableObject {
  @Published var order: Order
  
  init(order: Order) {
    self.order = order
  }
  
  init() {
    self.order = Order()
  }
}
