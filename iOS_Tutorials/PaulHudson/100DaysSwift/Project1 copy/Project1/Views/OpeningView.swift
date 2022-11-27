  //
  //  ViewController.swift
  //  Project1
  //
  //  Created by Michael Brockman on 8/30/22.
  //

import UIKit

class OpeningView: UICollectionViewController {
  var pictures: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path).sorted(by: <)
    
    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
    //TODO: Probably need to change some more idk to update cell but who knows
    print("Test")
    
    return cell
  }
 
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailView {
      vc.selectedImage = pictures[indexPath.item]
      vc.totalImageCount = pictures.count
      vc.selectedImageIndex = indexPath.item
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
    
}

