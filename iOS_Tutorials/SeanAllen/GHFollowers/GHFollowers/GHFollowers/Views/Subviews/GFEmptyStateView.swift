//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/21/22.
//

import UIKit

class GFEmptyStateView: UIView {
  
  let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
  let logoImageView = UIImageView()
  
  //MARK: - initializers
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS INIT!") }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLogoImageView()
    configureMessageLabel()
  }
  
  convenience init(message: String) {
    self.init(frame: .zero)
    messageLabel.text = message
  }
  
  //MARK: - layout methods
  private func configureLogoImageView() {
    addSubview(logoImageView)
    logoImageView.image = Images.emptyStateLogo
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 140 : 80
    
    NSLayoutConstraint.activate([
      logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoBottomConstant),
      logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
      logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
      logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
    ])
  }
  
  private func configureMessageLabel() {
    addSubview(messageLabel)
    messageLabel.numberOfLines  = 3
    messageLabel.textColor      = .secondaryLabel
    
    let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -50 : -150
    
    NSLayoutConstraint.activate([
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 200),
    ])
  }
  
}
