  //
  //  ColorsDetailVC.swift
  //  RandomColorsApp
  //
  //  Created by Michael Brockman on 8/26/22.
  //

import UIKit

class ColorsDetailVC: UIViewController {
  
  var color: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = color ?? .blue
  }
  
  
  
  
}
