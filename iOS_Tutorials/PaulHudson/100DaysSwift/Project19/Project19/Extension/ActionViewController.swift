  //
  //  ActionViewController.swift
  //  Extension
  //
  //  Created by Michael Brockman on 10/26/22.
  //

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
  var pageTitle = ""
  var pageURL = ""
  
  @IBOutlet weak var script: UITextView!
  
  @IBAction func done() {
    let item = NSExtensionItem()
    let argument: NSDictionary = ["customJavaScript": script.text]
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
    let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
    item.attachments = [customJavaScript]
    
    extensionContext?.completeRequest(returningItems: [item])
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      script.contentInset = .zero
    } else {
      script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    script.scrollIndicatorInsets = script.contentInset
    
    let selectedRange = script.selectedRange
    script.scrollRangeToVisible(selectedRange)
    
  }
  
  @IBAction func doChallenge() {
    let ac = UIAlertController(title: "AC Title", message: "AC Msg", preferredStyle: .actionSheet)
    
    ac.addAction(UIAlertAction(title: "Option 1", style: .default, handler: { [weak self] action in
      guard let self = self else { return }
      self.runFirstJS()
    }))
    ac.addAction(UIAlertAction(title: "Option 2", style: .default, handler: { action in
        //run JS script 2
    }))
    present(ac, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(doChallenge))
    
    
  }
  
  func runFirstJS() {
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first {
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
          guard let itemDictionary = dict as? NSDictionary else { return }
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
          
          self?.pageTitle = javaScriptValues["title"] as? String ?? ""
          self?.pageURL = javaScriptValues["URL"] as? String ?? ""
          
          DispatchQueue.main.async {
            self?.title = self?.pageTitle
            print(self?.pageTitle as Any)
            print(self?.pageURL as Any)
            self?.save(javaScriptValues)
          }
          
        }
      }
    }
  }
  
  func save(_ javaScriptValues: NSDictionary) {
    let defaults = UserDefaults.standard
    defaults.set(javaScriptValues, forKey: "UserJS")
    print(javaScriptValues)
        
    let stringURL = javaScriptValues["URL"] as? String ?? ""
    if let url = URL(string: stringURL) {
      defaults.set(url.host, forKey: "urlHost")
      print(url.host as Any)
    }
  }
  
  
  
  /*
   // Get the item[s] we're handling from the extension context.
   
   // For example, look for an image and place it into an image view.
   // Replace this with something appropriate for the type[s] your extension supports.
   var imageFound = false
   for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
   for provider in item.attachments! {
   if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
   // This is an image. We'll load it, then place it in our image view.
   weak var weakImageView = self.imageView
   provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
   OperationQueue.main.addOperation {
   if let strongImageView = weakImageView {
   if let imageURL = imageURL as? URL {
   strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
   }
   }
   }
   })
   
   imageFound = true
   break
   }
   }
   
   if (imageFound) {
   // We only handle one image, so stop looking for more.
   break
   }
   }*/
  
  
  
  
}
