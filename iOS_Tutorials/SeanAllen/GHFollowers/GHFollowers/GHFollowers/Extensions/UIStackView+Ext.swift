//
//  UIStackView+Ext.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/26/22.
//

import UIKit

extension UIStackView {
  
  func addArrangedSubviews(_ subviews: [UIView]) {
    for subview in subviews {
      addArrangedSubview(subview)
    }
  }
  
  func addArrangedSubviews(_ subviews: UIView...) {
    for subview in subviews {
      addArrangedSubview(subview)
    }
  }
}

