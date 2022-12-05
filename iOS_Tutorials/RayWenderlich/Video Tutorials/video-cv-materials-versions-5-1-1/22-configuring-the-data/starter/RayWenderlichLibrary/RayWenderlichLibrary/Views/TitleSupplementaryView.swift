//
//  TitleSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by Michael Brockman on 12/2/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
  static let reuseID = "TitleSupplementaryView"
  
  let textLabel = UILabel()
  
  required init?(coder: NSCoder) { fatalError("init coder should NOT be called") }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  private func configure() {
    addSubview(textLabel)
    textLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let inset: CGFloat = 10
    
    NSLayoutConstraint.activate([
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      textLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
    ])
  }
}
