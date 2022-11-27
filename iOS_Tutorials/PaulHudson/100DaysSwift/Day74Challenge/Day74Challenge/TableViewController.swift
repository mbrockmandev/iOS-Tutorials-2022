  //
  //  ViewController.swift
  //  Day74Challenge
  //
  //  Created by Michael Brockman on 11/15/22.
  //

import UIKit

class TableViewController: UITableViewController {
      var notes: [Note] = DataManager.load()
//  var notes: [Note] = Note.example
  var noteToUpdate = Note(title: "", body: "")
  var currentNoteIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBarButtonItems()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
      
    
  }
  
  func addBarButtonItems() {
    let rightBarBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    navigationItem.rightBarButtonItem = rightBarBtn
  }
  
  @objc func addNote() {
    
    
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if notes.isEmpty { return 1 }
    return notes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
    let note = notes[indexPath.row]
    cell.textLabel?.text = note.title
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    currentNoteIndex = indexPath.row
    noteToUpdate = notes[currentNoteIndex]
    self.performSegue(withIdentifier: "ShowDetailVC", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetailVC",
       let detailVC = segue.destination as? DetailViewController {
      detailVC.delegate = self
      detailVC.note = noteToUpdate
      updateNote(detailVC.note)

    }
    
    //if segue.identifier == "AddNoteVC"

  }
  
}

extension TableViewController: DetailViewControllerDelegate {
  func updateNote(_ note: Note) {
    self.tableView.reloadData()
    notes[currentNoteIndex] = note
    DataManager.save(notes)
//    print("\(notes)") //debug statements
//    print(">>> TVC updateNote() || index: \(currentNoteIndex) note: \(note)")
  }
}
