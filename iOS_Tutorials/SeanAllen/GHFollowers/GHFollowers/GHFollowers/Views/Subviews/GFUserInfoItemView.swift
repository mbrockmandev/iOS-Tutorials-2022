//
//  GFUserInfoItem.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/22/22.
//

import UIKit

enum ItemInfoType {
  case repos, gists, followers, following
}

class GFUserInfoItemView: UIView {
  
  let symbolImageView = UIImageView()
  let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
  let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutUI()
  }
    
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  func layoutUI() {
    addSubviews([symbolImageView, titleLabel, countLabel])
    symbolImageView.translatesAutoresizingMaskIntoConstraints = false
    symbolImageView.contentMode = .scaleAspectFill
    symbolImageView.tintColor = .label
    
    NSLayoutConstraint.activate([
      symbolImageView.topAnchor.constraint(equalTo: topAnchor),
      symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      symbolImageView.widthAnchor.constraint(equalToConstant: 20),
      symbolImageView.heightAnchor.constraint(equalToConstant: 20),
      
      titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 18),
      
      countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
      countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      countLabel.heightAnchor.constraint(equalToConstant: 18),
      
    ])
  }
  
  func set(itemInfoType: ItemInfoType, with count: Int) {
    switch itemInfoType {
    case .repos:
      symbolImageView.image = SFSymbols.repos
      titleLabel.text = "Public Repos"
    case .gists:
      symbolImageView.image = SFSymbols.gists
      titleLabel.text = "Public Gists"
    case .followers:
      symbolImageView.image = SFSymbols.followers
      titleLabel.text = "Followers"
    case .following:
      symbolImageView.image = SFSymbols.following
      titleLabel.text = "Following"
    }
    countLabel.text = String(count)
  }
  
}
