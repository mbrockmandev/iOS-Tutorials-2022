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
      
    case 2:
      drawCheckerboard()
      
    case 3:
      drawRotatedSquares()
      
    case 4:
      drawLines()
    case 5:
      drawImagesAndText()
      
    default:
      break
    }
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    drawSmiley()
  }
  
  func drawRectangle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: num, height: num))
    
    let img = renderer.image { ctx in
      let rectangle = CGRect(x: 0, y: 0, width: num, height: num).insetBy(dx: 5, dy: 5)
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
      ctx.cgContext.setLineWidth(10)
      
      ctx.cgContext.addRect(rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawCircle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: num, height: num))
    
    let img = renderer.image { ctx in
      let rectangle = CGRect(x: 5, y: 5, width: num, height: num).insetBy(dx: 5, dy: 5)
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
      ctx.cgContext.setLineWidth(10)
      
      ctx.cgContext.addEllipse(in: rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawCheckerboard() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      ctx.cgContext.setFillColor(UIColor.white.cgColor)
      
      for row in 0 ..< 8 {
        for col in 0 ..< 8 {
          if (row + col) % 2 == 0 {
            ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
          }
        }
      }
    }
    
    imageView.image = img
  }
  
  func drawRotatedSquares() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      ctx.cgContext.translateBy(x: 256, y: 256)
      
      let rotations = 16
      let amount = Double.pi / Double(rotations)
      
      for _ in 0 ..< rotations {
        ctx.cgContext.rotate(by: CGFloat(amount))
        ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
      }
      
      ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  func drawLines() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      ctx.cgContext.translateBy(x: 256, y: 256)
      
      var first = true
      var length: CGFloat = 256
      
      for _ in 0 ..< 256 {
        ctx.cgContext.rotate(by: .pi / 2)
        
        if first {
          ctx.cgContext.move(to: CGPoint(x: length, y: 50))
          first = false
        } else {
          ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
        }
        
        length *= 0.99
      }
      
      ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  func drawImagesAndText() {
      // 1
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
        // 2
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
        // 3
      let attrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 36),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor(white: 1, alpha: 1)
      ]
      
        // 4
      let string = "The best-laid schemes o'\nmice an' men gang aft agley"
      let attributedString = NSAttributedString(string: string, attributes: attrs)
      
        // 5
      attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
      
        // 5
      let mouse = UIImage(named: "mouse")
      mouse?.draw(at: CGPoint(x: 300, y: 150))
    }
    
      // 6
    imageView.image = img
  }
  
  //challenge 1 - pick an emoji and draw using Core Graphics
  func drawSmiley() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 384, height: 384))
    
    let img = renderer.image { ctx in
      
      let rectangle = CGRect(x: 5, y: 5, width: 384, height: 384).insetBy(dx: 5, dy: 5)
      ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
      ctx.cgContext.setLineWidth(10)
      
      //face
      ctx.cgContext.addEllipse(in: rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
      
      ctx.cgContext.setFillColor(UIColor.black.cgColor)
      
      //eyes
      ctx.cgContext.addEllipse(in: rectangle.insetBy(dx: 160, dy: 160).offsetBy(dx: -60, dy: -60))
      ctx.cgContext.addEllipse(in: rectangle.insetBy(dx: 160, dy: 160).offsetBy(dx: 60, dy: -60))
      ctx.cgContext.drawPath(using: .fillStroke)
      
      //mouth
//      ctx.cgContext.addCurve(to: CGPoint(x: 192, y: 192), control1: CGPoint(x: 60, y: 60), control2: CGPoint(x: 300, y: 300))
//      ctx.cgContext.addEllipse(in: rectangle.insetBy(dx: 60, dy: 160).offsetBy(dx: 0, dy: 60))
//      ctx.cgContext.drawPath(using: .fillStroke)
      
      let center = CGPoint(x: view.bounds.width / 3, y: view.bounds.height / 3)
      let radius = max(view.bounds.width, view.bounds.height)
      let startAngle: CGFloat = 3 * .pi / 4
      let endAngle: CGFloat = .pi / 4
      
      let path = UIBezierPath(
        arcCenter: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: true)
      
      path.addArc(
        withCenter: center,
        radius: radius,
        startAngle: endAngle,
        endAngle: startAngle,
        clockwise: false)
      path.close()
      path.lineWidth = 5
      path.stroke()
      
    }
    
    imageView.image = img
  }
  
}
