  //
  //  ContentView.swift
  //  RockPaperScissorsChallenge
  //
  //  Created by Michael Brockman on 10/28/22.
  //

import SwiftUI

struct ContentView: View {
  //MARK: - properties
  var isGameOver = false
  var numberOfTurns = 0
  @State private var score = 0
  @State private var roundResult = ""
  @State private var cpuMove: String = ""
  @State private var playerMove: String = ""
  @State private var showResultOfRound = false
  @State private var dataModel = DataModel()
  
  var body: some View {
    VStack(spacing: 8) {
      
      Text(dataModel.rightOrWrong == 1 ? "Pick the right answer!" : "Pick the wrong answer!")
        .padding()
      
      HStack {
        Text("CPU Move:")
        Text("\(cpuMove)")
      }
      
      HStack {
        Text("Player Move:")
        Text("\(playerMove)")
      }
      
      HStack {
        Button {
          playerMove = "rock"
          dataModel.calculateResult(for: playerMove)
          showResultOfRound = true
        } label: {
          Text("Rock")
        }
        Button {
          playerMove = "paper"
          dataModel.calculateResult(for: playerMove)
          showResultOfRound = true
        } label: {
          Text("Paper")
        }
        
        Button {
          playerMove = "scissors"
          dataModel.calculateResult(for: playerMove)
          showResultOfRound = true
        } label: {
          Text("Scissors")
        }
      }
      .alert("Round Results: \(dataModel.roundResult)", isPresented: $showResultOfRound) {
        Button("OK", role: .cancel) {
          playerMove = ""
          score = dataModel.score
          //change variables back to default and increment to next round?
        }
      }
      .padding()

      Text("Score: \(score)")
      
    }
    .padding()
    .onAppear {
      dataModel.startRound()
      cpuMove = dataModel.cpuMove
    }
  }


}

class DataModel {
  let choices = ["rock", "paper", "scissors"]

  var isGameOver: Bool
  var numberOfTurns: Int
  var rightOrWrong = 1 //0 = "lose", 1 = "win"
  var cpuChoiceIndex = 0
  var score = 0
  var roundResult = ""

  var cpuMove: String = ""
  var playerMove: String = ""
    
  init(isGameOver: Bool = false, numberOfTurns: Int = 0, rightOrWrong: Int = 1, cpuChoiceIndex: Int = 0, score: Int = 0, roundResult: String = "", cpuMove: String = "", playerMove: String = "") {
    
    self.isGameOver = isGameOver
    self.numberOfTurns = numberOfTurns
    self.rightOrWrong = rightOrWrong
    self.cpuChoiceIndex = cpuChoiceIndex
    self.score = score
    self.roundResult = roundResult
    self.cpuMove = cpuMove
    self.playerMove = playerMove
  }
  
  func startRound() {
    determineCpuChoice()
  }
  
  func determineCpuChoice() {
    rightOrWrong = Int.random(in: 0...1)
    cpuChoiceIndex = Int.random(in: 0...2)
    cpuMove = choices[cpuChoiceIndex]
  }
  
  func calculateResult(for playerMove: String) {
    if rightOrWrong == 0 {
        //that player picked the wrong answer
      if playerMove == "rock" && cpuMove == "scissors" {
        roundResult = "wrong"
        score -= 1
      } else if playerMove == "scissors" && cpuMove == "paper" {
        roundResult = "wrong"
        score -= 1
      } else if playerMove == "paper" && cpuMove == "rock" {
        roundResult = "wrong"
        score -= 1
      } else {
        roundResult = "right"
        score += 1
      }
      
      
    } else if rightOrWrong == 1 {
        //check player picked the right answer
      
      if playerMove == "rock" && cpuMove == "scissors" {
        roundResult = "right"
        score += 1
      } else if playerMove == "scissors" && cpuMove == "paper" {
        roundResult = "right"
        score += 1
      } else if playerMove == "paper" && cpuMove == "rock" {
        roundResult = "right"
        score += 1
      } else {
        roundResult = "wrong"
        score -= 1
      }
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}



/*
 Each turn of the game the app will randomly pick either rock, paper, or scissors.
 Each turn the app will alternate between prompting the player to win or lose.
 The player must then tap the correct move to win or lose the game.
 If they are correct they score a point; otherwise they lose a point.
 The game ends after 10 questions, at which point their score is shown.
 */
