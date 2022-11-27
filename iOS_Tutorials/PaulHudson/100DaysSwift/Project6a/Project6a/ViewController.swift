  //
  //  ViewController.swift
  //  Project2
  //
  //  Created by Michael Brockman on 8/31/22.
  //

import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  @IBOutlet var navTitle: UINavigationItem!
  var countries = [String]()
  var correctAnswer = 0
  var score = 0
  var questionsAsked = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    askQuestion()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(displayScore))
    
    
  }
  
  func askQuestion(action: UIAlertAction! = nil) {
    if questionsAsked == 10 {
      presentResults()
      askQuestion()
    } else {
      questionsAsked += 1
      countries.shuffle()
      button1.setImage(UIImage(named: countries[0]), for: .normal)
      button2.setImage(UIImage(named: countries[1]), for: .normal)
      button3.setImage(UIImage(named: countries[2]), for: .normal)
      correctAnswer = Int.random(in: 0...2)
      navTitle.title = "Score: \(score)\t\t\(countries[correctAnswer].uppercased())\t\tRound: \(questionsAsked)"
    }
  }
  
  func presentResults(action: UIAlertAction! = nil) {
    questionsAsked = 0
    score = 0
    let ac = UIAlertController(title: title, message: "Your score was \(score) across 10 rounds.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Continue", style: .default))
    present(ac, animated: true)
  }
  
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String
    
    if sender.tag == correctAnswer {
      title = "Right! That is the flag of \(countries[sender.tag].uppercased())"
      score += 1
    } else {
      title = "Wrong! That is the flag of \(countries[sender.tag].uppercased())"
      score -= 1
    }
    
    let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    present(ac, animated: true)
                               
  }
  
  @objc func displayScore() {
    let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
}


