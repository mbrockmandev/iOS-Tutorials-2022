//
//  UIViewController+Ext.swift
//  ReadMe
//
//  Created by Michael Brockman on 11/29/22.
//

import UIKit

extension DetailViewController {
  func dismissKeyboard() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardByTap))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboardByTap() {
    view.endEditing(true)
  }
}
