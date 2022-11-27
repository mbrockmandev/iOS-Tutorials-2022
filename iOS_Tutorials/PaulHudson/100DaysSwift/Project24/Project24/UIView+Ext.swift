//
//  UIView+Ext.swift
//  Project24
//
//  Created by Michael Brockman on 11/27/22.
//

import UIKit

extension UIView {
  func bounceOut(duration: TimeInterval) {
    Self.animate(withDuration: duration) { [unowned self] in
      self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    }
  }
}

