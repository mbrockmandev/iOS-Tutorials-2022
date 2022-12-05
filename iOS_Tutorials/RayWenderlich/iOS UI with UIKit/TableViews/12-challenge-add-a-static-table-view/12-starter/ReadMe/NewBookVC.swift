//
//  NewBookVC.swift
//  ReadMe
//
//  Created by Michael Brockman on 11/29/22.
//


import UIKit

class NewBookVC: UITableViewController {
//  let book: Book
  
  @IBOutlet var titleTextField: UITextField!
  @IBOutlet var authorTextField: UITextField!
  @IBOutlet var imageView: UIImageView!
  
  @IBAction func addImageButtonTapped(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  required init?(coder: NSCoder) { //, book: Book = Book(title: "", author: "")) {
//    self.book = book
    super.init(coder: coder)
  }
}

extension NewBookVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == titleTextField {
      return authorTextField.becomeFirstResponder()
    } else {
      return textField.resignFirstResponder()
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
  
  
}

extension NewBookVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedImage = info[.editedImage] as? UIImage else { return }
    imageView.image = selectedImage
//    Library.saveImage(selectedImage, forBook: book)
    dismiss(animated: true)
  }
}

