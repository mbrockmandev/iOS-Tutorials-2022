  //
  //  ContentView.swift
  //  PHConverter2
  //
  //  Created by Michael Brockman on 10/15/22.
  //

import SwiftUI

struct ContentView: View {
  
  @State private var sourceUnit: Int = 0
  @State private var unitStr: String = ""
  let distanceUnits: [String] = ["Meter", "Kilometer", "Mile", "Foot"]
  var resultUnit: Double {
    let dblInput = Double(unitStr) ?? 0.0
    
    return dblInput * 2.0 //replace with actual math for conversions
  }
  
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Enter your unit value:", text: $unitStr)
        }
        
        Section {
          Text("Starting with ___")
          Picker("Units:", selection: $sourceUnit) {
            ForEach(0 ..< distanceUnits.count) {
              Text("\(distanceUnits[$0])")
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        Section {
          Text("\(resultUnit)")
        }
      }
      .navigationTitle("Unit Converter")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView()
  }
}
