//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/22/22.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
  
  //MARK: - Properties
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
  let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
  let locationImageView = UIImageView()
  let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
  let bioLabel = GFBodyLabel(textAlignment: .left)
  
  var user: User!
  
  //MARK: - Initializers
  init(user: User) {
    super.init(nibName: nil, bundle: nil)
    self.user = user
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureLayout()
  }
  
  //MARK: - Custom Methods
  func configureUI() {
    Task {
      await avatarImageView.downloadImage(fromURL: user.avatarUrl)
    }
    usernameLabel.text = user.login
    nameLabel.text = user.name ?? ""
    locationLabel.text = user.location ?? "No location"
    bioLabel.text = user.bio ?? "No bio"
    bioLabel.numberOfLines = 3
    locationImageView.image = SFSymbols.locationImage
  }
  
  func configureLayout() {
    view.addSubviews([avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel])
    locationImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: K.padding),
      avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 90),
      avatarImageView.heightAnchor.constraint(equalToConstant: 90),
      
      usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.textImagePadding),
      usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      usernameLabel.heightAnchor.constraint(equalToConstant: 38),

      nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.textImagePadding),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      nameLabel.heightAnchor.constraint(equalToConstant: 20),

      locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
      locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.textImagePadding),
      locationImageView.widthAnchor.constraint(equalToConstant: 20),
      locationImageView.heightAnchor.constraint(equalToConstant: 20),

      locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
      locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
      locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      locationLabel.heightAnchor.constraint(equalToConstant: 20),

      bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: K.textImagePadding),
      bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
      bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bioLabel.heightAnchor.constraint(equalToConstant: 90)
      
    ])
  }
  
  
}
