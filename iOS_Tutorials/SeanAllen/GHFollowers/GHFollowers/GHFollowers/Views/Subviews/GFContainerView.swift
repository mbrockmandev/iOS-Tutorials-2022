//
//  GFContainerView.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/19/22.
//

import UIKit

class GFContainerView: UIView {

  //MARK: - inits
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - custom methods
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground
    layer.cornerRadius = 16
    layer.borderWidth = 2
    layer.borderColor = UIColor.white.cgColor

  }
}
