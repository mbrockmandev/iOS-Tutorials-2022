  //
  //  ViewController.swift
  //  Project8
  //
  //  Created by Michael Brockman on 9/9/22.
  //
#warning("challenge 3 - Try making the game also deduct points if the player makes an incorrect guess. Think about how you can move to the next level – we can’t use a simple division remainder on the player’s score any more, because they might have lost some points.")
import UIKit

class ViewController: UIViewController {
  
  var cluesLabel: UILabel!
  var answersLabel: UILabel!
  var currentAnswer: UITextField!
  var scoreLabel: UILabel!
  var letterButtons = [UIButton]()
  var activatedButtons = [UIButton]()
  var solutions = [String]()
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  var level = 1
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
    
    configureViews()
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadLevel()
  }
  
  @objc func letterTapped(_ sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else { return }
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    activatedButtons.append(sender)
    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {
      sender.tintColor = .black
      sender.alpha = 0.6
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      sender.isHidden = true
    }
  }
  
  @objc func submitTapped(_ sender: UIButton) {
    guard let answerText = currentAnswer.text else { return }
    
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      activatedButtons.removeAll()
      
      var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
      splitAnswers?[solutionPosition] = answerText
      answersLabel.text = splitAnswers?.joined(separator: "\n")
      
      currentAnswer.text = ""
      score += 1
      
      if score % 7 == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        let lvlUpAction = UIAlertAction(title: "Let's go!", style: .default) { [weak self] _ in
          guard let self = self else { return }
          self.level += 1
          self.solutions.removeAll(keepingCapacity: true)
          self.loadLevel()
          
          for btn in self.letterButtons {
            btn.isHidden = false
          }
        }
        ac.addAction(lvlUpAction)
        present(ac, animated: true)
      }
      
    }
#warning("challenge 2 -- show an alert letting user know they effed up")
  }
  
  @objc func clearTapped(_ sender: UIButton) {
    currentAnswer.text = ""
    for btn in activatedButtons {
      btn.isHidden = false
    }
    activatedButtons.removeAll()
  }
  
  func loadLevel() {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    
    
      if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
        if let levelContents = try? String(contentsOf: levelFileURL) {
          var lines = levelContents.components(separatedBy: "\n")
          lines.shuffle()
          
          for (index, line) in lines.enumerated() {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            clueString += "\(index + 1). \(clue)\n"
            
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            solutionString += "\(solutionWord.count) letters\n"
            self.solutions.append(solutionWord)
            
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
//            print(letterBits)
          }
        }
      }
    
    
    cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
    answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    letterBits.shuffle()
    
    if letterBits.count == letterButtons.count {
      for i in 0 ..< letterButtons.count {
        letterButtons[i].setTitle(letterBits[i], for: .normal)
      }
    }
  }
  
  func levelUp() {
    level += 1
    solutions.removeAll(keepingCapacity: true)
    loadLevel()
    
    for btn in letterButtons {
      btn.isHidden = false
    }
  }
  
    //MARK: configuration
  func configureViews() {
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: 0"
    view.addSubview(scoreLabel)
    
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.font = UIFont.systemFont(ofSize: 24)
    cluesLabel.text = "CLUES"
    cluesLabel.numberOfLines = 0
    view.addSubview(cluesLabel)
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    
    answersLabel = UILabel()
    answersLabel.translatesAutoresizingMaskIntoConstraints = false
    answersLabel.font = UIFont.systemFont(ofSize: 24)
    answersLabel.text = "ANSWERS"
    answersLabel.numberOfLines = 0
    answersLabel.textAlignment = .right
    view.addSubview(answersLabel)
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    
    
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tap letters to guess"
    currentAnswer.textAlignment = .center
    currentAnswer.font = UIFont.systemFont(ofSize: 44)
    currentAnswer.isUserInteractionEnabled = false
    view.addSubview(currentAnswer)
    
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    view.addSubview(submit)
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    
    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    view.addSubview(clear)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    
    let buttonsView = UIView()
    buttonsView.translatesAutoresizingMaskIntoConstraints = false
    buttonsView.layer.borderColor = UIColor.gray.cgColor
    buttonsView.layer.borderWidth = 3
    view.addSubview(buttonsView)
    
    
    NSLayoutConstraint.activate([
      
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
      
      answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
      
      submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submit.heightAnchor.constraint(equalToConstant: 44),
      
      clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
      clear.heightAnchor.constraint(equalToConstant: 44),
      
      buttonsView.widthAnchor.constraint(equalToConstant: 750),
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
      
    ])
    
    let width = 150
    let height = 80
    
    for row in 0..<4 {
      for col in 0..<5 {
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        
          //TODO: need to change WWW to actual values
        //letterButtons[i].setTitle(letterBits[i], for: .normal)
          //                letterButton.setTitle("WWW", for: .normal)
        
        let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
        letterButton.frame = frame
        
        buttonsView.addSubview(letterButton)
        
        letterButtons.append(letterButton)
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
      }
    }
    
  }
  
  
}

