  //
  //  ViewController.swift
  //  Project2
  //
  //  Created by Michael Brockman on 8/31/22.
  //

import UserNotifications
import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  @IBOutlet var navTitle: UINavigationItem!
  @IBOutlet weak var highScoreLabel: UILabel!
  var countries = [String]()
  var correctAnswer = 0
  var score = 0
  var questionsAsked = 0
  var highScore = 0
  
  
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
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(displayScore))
    loadScore()
  }
  
  @objc func registerLocal() {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        print(">>> Yay")
      } else {
        print(">>> D'oh")
      }
    }
    
    
    //@objc func scheduleLocal()
    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm"
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
      //    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    
    //func registerCategories()
    center.delegate = self
    
    let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
    let remindLater = UNNotificationAction(identifier: "Remind Later", title: "Remind Me Later", options: .foreground)
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
    
    
    
    
  }
  
  func saveScore() {
    let jsonEncoder = JSONEncoder()
    guard let data = try? jsonEncoder.encode(score) else { return }
    let defaults = UserDefaults.standard
    defaults.set(data, forKey: "score")
  }
  
  func loadScore() {
    let defaults = UserDefaults.standard
    
    if let savedScore = defaults.object(forKey: "score") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
        highScore = try jsonDecoder.decode(Int.self, from: savedScore)
      } catch {
        print("Failed to load score.")
      }
    }
    highScoreLabel.text = "High Score: \(highScore)"
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
    saveScore()
    loadScore()
  }
  
  @IBAction func buttonDown(_ sender: UIButton) {
    
    if let image = sender.imageView {
      UIView.animate(withDuration: 0.5) {
        image.transform = CGAffineTransform(scaleX: 0.3, y: 1)
        image.transform = .identity
      }
    }
    
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


extension ViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
      //extract userInfo dict
    let userInfo = response.notification.request.content.userInfo
    
    
    if let customData = userInfo["customData"] as? String {
      print("Custom data received: \(customData)")
      
      
        //challenge 1: change this code below to have custom alerts based on action sent in
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        let ac = UIAlertController(title: "alertTitle", message: "alertMsg", preferredStyle: .alert)
        let action = UIAlertAction(title: "Title", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
          //make a custom UIAlertController
        print("Default idenfitier")
        
      case "show":
          //make a custom UIAlertController
        
        let ac = UIAlertController(title: "showTitle", message: "showMsg", preferredStyle: .alert)
        let action = UIAlertAction(title: "SHOWTitle", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
        print("Show more information…")
        
      case "remindLater":
          //make a custom UIAlertController
//        scheduleLocal()
        let ac = UIAlertController(title: "reminderTitle", message: "reminderMsg", preferredStyle: .alert)
        let action = UIAlertAction(title: "REMINDERTitle", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
        print("Show more information…")
        
      default:
        break
      }
      
      
        //call completion handler when done
      completionHandler()
    }
  }
}
