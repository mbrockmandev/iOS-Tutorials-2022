//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Michael Brockman on 10/18/22.
//

import SwiftUI

struct ContentView: View {
  @StateObject var orders = WrapperClass()
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("Select your cake type", selection: $orders.order.type) {
            ForEach(Order.types.indices) {
              Text(Order.types[$0])
            }
          }
          Stepper("Number of cakes: \(orders.order.quantity)", value: $orders.order.quantity)
        }//section 1
        
        Section {
          Toggle("Any special requests?", isOn: $orders.order.specialRequestEnabled.animation())
          
          if orders.order.specialRequestEnabled {
            Toggle("Add extra frosting", isOn: $orders.order.extraFrosting)
            Toggle("Add extra sprinkles", isOn: $orders.order.addSprinkles)
          }
        }
        
        Section {
          NavigationLink {
            AddressView(orders: orders)
          } label: {
            Text("Delivery details")
          }
        }
      }
      .navigationTitle("Cupcake Corner")
    }
  }
}





class User: ObservableObject, Codable {
  @Published var name = "Paul Hudson"
  
  enum CodingKeys: CodingKey {
    case name
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
  }
  
}

struct Response: Codable {
  var results: [Result]
}

struct Result: Codable {
  var trackId: Int
  var trackName: String
  var collectionName: String
}

struct ContentView2: View {
  @State private var username = ""
  @State private var email = ""
  
  var disableForm: Bool {
    username.count < 6 || email.count < 5
  }
  
  var body: some View {
    Form {
      Section {
        TextField("Username", text: $username)
        TextField("Email", text: $email)
      }
      
      Section {
        Button("Create Account") {
          print("creating account...")
        }
      }
      .disabled(disableForm)
    }
  }
}

struct ContentView3: View {
  @State private var results = [Result]()
  
    var body: some View {
      
      List(results, id: \.trackId) { item in
        VStack(alignment: .leading) {
          Text(item.trackName)
            .font(.headline)
          Text(item.collectionName)
        }
      }
      .task {
        await loadData()
      }
    }
  
  func loadData() async {
    guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
      print("Invalid URL")
      return }
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
          results = decodedResponse.results
        }
      } catch {
        print("Invalid data")
      }
    }
  
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

