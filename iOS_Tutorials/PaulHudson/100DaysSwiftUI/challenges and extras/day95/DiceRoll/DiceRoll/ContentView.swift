//
//  ContentView.swift
//  DiceRoll
//
//  Created by Michael Brockman on 11/11/22.
//

import SwiftUI

struct Roll: Codable {
  var dice1: String = ""
  var dice2: String = ""
  var total: Int = 0
}

enum DataManager {
  static let savePath = URL.documentsDirectory.appendingPathComponent("SaveData")
  
  static func loadData() -> [Roll] {
    if let data = try? Data(contentsOf: savePath) {
      if let decoded = try? JSONDecoder().decode([Roll].self, from: data) {
        print(">>> loaddata successful")
        return decoded
      }
    }
    return []
  }
  
  static func saveData(_ rolls: [Roll]) {
    if let data = try? JSONEncoder().encode(rolls) {
      try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
      print(">>> savedata successful")
    }
    
  }
  
  static func printHistory(_ rolls: [Roll]) {
    for roll in rolls {
      print(roll)
    }
  }
  
}

struct ContentView: View {
//  @Environment(\.scenePhase) var scenePhase
  let listOfDice = ["Dice1", "Dice2", "Dice3", "Dice4", "Dice5", "Dice6"]
  
  @State private var dice1 = "Dice1"
  @State private var dice2 = "Dice2"
  @State private var total = 0
  @State private var roll = Roll()
  @State private var history = [Roll]()
  
  var body: some View {
    ZStack {
      Image("table")
        .resizable()
        .ignoresSafeArea()
      HStack {
        Spacer()
        VStack {
          Button("History") {
            DataManager.printHistory(history)
          }
          Spacer()
        }
      }
      .padding()
      
      VStack(spacing: 8) {
        
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundColor(.white)
        Spacer()
        
        HStack {
          Image(dice1)
            .foregroundColor(.white)
          Spacer()
          Image(dice2)
            .foregroundColor(.white)
        }
        
        Spacer()
        
        Button("Roll Dice") {
          withAnimation(.spring()) {
            rollDice()
          }
            
        }
        .buttonStyle(.borderedProminent)
          .foregroundColor(.white)
        
        Spacer()
        
        Text("Total: \(total)")
          .foregroundColor(.white)
      }
      .frame(width: 250, height: 500)
      .padding()
    }
    
    
    .onAppear(perform: loadData)
//    .onChange(of: scenePhase) {
//      saveData()
//    }
  }
  
  
  
  func rollDice() {
    var count = 0
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
      count += 1
      let dice1Num = Int.random(in: 1...6)
      let dice2Num = Int.random(in: 1...6)
      dice1 = "Dice\(dice1Num)"
      dice2 = "Dice\(dice2Num)"
      
      if count > 5 {
        timer.invalidate()
        total = dice1Num + dice2Num
        let newRoll = Roll(dice1: dice1, dice2: dice2, total: total)
        history.append(newRoll)
        saveData()
      }
    }
  }
  
  func loadData() {
    history = DataManager.loadData()
  }
  
  func saveData() {
    DataManager.saveData(history)
  }
  
  func printHistory() {
    
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
