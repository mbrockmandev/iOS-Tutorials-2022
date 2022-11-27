  //
  //  DetailWebView.swift
  //  Project16
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import UIKit
import WebKit

class DetailWebView: UIViewController, WKUIDelegate {
  
  var webView: WKWebView!
  var place: String = ""
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let myURL = URL(string: "https://en.wikipedia.org/wiki/" + place) {
      let myRequest = URLRequest(url: myURL)
      webView.load(myRequest)
    } else {
      webView.load(URLRequest(url: URL(string: "https://en.wikipedia.org/wiki")!))
    }
  }
  
  convenience init(place: String) {
    self.init()
    self.place = place
    print(">>> \(place)")
  }
  
}
