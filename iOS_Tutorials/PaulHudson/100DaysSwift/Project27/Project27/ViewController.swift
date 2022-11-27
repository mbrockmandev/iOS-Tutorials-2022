//
//  ViewController.swift
//  Project27
//
//  Created by Michael Brockman on 11/27/22.
//

import UIKit

class ViewController: UIViewController {
  
  var currentDrawType = 0
  let num = 256

  @IBOutlet weak var imageView: UIImageView!
  
  @IBAction func redrawTapped(_ sender: UIButton) {
    currentDrawType += 1
    
    if currentDrawType > 5 {
      currentDrawType = 0
    }
    
    switch currentDrawType {
    case 0:
      drawRectangle()
      
    case 1:
      drawCircle()
      
    default:
      break
    }
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    drawRectangle()
  }
  
  func drawRectangle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: num, height: num))
    
    let img = renderer.image { context in
      let rectangle = CGRect(x: 5, y: 5, width: num, height: num)
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
      
      context.cgContext.addRect(rectangle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawCircle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: num, height: num))
    
    let img = renderer.image { context in
      let rectangle = CGRect(x: 5, y: 5, width: num, height: num)
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
      
      context.cgContext.addEllipse(in: rectangle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
}
