  //
  //  ViewController.swift
  //  Project1
  //
  //  Created by Michael Brockman on 8/30/22.
  //

import UIKit

class OpeningView: UITableViewController {
  var pictures: [String] = []
  var imageData: [photoData] = []
  
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
    imageData = Array(repeating: photoData(timesLoaded: 0), count: pictures.count)
    load()
  }
  
  func save() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(imageData) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "image")
    } else {
      print("failed to save data.")
    }
  }

  func load() {
    let defaults = UserDefaults.standard
    if let savedImageData = defaults.object(forKey: "imageData") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
        imageData = try jsonDecoder.decode([photoData].self, from: savedImageData)
      } catch {
        print("Failed to load image data.")
      }
    }
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    cell.detailTextLabel?.text = "Times Loaded: \(imageData[indexPath.row].timesLoaded)"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailView {
      vc.selectedImage = pictures[indexPath.row]
      vc.totalImageCount = pictures.count
      vc.selectedImageIndex = indexPath.row
      
      imageData[indexPath.row].timesLoaded += 1
      self.tableView.reloadData()
      print(imageData[indexPath.row].timesLoaded)
      
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

struct photoData: Codable {
  var timesLoaded: Int
}

