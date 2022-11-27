  //
  //  ContentView.swift
  //  WeSplit
  //
  //  Created by Michael Brockman on 7/25/22.
  //
import SwiftUI

struct ContentView: View {
  @FocusState private var amountIsFocused: Bool
  @State private var bill = 0.0
  @State private var numPeople = 2
  @State private var tipSelection = 20
  @State private var showPopover = false
  @State private var tipPicked = false
  
  let moneyFormat = Locale.current.currencyCode
  
  let tipPercentages = [0, 5, 10, 15, 20, 25]
  
  var totalPerPerson: Double {
    let numPeople = Double(2 + numPeople) //correct adjustment to calculate
    let tipValue = bill / 100 * Double(tipSelection)
    let grandTotal = Double(bill + tipValue)
    let amountPerPerson = grandTotal / numPeople
    
    return amountPerPerson
  }
  
  var totalBill: Double {
    return totalPerPerson * Double((numPeople + 2))
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Bill", value: $bill, format: .currency(code: Locale.current.currencyCode ?? "USD"))
            .keyboardType(.decimalPad)
            .focused($amountIsFocused)
          Picker("How many guests are there?", selection: $numPeople) {
            ForEach(2 ..< 25) {
              Text("\($0) people")
            }
          }
        }
        Section {

          
          Button {
            showPopover = true
            tipPicked = true
          } label: {

            if tipPicked {
              Text("Tip Amount: \(tipSelection)%")
            } else {
              Text("Pick a tip amount")
            }
          }

          .popover(isPresented: $showPopover) {
            PopoverContent(tipSelection: $tipSelection)
          }
        }
        HStack {
          Text("Total Per Person:")
          Spacer()
          Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
        }
        Section {
          Text(totalBill, format: .currency(code: Locale.current.currencyCode ?? "USD"))
        }
        
        
      }
      .navigationTitle("Split da Tip")
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done") {
            amountIsFocused = false
          }
        }
      }
    }
  }
}

struct PopoverContent: View {
  @Binding var tipSelection: Int
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationView {
      Picker("tip", selection: $tipSelection) {
        ForEach(1..<101, id: \.self) { item in
          Text("\(item)")
        }
      }
      .pickerStyle(WheelPickerStyle())
      .navigationBarItems(trailing: Button("Done", action: {
        presentationMode.wrappedValue.dismiss()
      }))
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
