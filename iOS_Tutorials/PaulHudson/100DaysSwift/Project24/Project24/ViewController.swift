//
//  ViewController.swift
//  Project24
//
//  Created by Michael Brockman on 11/18/22.
//

import UIKit

class ViewController: UIViewController {
  
  let myView = UIView()
  var myArray = [5,6,7,8,9,5]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.addSubview(myView)
    myView.frame = .init(x: view.frame.width / 2, y: view.frame.height / 2, width: 40, height: 40)
    myView.layer.cornerRadius = 6
    myView.backgroundColor = .systemRed

    NSLayoutConstraint.activate([
      myView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      myView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      myView.heightAnchor.constraint(equalToConstant: 60),
      myView.widthAnchor.constraint(equalToConstant: 60),
    ])

    myView.bounceOut(duration: 10)
    
    5.times {print(">>>Hi there") }
    
    myArray.remove(item: 7)
    print(myArray)
    myArray.remove(item: 5)
    print(myArray)
    
  }


}

