//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/25/22.
//

import UIKit

class FavoriteCell: UITableViewCell {
  
  static let reuseID = "FavoriteCell"
  
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  func set(favorite: Follower) {
    usernameLabel.text = favorite.login
    Task {
      await avatarImageView.downloadImage(fromURL: favorite.avatarUrl)
    }
  }
  
  private func configure() {
    addSubviews([avatarImageView, usernameLabel])
    accessoryType = .disclosureIndicator
    
    NSLayoutConstraint.activate([
      avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      avatarImageView.heightAnchor.constraint(equalToConstant: 60),
      avatarImageView.widthAnchor.constraint(equalToConstant: 60),
      
      usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
      usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      usernameLabel.heightAnchor.constraint(equalToConstant: 40),
    ])
    
    
  }
  
}
