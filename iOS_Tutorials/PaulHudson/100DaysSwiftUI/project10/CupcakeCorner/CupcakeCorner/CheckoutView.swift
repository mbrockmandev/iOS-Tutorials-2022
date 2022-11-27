  //
  //  CheckoutView.swift
  //  CupcakeCorner
  //
  //  Created by Michael Brockman on 10/19/22.
  //

import SwiftUI

struct CheckoutView: View {
  @ObservedObject var orders: WrapperClass
  @State private var confirmationMessage = ""
  @State private var showingConfirmation = false
  @State private var showNetworkError = false
  @State private var errorMessage = ""
  
  var body: some View {
    ScrollView {
      VStack {
        AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
        .frame(height: 233)
        .accessibilityElement()
        Text("Your total is \(orders.order.cost, format: .currency(code: "USD"))")
          .font(.title)
        Button {
          Task {
            await placeOrder()
          }
        } label: {
          Text("Place Order")
        }
        .padding()
      }
    }
    .navigationTitle("Check out")
    .navigationBarTitleDisplayMode(.inline)
    .alert("Thank you!", isPresented: $showingConfirmation) {
      Button("OK") { }
    } message: {
      Text(confirmationMessage)
    }
    .alert("Error!", isPresented: $showNetworkError) {
      Button("OK") { }
    } message: {
      Text(errorMessage)
    }
  }
  
  func placeOrder() async {
    guard let encoded = try? JSONEncoder().encode(orders.order),
    let url = URL(string: "https://reqres.in/api/cupcakes") else {
      print("Failed to encode order")
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    do {
      let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
      let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
      confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
      showingConfirmation = true
      
    } catch {
      showNetworkError = true
      errorMessage = "There was a network error with your request. Please try again."
    }
  }
}

struct CheckoutView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutView(orders: WrapperClass())
  }
}
