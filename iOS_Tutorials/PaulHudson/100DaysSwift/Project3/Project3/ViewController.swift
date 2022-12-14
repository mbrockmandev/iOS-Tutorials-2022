  //
  //  ViewController.swift
  //  Project3
  //
  //  Created by Michael Brockman on 9/2/22.
  //

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  var webView: WKWebView!
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

    toolbarItems = [spacer, refresh]
    navigationController?.isToolbarHidden = false
    
    let url = URL(string: "https://www.hackingwithswift.com")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    
  }
  
  @objc func openTapped() {
    let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
    ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(ac, animated: true)
  }
  
  func openPage(action: UIAlertAction) {
    let url = URL(string: "https://" + action.title!)!
    webView.load(URLRequest(url: url))
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    navigationItem.title = webView.title
  }
  
}

