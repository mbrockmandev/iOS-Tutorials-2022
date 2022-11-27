//
//  ViewController.swift
//  Project21
//
//  Created by Michael Brockman on 10/28/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
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
  }
  
  @objc func scheduleLocal() {
    registerCategories()
    let center = UNUserNotificationCenter.current()
    
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
  }
  
  func registerCategories() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
    let remindLater = UNNotificationAction(identifier: "Remind Later", title: "Remind Me Later", options: .foreground)
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
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
        scheduleLocal()
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
