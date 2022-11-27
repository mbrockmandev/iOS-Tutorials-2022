//
//  ContentView.swift
//  BullsEye
//
//  Created by Michael Brockman on 8/7/22.
//

import SwiftUI

struct ContentView: View {
  @State private var answer = Int.random(in: 1...100)
  @State private var sliderValue = 50.0
  @State private var alertIsVisible = false
  @State private var game = Game()
  
  
  var body: some View {
    ZStack {
      BackgroundView(game: $game)
      VStack {
        InstructionsView(game: $game)
          .padding(.bottom, alertIsVisible ? 0 : 100)
        if alertIsVisible {
          PointsView(alertIsVisible: $alertIsVisible, sliderValue: $sliderValue, game: $game)
            .transition(.scale)
        } else {
          HitMeButton(alertIsVisible: $alertIsVisible, sliderValue: $sliderValue, game: $game)
            .transition(.scale)
        }
      }
      if !alertIsVisible {
        SliderView(guess: $sliderValue)
          .transition(.scale)
      }
    }
  }
}

struct InstructionsView: View {
  @Binding var game: Game
  
  var body: some View {
    VStack {
      InstructionText(text: "🎯🎯🎯\nPut the bullseye as close as you can to")
        .padding(.leading, 30.0)
        .padding(.trailing, 30.0)
      BigNumberText(text: "\(game.target)")
    }
  }
}

struct SliderView: View {
  @Binding var guess: Double
  
  var body: some View {
    HStack {
      SliderLabelText(text: "1")
      Slider(value: $guess, in: 1.0...100.0)
      SliderLabelText(text: "100")
    }
    .padding()
  }
}

struct HitMeButton: View {
  @Binding var alertIsVisible: Bool
  @Binding var sliderValue: Double
  @Binding var game: Game
  
  var body: some View {
    
    Button(action: {
      withAnimation {
        self.alertIsVisible = true
      }
    }) {
      Text("Hit Me".uppercased())
        .font(.title3)
        .bold()
    }
    .padding(20.0)
    .background(
      ZStack {
        Color("ButtonColor")
        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
      })
    .foregroundColor(.white)
    .cornerRadius(K.General.roundRectCornerRadius)
    .overlay(
      RoundedRectangle(cornerRadius: K.General.roundRectCornerRadius)
        .strokeBorder(Color.white, lineWidth: K.General.strokeWidth)
    )
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
    ContentView()
      .previewLayout(.fixed(width: 568, height: 320))
    
    ContentView()
      .preferredColorScheme(.dark)
    ContentView()
      .preferredColorScheme(.dark)
      .previewLayout(.fixed(width: 568, height: 320))
  }
}
