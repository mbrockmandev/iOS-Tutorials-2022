//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Michael Brockman on 10/19/22.
//

import SwiftUI

struct AddressView: View {
  @ObservedObject var orders: WrapperClass
  
    var body: some View {
      Form {
        Section {
          TextField("Name: ", text: $orders.order.name)
          TextField("Street Address: ", text: $orders.order.streetAddress)
          TextField("City: ", text: $orders.order.city)
          TextField("Zip: ", text: $orders.order.zip)
        }
      }
      
      Section {
        NavigationLink {
          CheckoutView(orders: orders)
        } label: {
          Text("Check out")
        }
        .disabled(!orders.order.hasValidAddress)
      }
      .navigationTitle("Delivery details")
      .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
      AddressView(orders: WrapperClass())
    }
}
