//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Michael Brockman on 11/12/22.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.dismiss) var dismiss
  @State private var showSettings = true
  @State private var showAnswerView = false
  @State var questions: [Question] = []
  @State var userInput = ""
  @State private var showResult = false
  @State private var result = ""
    
  var body: some View {
    NavigationView {
      Form {
        ForEach(questions) { question in
          NavigationLink {
            Text("Enter the correct answer:")
            TextField(question.questionPrompt, text: $userInput)
              .multilineTextAlignment(.center)
              
            Button("Check answer") {
              checkAnswer(for: question, against: userInput)
            }
            .buttonStyle(.bordered)
          } label: {
            Text(question.questionPrompt)
          }
        }
      }
      .navigationTitle("Times Tables")
    .padding()
    }
    .sheet(isPresented: $showSettings, onDismiss: {
      print(">>> questions: \(questions)")
    }) {
      SheetView(questions: $questions)
    }
    .alert("You got it \(result)", isPresented: $showResult) {
      Button("OK", role: .cancel) {
        //need some way to dismiss the nav link
        
      }
    }
  }
  
  func checkAnswer(for question: Question, against userInput: String) {
    if userInput == question.answer {
      result = "CORRECT!"
    } else {
      result = "INCORRECT!"
    }
    showResult = true
  }
}

struct AnswerView: View {
  @State var question: Question
  
  var body: some View {
    
    TextField(question.questionPrompt, text: $question.userAnswer)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct SheetView: View {
  @Environment(\.dismiss) var dismiss
  let optionsForNumQuestions = [5, 10, 20]
  @State private var num1 = 7
  @State private var num2 = 6
  @State private var numberOfQuestions = 5
  @Binding var questions: [Question]
  
  var body: some View {
    Form {
      
      Section("Pick your desired mutiplication tables") {
        Stepper("X: \(num1)", value: $num1, in: 2...12)
        Stepper("Y: \(num2)", value: $num2, in: 2...12)
      }
      Section("# of questions:") {
        Picker("", selection: $numberOfQuestions) {
          ForEach(optionsForNumQuestions, id: \.self) {
            Text(String($0))
          }
        }
        .pickerStyle(.segmented)
      }
      
      Button("Start Game") {
        questions = generateQuestions(numberOfQuestions)
        dismiss()
        
      }
    }
  }
  
  func generateQuestions(_ total: Int) -> [Question] {
    var resultQuestions = [Question]()
    let randomIntArray1 = [Int](2...num1).shuffled()
    let randomIntArray2 = [Int](2...num2).shuffled()
    var count = 0
    for i in 0..<randomIntArray1.count {
      for j in 0..<randomIntArray2.count {
        let questionPrompt = "\(randomIntArray1[i]) * \(randomIntArray2[j]) = ?"
        let answer = randomIntArray1[0] * randomIntArray2[j]
        let answerPrompt = "\(randomIntArray1[i]) * \(randomIntArray2[j]) = \(answer)"
        count += 1
        if count <= total {
          resultQuestions.append(Question(questionPrompt: questionPrompt, answerPrompt: answerPrompt, answer: String(answer)))
        }
      }
    }
    
    return resultQuestions
  }
}
