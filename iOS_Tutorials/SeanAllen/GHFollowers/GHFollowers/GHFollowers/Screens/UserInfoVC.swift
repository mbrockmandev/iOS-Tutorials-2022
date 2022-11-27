//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/22/22.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
  func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
  
  let scrollView  = UIScrollView()
  let contentView = UIView()
  
  let headerView  = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel   = GFBodyLabel(textAlignment: .center)
  var itemViews:    [UIView] = []
  
  var username:      String!
  weak var delegate: UserInfoVCDelegate!
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureUI()
    getUserInfo()
    configureScrollView()
  }
  
  //MARK: - Custom Methods
  func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.pinToEdges(of: view)
    contentView.pinToEdges(of: scrollView)
    
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 600),
    ])
  }
  
  
  func configureUI() {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
    
    itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
    for itemView in itemViews {
      contentView.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.padding),
        itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.padding),
      ])
    }
  
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: K.itemHeight + 40),
      
      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: K.padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: K.itemHeight),
        
      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: K.padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: K.itemHeight),
      
      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: K.padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
  
  
  func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
  
  func getUserInfo() {
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        configureUIElements(with: user)
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something weng wrong!", message: gfError.rawValue, buttonTitle: "OK")
        } else {
          presentDefaultError()
        }
      }
    }
  }
  
  func configureUIElements(with user: User) {
    self.add(childVC: GFItemRepoVC(user: user, delegate: self), to: self.itemViewOne)
    self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
    self.dateLabel.text = "Profile Created: " + user.createdAt.convertToMonthYearFormat()
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}

extension UserInfoVC: GFRepoItemVCDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else {
      DispatchQueue.main.async {
        self.presentGFAlert(title: "Invalid URL", message: "URL attached to this user is invalid.", buttonTitle: "OK")
      }
      return
    }
    presentSafariVC(with: url)
  }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
  func didTapGetFollowers(for user: User) {
    guard user.followers > 0 else {
      DispatchQueue.main.async {
        self.presentGFAlert(title: "No Followers", message: "This user has no followers.", buttonTitle: "OK")
      }
      return
    }
    delegate.didRequestFollowers(for: user.login)
    dismissVC()
  }
}


