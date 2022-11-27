  //
  //  ChiefComplaintVC.swift
  //  ChartGenerator
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import UIKit

class ChiefComplaintVC: UIViewController, UITextFieldDelegate {
  var chart = Chart()
  
  
  
//  @IBAction func chiefComplaintEntered(_ sender: UITextField) {
//    chiefComplaint = sender.text ?? "No CC found"
//
//    navigationController?.popViewController(animated: true)
//    if let vc = presentingViewController as? MainTVC {
//      dismiss(animated: true) {
//        print(">>> Working!")
//        vc.chart.chiefComplaint = self.chiefComplaint
//      }
//
//    }
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  @IBAction func textFieldDoneEditing(_ sender: UITextField) {
    print(">>> Should be saving…")
    if let wrappedText = sender.text {
      chart.chiefComplaint += wrappedText
      chart.save()
    }
    //textFieldDidEndEditing(sender as! UITextField)
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    //
  }
  
  
  
}
