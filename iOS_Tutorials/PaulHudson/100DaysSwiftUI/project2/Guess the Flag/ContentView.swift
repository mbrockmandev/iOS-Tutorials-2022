  //
  //  ContentView.swift
  //  Guess the Flag
  //
  //  Created by Michael Brockman on 7/26/22.
  //

import SwiftUI

struct ContentView: View {
    //state var declarations
  @State private var showingScore = false
  static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
  let labels = [
    "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
    "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
    "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
    "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
    "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
    "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
    "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
    "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
    "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
  ]
  @State private var countries = allCountries.shuffled()
  @State var correctAns = Int.random(in: 0...2)
  @State private var scoreTitle = ""
  @State private var score = 0
  @State private var questionCounter = 1
  @State private var showingResults = false
  
  var body: some View {
    ZStack {
      
      RadialGradient(stops: [
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.45),
        .init(color: Color(red: 0.40, green: 0.1, blue: 0.1), location: 0.3)
      ], center: .top, startRadius: 200, endRadius: 650)
      .ignoresSafeArea()
      
      VStack (spacing: 15) {
        Spacer()
        VStack {
          Text("Guess the flag of")
            .foregroundColor(.white)
            .font(.largeTitle).bold()
          Text(countries[correctAns])
            .foregroundColor(.white)
            .font(.largeTitle).bold()
          
        }
        .padding(.vertical, 20)
        
        
        VStack {
          ForEach(0..<3) { number in
            Button {
              flagTapped(number)
            } label: {
              Image(countries[number])
                .renderingMode(.original)
                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
            }
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .background(.ultraThinMaterial)
          .shadow(radius: 10)
          .cornerRadius(50)
          
        }
        
        .shadow(radius: 15)
        .alert(scoreTitle, isPresented: $showingScore) {
          Button("Continue", action: askQuestion)
        } message: {
          Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $showingResults) {
          Button("Start Again", action: newGame)
        } message: {
          Text("Your final score was \(score).")
        }
        
        Spacer()
        Spacer()
        Text("Score: \(score)")
          .foregroundColor(.white)
          .font(.title.bold())
        Spacer()
        
      }
      .padding()
    }
  }
  
  
  func flagTapped(_ number: Int) {
    if number == correctAns {
      scoreTitle = "Correct"
      score += 1
    } else {
      scoreTitle = "Wrong, that's the flag of \(countries[number])"
      if score > 0 {
        score -= 1
      }
    }
    
    if questionCounter == 8 {
      showingResults = true
    } else {
      showingScore = true
    }
  }
  
  func askQuestion() {
    countries.shuffle()
    correctAns = Int.random(in: 0...2)
    questionCounter += 1
  }
  
  func newGame() {
    questionCounter = 0
    score = 0
    countries = Self.allCountries
    
    askQuestion()
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
