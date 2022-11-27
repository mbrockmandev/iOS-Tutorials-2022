  //
  //  ViewController.swift
  //  Hangman
  //
  //  Created by Michael Brockman on 9/11/22.
  //

import UIKit

class ViewController: UIViewController {
  
  var answer: String = "RHYTHM"
  var remainingLetters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  var usedLetters: String = ""
  var promptWord: String = "______"
  var wrongAnswers: Int = 0
  
  @IBOutlet weak var guessCountLabel: UILabel!
  @IBOutlet weak var correctLettersLabel: UILabel!
  @IBOutlet weak var alphabetLabel: UILabel!
  @IBOutlet weak var usedLettersLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
      //TODO: add functions to configure view and for the logic of the game?
    configureUI()
    getNewAnswer()
  }
  
  @IBAction func userGuessEntered(_ sender: UITextField) {
    guard let guess = sender.text else { return }
    checkAnswer(guess: guess.uppercased())
    sender.text = ""
    configureUI()
    
  }
  
    //MARK: Model Code, struct? new file?
  func checkAnswer(guess: String) {
    let mappedUsedLetters = usedLetters.map { String($0).uppercased() }
    for letter in mappedUsedLetters {
      if letter == guess {
        return
      }
    }
    
    if isValidGuess(guess: guess) {
      
      let mappedAnswer = answer.map { String($0).uppercased() }
      var mappedPrompt = promptWord.map { String($0).uppercased() }
      var mappedAlphabet = alphabetLabel.text!.map { String($0).uppercased() }
      
      
      for (index, char) in mappedAnswer.enumerated() {
        if char == guess {
          mappedPrompt[index] = guess
        }
      }
      if promptWord.count == mappedPrompt.count {
        wrongAnswers += 1
      }
      updatePrompt(with: mappedPrompt)
      
      for (index, char) in mappedAlphabet.enumerated() {
        if char == guess {
          mappedAlphabet[index] = ""
        }
      }
      updateAlphabet(with: mappedAlphabet)
      if !usedLetters.contains(guess) {
        usedLetters += guess
      }
    }
    if wrongAnswers >= 7 {
      let ac = UIAlertController(title: "Start Over", message: "Would you like to play another round?", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(ac, animated: true)
      resetGame()
    }
  }
  
  func isValidGuess(guess: String) -> Bool {
    if Character(guess).isLetter {
      return true
    }
    return false
  }
  
  func updatePrompt(with mappedPrompt: [String]) {
    promptWord = mappedPrompt.joined()
    configureUI()
  }
  
  func updateAlphabet(with mappedAlphabet: [String]) {
    alphabetLabel.text = mappedAlphabet.joined()
  }
  
  
  func resetGame() {
    
    
    remainingLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    usedLetters = ""
    promptWord = "______"
    wrongAnswers = 0
    configureUI()
  }

  func getNewAnswer() {
    guard let url = Bundle.main.url(forResource: "answers", withExtension: "txt") else { return }
    print(url)
    if let data = try? String(contentsOf: url) {
      print(data)
      let answers = data.components(separatedBy: "\n")
      print(answers)
      answer = answers.randomElement() ?? "swifty"
      print("Answer: \(answer)")
    }
  }
  
    //MARK: UI Code
  func configureUI() {
    guessCountLabel.text = "Guesses Remaining: \(7 - wrongAnswers)"
    correctLettersLabel.text = "\(promptWord)"
    alphabetLabel.text = remainingLetters
    usedLettersLabel.text = "Used Letters: \(usedLetters)"
    
  }
  
}


