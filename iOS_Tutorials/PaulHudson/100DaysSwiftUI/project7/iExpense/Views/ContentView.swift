  //
  //  ContentView.swift
  //  iExpense
  //
  //  Created by Michael Brockman on 8/3/22.
  //

import SwiftUI

struct ContentView: View {
  @StateObject var expenses = Expenses()
  @State private var showingAddExpense = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(expenses.items) { item in
          HStack {
            VStack {
              Text(item.name)
                .font(.headline)
              Text(item.type)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
          }
          .accessibilityElement()
          .accessibilityValue("\(item.name), \(item.type), \(item.amount)")
        }
        .onDelete(perform: removeItems)
      }
      .navigationBarTitle("iExpense")
      .toolbar {
        Button {
          showingAddExpense = true
        } label: {
          Image(systemName: "plus")
        }
      }
      .sheet(isPresented: $showingAddExpense) {
        AddView(expenses: expenses)
      }
    }
  }
  
  func removeItems(at offsets: IndexSet) {
    expenses.items.remove(atOffsets: offsets)
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
