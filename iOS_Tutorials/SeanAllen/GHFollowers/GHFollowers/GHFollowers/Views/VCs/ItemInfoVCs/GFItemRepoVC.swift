//
//  GFItemRepoVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/24/22.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
  func didTapGitHubProfile(for user: User)
}

class GFItemRepoVC: GFItemInfoVC {
  
  weak var delegate: GFRepoItemVCDelegate!

  init(user: User, delegate: GFRepoItemVCDelegate) {
    super.init(user: user)
    self.delegate = delegate
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
    actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
  }
  
  override func actionButtonTapped() {
    delegate.didTapGitHubProfile(for: user)
  }
}
