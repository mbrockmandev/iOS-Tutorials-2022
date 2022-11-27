//
//  GFAlertVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/19/22.
//

import UIKit

class GFAlertVC: UIViewController {

  let containerView = GFContainerView()
  let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
  let messageLabel = GFBodyLabel(textAlignment: .center)
  let actionButton = GFButton(color: .systemPink, title: "OK", systemImageName: "checkmark.circle")
  
  var alertTitle: String?
  var message: String?
  var buttonTitle: String?
  
  init(title: String, message: String, buttonTitle: String) {
    super.init(nibName: nil, bundle: nil)
    self.alertTitle = title
    self.message = message
    self.buttonTitle = buttonTitle
  }
  
  required init?(coder: NSCoder) {fatalError("NO STORYBOARD INIT") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    configureContainerView()
    configureTitleLabel()
    configureActionButton()
    configureMessageLabel()
  }
  
  func configureContainerView() {
    view.addSubview(containerView)
    containerView.addSubviews(titleLabel, actionButton, messageLabel)
    
    
    NSLayoutConstraint.activate([
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 280),
      containerView.heightAnchor.constraint(equalToConstant: 220),
    ])
  }
  
  func configureTitleLabel() {
    titleLabel.text = alertTitle ?? "WHOOPS BROKEN TITLE"
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: K.padding),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: K.padding),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -K.padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 28),
    ])
  }
  
  func configureActionButton() {
    actionButton.setTitle(buttonTitle ?? "WHOOPS BROKEN BUTTON TITLE", for: .normal)
    actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -K.padding),
      actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: K.padding),
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -K.padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
  
  func configureMessageLabel() {
    messageLabel.text = message ?? "WHOOPS BROKEN MSG"
    messageLabel.numberOfLines = 4
    
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: K.padding),
      messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -K.padding),
      messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -K.padding),
    ])
  }
  
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}
