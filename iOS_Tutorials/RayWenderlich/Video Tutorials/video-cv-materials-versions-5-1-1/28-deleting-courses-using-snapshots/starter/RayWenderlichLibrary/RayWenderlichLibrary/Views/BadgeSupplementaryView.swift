//
//  BadgeSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by Michael Brockman on 12/3/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

class BadgeSupplementaryView: UICollectionReusableView {
  static let reuseIdentifier = "BadgeSupplementaryView"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("coder init not implemented")
  }
  
  private func configure() {
    backgroundColor = UIColor(named: "rw-green")
    let radius = bounds.width / 2.0
    layer.cornerRadius = radius
  }
}
