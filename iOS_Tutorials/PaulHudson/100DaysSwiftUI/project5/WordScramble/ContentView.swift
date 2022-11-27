//
//  ContentView.swift
//  WordScramble
//
//  Created by Michael Brockman on 7/30/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var score: Int {
        return usedWords.count
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .onSubmit(addNewWord)
                        .onAppear(perform: startGame)
                        .alert(errorTitle, isPresented: $showingError) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text(errorMessage)
                        }
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(word), \(word.count)")
                    }
                }
                
                Section {
                    Text("Your Score is: \(score)")
                }
            }
            .navigationTitle(rootWord)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restart Game") {
                        startGame()
                    }
                }
            }
        }
    }
    
    func startGame() {
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let allWords = fileContents.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return
            }
        }
        fatalError("Could not load start.txt")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isSameAsRoot(word: answer) else {
            wordError(title: "Guess is the root word!", message: "Guesses must be different from the root word.")
            return
        }
        
        guard isLongerThanThree(word: answer) else {
            wordError(title: "Guess too short!", message: "Guess must be >= 3 characters!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word Used Already", message: "Be more original")
            return
        }
                
        guard isReal(word: answer) else {
            wordError(title: "Word Not Recognized", message: "Make up something real ya dummy!")
            return
        }
                
        guard isPossible(word: answer) else {
            wordError(title: "Word Not Possible", message: "What are you doing! \(rootWord) is not possible with those letters!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        
    }
    
    func isSameAsRoot(word: String) -> Bool  {
        return (word != rootWord)
    }
    
    func isLongerThanThree(word: String) -> Bool {
        return (word.count >= 3)
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
