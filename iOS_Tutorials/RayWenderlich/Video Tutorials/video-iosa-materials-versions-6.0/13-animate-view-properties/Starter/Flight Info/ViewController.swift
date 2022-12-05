/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ViewController: UIViewController {
  @IBOutlet var background: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNumberLabel: UILabel!
  @IBOutlet var gateNumberLabel: UILabel!
  @IBOutlet var originLabel: UILabel!
  @IBOutlet var destinationLabel: UILabel!
  @IBOutlet var plane: UIImageView!
  
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var statusBanner: UIImageView!

  private let snowView = SnowView( frame: .init(x: -150, y:-100, width: 300, height: 50) )
}

//MARK:- UIViewController
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Add the snow effect layer
    let snowClipView = UIView( frame: view.frame.offsetBy(dx: 0, dy: 50) )
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)

    // Start rotating the flights
    changeFlight(to: .londonToParis, animated: false)
  }
}

private extension ViewController {
  //MARK:- Animations

  func fade(to image: UIImage, showEffects: Bool) {
		//TODO: Create a crossfade animation for the background
    
    let tempView = UIImageView(frame: background.frame)
    tempView.image = image
    tempView.alpha = 0
    tempView.center.y += 20
    tempView.bounds.size.width = background.bounds.width * 1.3
    
    background.superview!.insertSubview(tempView, aboveSubview: background)
    
    UIView.animate(withDuration: 0.5, animations: {
      //fade tempView in
      tempView.alpha = 1
      tempView.center.y -= 20
      tempView.bounds.size = self.background.bounds.size
    }, completion: { _ in
      self.background.image = tempView.image
      tempView.removeFromSuperview()
    })
    
    // Create & Setup temporary view
    // Fade that temporary view in
    // Update background and remove temporary view
    
      //TODO: Create a fade animation for snowView
    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
      self.snowView.alpha = showEffects ? 1 : 0
    }
    
  }
  
  func move(label: UILabel, text: String, offset: CGPoint) {
    //TODO: Animate a label's translation property
//    Create and set up temp label
//    Fade out and translate real label
//    Fade in and translate temp label
//    Update real label and remove temp label
    
    let tempLabel = duplicate(label)
    tempLabel.text = text
    tempLabel.transform = .init(translationX: offset.x, y: offset.y)
    tempLabel.alpha = 0
    view.addSubview(tempLabel)
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
      label.transform = .init(translationX: offset.x, y: offset.y)
      label.alpha = 0
    }

    UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseIn) {
      tempLabel.transform = .identity
      tempLabel.alpha = 1
    } completion: { _ in
      label.text = tempLabel.text
      label.alpha = 1
      label.transform = .identity
      tempLabel.removeFromSuperview()
    }

    
  }
  
  func cubeTransition(label: UILabel, text: String) {
		//TODO: Create a faux rotating cube animation
    let tempLabel = duplicate(label)
    tempLabel.text = text
    let tempLabelOffset = label.frame.size.height / 2
    let scale = CGAffineTransform(scaleX: 1, y: 0.1)
    let translate = CGAffineTransform(translationX: 0, y: tempLabelOffset)
    tempLabel.transform = scale.concatenating(translate)
    label.superview?.addSubview(tempLabel)
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseOut) {
        tempLabel.transform = .identity
        
        label.transform = scale.concatenating(translate.inverted())
      } completion: { _ in
        label.text = text
        label.transform = .identity
        tempLabel.removeFromSuperview()
      }

    
  }
  
  func depart() {
		//TODO: Animate the plane taking off and landing
    // Store the planes center value
    let originalCenter = plane.center
    // Create new keyframe animation
    UIView.animateKeyframes(withDuration: 1.5, delay: 0) { [plane = self.plane] in
      guard let plane else { return }
      
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
        plane.center.x += 80
        plane.center.y -= 10
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
        plane.transform = .init(rotationAngle: -.pi / 8)
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
        plane.center.x += 100
        plane.center.y -= 50
        plane.alpha = 0
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
        plane.transform = .identity
        plane.center = .init(x: 0, y: originalCenter.y)
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
        plane.alpha = 1
        plane.center = originalCenter
      }
    }
  }
  
  func changeSummary(to summaryText: String) {
		//TODO: Animate the summary text
    
    let originalCenter = summary.center
    
    UIView.animateKeyframes(withDuration: 1, delay: 0) { [summary = self.summary] in
      guard let summary else { return }
      
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
        summary.center.y -= 100
        summary.alpha = 0
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45) {
        summary.center.y += 100
        summary.alpha = 1
      }
      
      delay(seconds: 0.5) {
        self.summary.text = summaryText
      }
    }
  }

  func changeFlight(to flight: Flight, animated: Bool = false) {
		// populate the UI with the next flight's data
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber
    
    

    if animated {
      // TODO: Call your animation
      fade(to: UIImage(named: flight.weatherImageName)!, showEffects: flight.showWeatherEffects)
      let offset = CGPoint(x: Int.random(in: -80...80), y: Int.random(in: -80...80))
      move(label: originLabel, text: flight.origin, offset: offset)
      move(label: destinationLabel, text: flight.destination, offset: offset)
      cubeTransition(label: statusLabel, text: flight.status)
      depart()
      changeSummary(to: flight.summary)
    } else {
      background.image = UIImage(named: flight.weatherImageName)
      originLabel.text = flight.origin
      destinationLabel.text = flight.destination
      statusLabel.text = flight.status
      summary.text = flight.summary
    }
    
    // schedule next flight
    delay(seconds: 3) {
      self.changeFlight(
        to: flight.isTakingOff ? .parisToRome : .londonToParis,
        animated: true
      )
    }
  }
  
  //MARK:- utility methods
  func duplicate(_ label: UILabel) -> UILabel {
    let newLabel = UILabel(frame: label.frame)
    newLabel.font = label.font
    newLabel.textAlignment = label.textAlignment
    newLabel.textColor = label.textColor
    newLabel.backgroundColor = label.backgroundColor
    return newLabel
  }
}

private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
