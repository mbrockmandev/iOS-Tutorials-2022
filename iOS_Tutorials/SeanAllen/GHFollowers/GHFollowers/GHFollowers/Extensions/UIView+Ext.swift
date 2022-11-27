//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/22/22.
//

import UIKit

extension UIView {
  
  func addSubviews(_ subviews: [UIView]) {
    for subview in subviews {
      addSubview(subview)
    }
  }
  
  func addSubviews(_ subviews: UIView...) {
    for subview in subviews {
      addSubview(subview)
    }
  }
  
  func pinToEdges(of superview: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    ])
  }
}

