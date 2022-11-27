  //
  //  DetailVC.swift
  //  Day59
  //
  //  Created by Michael Brockman on 10/23/22.
  //

import UIKit

class DetailVC: UIViewController {
  var detailItem: Country?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
      // Do any additional setup after loading the view.
  }
  
  func configureUI() {
    guard let detailItem else { return }
    //more to come later!
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
