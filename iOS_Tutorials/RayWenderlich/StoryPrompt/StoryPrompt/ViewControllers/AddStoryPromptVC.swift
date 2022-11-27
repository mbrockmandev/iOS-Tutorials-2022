//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Michael Brockman on 9/2/22.
//

import UIKit
import PhotosUI

class AddStoryPromptVC: UIViewController {

  @IBOutlet weak var nounTextField: UITextField!
  @IBOutlet weak var adjectiveTextField: UITextField!
  @IBOutlet weak var verbTextField: UITextField!
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var numberSlider: UISlider!
  @IBOutlet weak var storyPromptImageView: UIImageView!

  let storyPrompt = StoryPromptEntry()
  
  
  @IBAction func numberChanged(_ sender: UISlider) {
    numberLabel.text = "Number: \(Int(sender.value))"
    storyPrompt.number = Int(sender.value)
  }
  
  @IBAction func changeStoryType(_ sender: UISegmentedControl) {
    if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
      storyPrompt.genre = genre
    } else {
      storyPrompt.genre = .scifi
    }
  }
  
  @IBAction func generateStoryPrompt(_ sender: Any) {
    updateStoryPrompt()
    if storyPrompt.isValid() {
      performSegue(withIdentifier: "StoryPrompt", sender: nil)
    } else {
      let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all fields.", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { action in
        //action here!
      }
      alert.addAction(action)
      present(alert, animated: true)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    numberSlider.value = 7.5
    let storyPrompt = StoryPromptEntry()
    storyPrompt.number = Int(numberSlider.value)
    storyPromptImageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
    storyPromptImageView.addGestureRecognizer(gestureRecognizer)
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateStoryPrompt), name: UIResponder.keyboardDidHideNotification, object: nil)
    
  }
  
  @objc func changeImage() {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 1
    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = self
    present(controller, animated: true)
  }

  @objc func updateStoryPrompt() {
    storyPrompt.noun = nounTextField.text ?? ""
    storyPrompt.adjective = adjectiveTextField.text ?? ""
    storyPrompt.verb = verbTextField.text ?? ""
    storyPrompt.number = Int(numberSlider.value)

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "StoryPrompt" {
      
      guard let storyPromptVC = segue.destination as? StoryPromptVC else {
        return
      }
      storyPromptVC.storyPrompt = storyPrompt
      storyPromptVC.isNewStoryPrompt = true
    }
  }
  
}

extension AddStoryPromptVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
//    updateStoryPrompt()
    return true
  }
}

extension AddStoryPromptVC: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if !results.isEmpty {
      let result = results.first!
      let itemProvider = result.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
          guard let image = image as? UIImage else {
            return
          }
          DispatchQueue.main.async {
            self?.storyPromptImageView.image = image
          }
        }
      }
    }
    picker.dismiss(animated: true)
  }
  
  
}
