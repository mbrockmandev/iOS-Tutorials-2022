//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/20/22.
//

import UIKit

class GFAvatarImageView: UIImageView {
  
  let cache = NetworkManager.shared.cache
  let placeholderImage = Images.placeholder
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10
    clipsToBounds = true
    image = placeholderImage
  }
  
  func downloadImage(fromURL url: String) async {
    //seans version: (also he does not use async in function declaration
    //Task { image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage }
    if let image = await NetworkManager.shared.downloadImage(from: url) {
      self.image = image
    } else {
      self.image = placeholderImage
    }
  }
  
}
