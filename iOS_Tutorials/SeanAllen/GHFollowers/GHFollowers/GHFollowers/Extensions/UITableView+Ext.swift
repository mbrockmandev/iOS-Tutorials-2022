//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/26/22.
//

import UIKit

extension UITableView {

  func reloadDataOnMainThread() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
  
  func removeExcessCells() {
    tableFooterView  = UIView(frame: .zero)
  }
}
