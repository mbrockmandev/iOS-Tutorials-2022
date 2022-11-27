//
//  ViewController.swift
//  Checklists
//
//  Created by Michael Brockman on 9/15/22.
//

import UIKit

class ChecklistViewController: UITableViewController {
  
  var checklist: Checklist!
//  var items = [ChecklistItem]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true

    title = checklist.name
//    loadChecklistItems()
  }
  
  //MARK: - IBActions
  
  
  
  //MARK: - Table View Delegate Methods
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let label = cell.viewWithTag(1000) as! UILabel
    let item = checklist.items[indexPath.row]
    label.text = item.text
    configureCheckmark(for: cell, at: indexPath)
    
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    
    checklist.items[indexPath.row].checked.toggle()
    configureCheckmark(for: cell, at: indexPath)
//    saveChecklistItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    checklist.items.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
//    saveChecklistItems()
  }
  
  //MARK: - My functions for screwin around
  func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
    
    let label = cell.viewWithTag(1001) as! UILabel
    
    for _ in checklist.items {
      if checklist.items[indexPath.row].checked {
        label.text = "√"
      } else {
        label.text = ""
      }
    }
  }
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    
    label.text = item.text
  }
  
//shouldn't need this except to get the whole thing started once -- should be OK to delete
//  func initializeChecklist() {
//    let rowData = ["Walk the dog", "Brush my teeth", "Learn iOS Development", "Soccer practice", "Eat ice cream"]
//    let rowChecked = [false, false, false, false, false]
//
//    for index in 0...4 {
//      items.append(ChecklistItem(text: rowData[index], checked: rowChecked[index]))
//    }
//
//
//  }
  
    //MARK: - File I/O
//  func documentsDirectory() -> URL {
//    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    return paths[0]
//  }
//
//  func dataFilePath() -> URL {
//    return documentsDirectory().appendingPathComponent("Checklists.plist")
//  }
//
//  func saveChecklistItems() {
//    let encoder = PropertyListEncoder()
//
//    do {
//      let data = try encoder.encode(checklist.items)
//
//      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//      print("Data written")
//    } catch {
//      print("Error encoding items array: \(error.localizedDescription)")
//    }
//
//  }
//
//  func loadChecklistItems() {
//    let path = dataFilePath()
//
//    if let data = try? Data(contentsOf: path) {
//      let decoder = PropertyListDecoder()
//
//      do {
//        checklist.items = try decoder.decode([ChecklistItem].self, from: data)
//      } catch {
//        print("Error decoding items: \(error.localizedDescription)")
//      }
//    }
//
//  }
  
  //MARK: - viewWillAppear and other View methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    }
    
    if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }
    }
  }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
//    saveChecklistItems()
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated: true)
//    saveChecklistItems()
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    if let index = checklist.items.firstIndex(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
//    saveChecklistItems()
  }
}
