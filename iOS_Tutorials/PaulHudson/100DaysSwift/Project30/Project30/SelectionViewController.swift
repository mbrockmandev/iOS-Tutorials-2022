  //
  //  SelectionViewController.swift
  //  Project30
  //
  //  Created by TwoStraws on 20/08/2016.
  //  Copyright (c) 2016 TwoStraws. All rights reserved.
  //

import UIKit

class SelectionViewController: UITableViewController {
  var items = [String]() // this is the array that will store the filenames to load
  var cachedItems: [Item] = []
  var dirty = false
  var index = 0
  var tempItem: Item? {
    didSet {
      guard let tempItem else { return }
      cachedItems[index] = tempItem
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUIAndTableView()
    view.backgroundColor = .systemPink
    
    title = "Reactionist"
    
    tableView.rowHeight = 90
    tableView.separatorStyle = .none
  }
  
  func configureUIAndTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    generateImageCache()
    
    if dirty {
        // we've been marked as needing a counter reload, so reload the whole table
      if let tempItem {
        cachedItems[index] = tempItem        
      }
      tableView.reloadData()
    }
  }
  
    // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
      // Return the number of sections.
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // Return the number of rows in the section.
    return items.count * 10
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
      // find the image for this cell, and load its thumbnail
    var currentItem = cachedItems[indexPath.item % items.count]
    cell.imageView?.image = currentItem.uiImage
    
      // give the images a nice shadow to make them look a bit more dramatic
    cell.imageView?.layer.shadowColor = UIColor.black.cgColor
    cell.imageView?.layer.shadowOpacity = 1
    cell.imageView?.layer.shadowRadius = 10
    cell.imageView?.layer.shadowOffset = CGSize.zero
//    cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
    
      // each image stores how often it's been tapped
//    if let tempItem {
//      currentItem.count = tempItem.count
//    }
    cell.textLabel?.text = "\(currentItem.count)"
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ImageViewController()
    index = indexPath.row
    vc.item = cachedItems[index]
    tempItem = cachedItems[index]
    vc.owner = self
    
      // mark us as not needing a counter reload when we return
    dirty = false
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func generateImageCache() {
    loadItems()
    
    for item in items {
      let newItem = Item(id: UUID(), image: item, count: 0)
      cachedItems.append(newItem)
    }
  }

  func loadItems() {
    let fm = FileManager.default
    
    if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
      for item in tempItems {
        if item.range(of: "Large") != nil {
          items.append(item)
        }
      }
    }
  }
}
