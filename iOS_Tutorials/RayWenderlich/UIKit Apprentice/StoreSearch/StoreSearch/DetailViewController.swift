  //
  //  DetailViewController.swift
  //  StoreSearch
  //
  //  Created by Michael Brockman on 9/27/22.
  //

import UIKit
import MessageUI

class DetailViewController: UIViewController {
  var isPopUp = false {
    didSet {
      print("&&& isPopUp state changed")
    }
  }
  var searchResult: SearchResult! {
    didSet {
      if isViewLoaded {
        configureUI()
      }
    }
  }
  private var downloadTask: URLSessionDownloadTask!
  private var dismissStyle = AnimationStyle.fade
  
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  enum AnimationStyle {
    case slide
    case fade
  }
  
  @IBAction func close() {
    dismissStyle = .slide
    dismiss(animated: true)
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: [:])
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    transitioningDelegate = self
  }
  
  //MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  @objc func showPopover(_ sender: UIBarButtonItem) {
    guard let popover = storyboard?.instantiateViewController(withIdentifier: K.popoverViewID) as? MenuViewController
    else { return }
    
    popover.modalPresentationStyle = .popover
    if let ppc = popover.popoverPresentationController {
      if #available(iOS 16.0, *) {
        ppc.sourceItem = sender
      } else {
        ppc.barButtonItem = sender
      }
    }
    popover.delegate = self
    present(popover, animated: true)
  }
  
  func configureUI() {
    if isPopUp {
      view.backgroundColor = UIColor.clear
      let dimmingView = GradientView(frame: .zero)
      dimmingView.frame = view.bounds
      view.insertSubview(dimmingView, at: 0)
    } else {
      view.backgroundColor = UIColor(patternImage: UIImage(named: K.landscapeBackground)!)
      popupView.isHidden = true
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPopover(_:)))
    }
    if searchResult != nil {
      updateUI()
    }
  }
  
  func updateUI() {
    
    UIView.transition(with: popupView, duration: 0.4,
                      options: .transitionCrossDissolve,
                      animations: {
      self.popupView.isHidden = false
    })
    
    guard let searchResult = searchResult else { return }
    nameLabel.text = searchResult.name
    if searchResult.artist.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown")
    } else {
      artistNameLabel.text = searchResult.artist
    }
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = NSLocalizedString("Free", comment: "Free")
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    if let smallURL = URL(string: searchResult.imageSmall) {
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
    
    popupView.layer.cornerRadius = 10
    popupView.sizeToFit()
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  
}

  //MARK: - UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return nil
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch dismissStyle {
    case .slide:
      return SlideOutAnimationController()
    case .fade:
      return FadeOutAnimationController()
    }
  }
}

extension DetailViewController: MenuViewControllerDelegate {
  
  func menuViewControllerSendEmail(_ controller: MenuViewController) {
    if MFMailComposeViewController.canSendMail() {
      let controller = MFMailComposeViewController()
      controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
      controller.setToRecipients(["brockmmp@gmail.com"])
      controller.mailComposeDelegate = self
      self.present(controller, animated: true)
    }
  }
  
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true)
  }
}
