//
//  LibraryHeaderView.swift
//  ReadMe
//
//  Created by Michael Brockman on 11/29/22.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
  static let reuseID = "LibraryHeaderView"
  var titleLabel = UILabel()
  var backgroundImageView = UIImageView()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    configureUI()
    
    
  }
  
  func configureUI() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(backgroundImageView)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.layer.zPosition = 1
    backgroundImageView.layer.zPosition = 0
    
    NSLayoutConstraint.activate([
      titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
      backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor),
    ])
    
    titleLabel.font = UIFont.systemFont(ofSize: 24)
    if #available(iOS 15.0, *) {
      titleLabel.textColor = .tintColor
    } else {
      titleLabel.textColor = .red
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("this should not be called. wtf happened.")
  }
  
}
