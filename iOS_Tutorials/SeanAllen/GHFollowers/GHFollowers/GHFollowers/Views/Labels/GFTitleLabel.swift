//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/19/22.
//

import UIKit

class GFTitleLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
  }
  
  private func configure() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    adjustsFontForContentSizeCategory = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}
