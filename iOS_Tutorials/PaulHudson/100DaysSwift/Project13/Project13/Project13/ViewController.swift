//
//  ViewController.swift
//  Project13
//
//  Created by Michael Brockman on 10/22/22.
//

import CoreImage
import UIKit

class ViewController: UIViewController {
  var currentImage: UIImage!
  var context: CIContext!
  var currentFilter: CIFilter!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var intensity: UISlider!
  @IBOutlet weak var radius: UISlider!
  
  @IBAction func changeFilter(_ sender: Any) {
    let ac = UIAlertController(title: currentFilter.name, message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func setFilter(action: UIAlertAction) {
    guard currentImage != nil, let actionTitle = action.title else { return }
    
    currentFilter = CIFilter(name: actionTitle)
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    applyProcessing()
  }
  
  
  @IBAction func save(_ sender: Any) {
    guard let image = imageView.image else {
      let ac = UIAlertController(title: "Error", message: "Please add an image before trying to save.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
      return
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  
  @IBAction func radiusChanged(_ sender: Any) {
    applyProcessing()
  }
  
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
    
    title = "YACIFP"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error {
      let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }

  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func applyProcessing() {
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
    if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
    if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
    if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
    
    if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      imageView.alpha = 0
      UIView.animate(withDuration: 3, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) {
        self.imageView.alpha = 1
      }
      
      imageView.image = processedImage
    }
  }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    
    currentImage = image
    
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    applyProcessing()
  }
}
