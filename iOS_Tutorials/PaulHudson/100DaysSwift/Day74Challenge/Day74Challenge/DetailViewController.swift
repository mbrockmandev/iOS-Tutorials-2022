  //
  //  AddNoteViewController.swift
  //  Day74Challenge
  //
  //  Created by Michael Brockman on 11/15/22.
  //
//TODO: Add delete and compose toolbar buttons to this VC
//TODO: try to imitate the notes app
import UIKit

protocol DetailViewControllerDelegate: AnyObject {
  func updateNote(_ note: Note) 
}

class DetailViewController: UIViewController {
  var note: Note
  weak var delegate: DetailViewControllerDelegate?
  
  init(note: Note) {
    self.note = note
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.note = Note(title: "", body: "")
    super.init(coder: aDecoder)
  }
  
  
  @IBOutlet weak var noteTitle: UITextField!
  @IBOutlet weak var noteBody: UITextView!
  
  @IBAction func noteChanged(_ sender: Any) {
    note.title = noteTitle.text ?? ""
    note.body = noteBody.text
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    noteTitle.text = note.title
    noteBody.text = note.body
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    delegate?.updateNote(note)
    
  }
  
}

