//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/24/22.
//  Superclass

import UIKit

class GFItemInfoVC: UIViewController {
  
  let stackView = UIStackView()
  let itemInfoViewOne = GFUserInfoItemView()
  let itemInfoViewTwo = GFUserInfoItemView()
  let actionButton = GFButton()
  
  var user: User!
  
  init(user: User) {
    super.init(nibName: nil, bundle: nil)
    self.user = user
  }

  required init?(coder: NSCoder) { fatalError("NO STORYBOARDS") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundView()
    layoutUI()
    configureStackView()
    configureActionButton()
  }
  
  private func configureBackgroundView() {
    view.layer.cornerRadius = 18
    view.backgroundColor = .secondarySystemBackground
    
  }
  
  private func configureStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    
    stackView.addArrangedSubviews([itemInfoViewOne, itemInfoViewTwo])
  }
  
  private func configureActionButton() {
    actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
  }
  
  @objc func actionButtonTapped() {
    
  }
  
  private func layoutUI() {
    view.addSubviews([stackView, actionButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: K.padding),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: K.padding),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.padding),
      stackView.heightAnchor.constraint(equalToConstant: 50),
      
      actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -K.padding),
      actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: K.padding),
      actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
}
