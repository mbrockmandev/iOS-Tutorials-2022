//
//  ContentView.swift
//  MultiConverter
//
//  Created by Michael Brockman on 7/26/22.
//

import SwiftUI

struct ContentView: View {
    
    //local variables that update views
    @State private var sourceUnit: Int = 0
    @State private var resultUnit: Int = 0
    @State private var tempValue: Double = 0.0
    let temperatureUnits = ["Celsius", "Farenheit", "Kelvin"]
    @FocusState private var tempIsFocused: Bool
    
    var resultTemp: Double {
        
        var temporaryTemp = 0.0
        var result = 0.0
        
        switch sourceUnit {
        case 0: //celsius
            temporaryTemp = tempValue + 273.15
        case 1: //farenheit
            temporaryTemp = (tempValue - 32) * (5/9) + 273.15
        default: //kelvin
            temporaryTemp = tempValue
        }
        
        switch resultUnit {
        case 0: //celsius
            result = temporaryTemp - 273.15
        case 1: //farenheit
            result = ((temporaryTemp - 273.15) * (9/5) + 32)
        case 2: //kelvin
            result = temporaryTemp
        default:
            result = temporaryTemp
            
        }
        return result
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Starting with ___")
                    Picker("Units:", selection: $sourceUnit) {
                        ForEach(0..<3) {
                            Text("\(temperatureUnits[$0])")
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("And you want ___?")
                    Picker("Units:", selection: $resultUnit) {
                        ForEach(0..<3) {
                            Text("\(temperatureUnits[$0])")
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("What is the temp to be converted?")
                    TextField("Temperature:", value: $tempValue, format: .number).keyboardType(.decimalPad)
                }
                Section {
                    Text("The result is: \(resultTemp)")
                }
                
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        tempIsFocused = false
                    }
                }
            }
            .navigationTitle("Temp Unit Convert")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
