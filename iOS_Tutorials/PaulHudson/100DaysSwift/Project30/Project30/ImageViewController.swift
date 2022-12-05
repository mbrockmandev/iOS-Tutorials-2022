  //
  //  ImageViewController.swift
  //  Project30
  //
  //  Created by TwoStraws on 20/08/2016.
  //  Copyright (c) 2016 TwoStraws. All rights reserved.
  //

import UIKit

class ImageViewController: UIViewController {
  weak var owner: SelectionViewController!
//  var image: String!
  var animTimer: Timer!
  var imageView: UIImageView!
  var item: Item!
  
  override func loadView() {
    super.loadView()
    
    view.backgroundColor = UIColor.black
    
      // create an image view that fills the screen
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.alpha = 0
    
    view.addSubview(imageView)
    
      // make the image view fill the screen
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
      // schedule an animation that does something vaguely interesting
    animTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      guard let self else { return }
        // do something exciting with our image
      self.imageView.transform = CGAffineTransform.identity
      
      UIView.animate(withDuration: 1) {
        self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = item.image.replacingOccurrences(of: "-Large.jpg", with: "")
    
    guard let original = UIImage(named: item.image) else { return }
    
    let renderer = UIGraphicsImageRenderer(size: original.size)
    
    let rounded = renderer.image { ctx in
      ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
      ctx.cgContext.closePath()
      
      original.draw(at: CGPoint.zero)
    }
    
    imageView.image = rounded
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    imageView.alpha = 0
    
    UIView.animate(withDuration: 3) { [unowned self] in
      self.imageView.alpha = 1
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    animTimer.invalidate()
    owner.index = owner.cachedItems.firstIndex(where: { item in
      item.id == self.item.id
    }) ?? 0
    DataManager.save(owner.cachedItems)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    owner.tempItem?.count += 1 //maybe crap?
    
    // tell the parent view controller that it should refresh its table counters when we go back
    owner.dirty = true
  }
}
