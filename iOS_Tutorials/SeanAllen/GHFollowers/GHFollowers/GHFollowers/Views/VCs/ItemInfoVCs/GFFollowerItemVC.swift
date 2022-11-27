//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/24/22.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
  func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
  
  weak var delegate: GFFollowerItemVCDelegate!

  init(user: User, delegate: GFFollowerItemVCDelegate) {
    super.init(user: user)
    self.delegate = delegate
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
    itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
    actionButton.set(color: .systemGreen, title: "Git Followers", systemImageName: "person.3")
  }

  override func actionButtonTapped() {
    delegate.didTapGetFollowers(for: user)
  }

}
