//
//  ContentView.swift
//  HWSEdutainment
//
//  Created by Michael Brockman on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    @State private var num1: Int = 1
    @State private var num2: Int = 1
    let questionOptions = ["5", "10", "15"]
    @State private var question = "5"
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 50) {
                HStack {
                    Stepper("X: \(num1)", value: $num1)
                    Stepper("Y: \(num2)", value: $num2)
                }
//                Spacer()
                Picker("Questions", selection: $question) {
                    ForEach(questionOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
                Button("Generate Times Tables!") {
//                    Text(pickQuestions(num1, num2)) -- need code here to present the questions
                }
                
                Spacer()
            }
            .navigationTitle("Multiplication Tables!")
            .padding(15)
        }
        
        
        
    }
    
    func pickQuestions(_ number1: Int, _ number2: Int) -> [String] {
        
        var tableArray: [String] = []
        var newArray: [String] = []
        
        for i in 1...number1 {
            for j in 1...number2 {
                    tableArray.append("\(i) x \(j) = \(i * j)")
            }
        }
        
        switch question {
        case 5: {
            
        }
        case 10: {
            
        }
        case 15: {
            
        }
        default:
            fatalError()
        }
        
        return tableArray
    }

    func selectQuestions() {
        
    }


}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
