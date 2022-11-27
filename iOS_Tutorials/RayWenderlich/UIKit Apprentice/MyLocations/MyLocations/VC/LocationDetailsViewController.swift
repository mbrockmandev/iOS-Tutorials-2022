  //
  //  LocationDetailsViewController.swift
  //  MyLocations
  //
  //  Created by Michael Brockman on 9/19/22.
  //

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
    //Instance properties
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"
  var managedObjectContext: NSManagedObjectContext!
  var date = Date()
  var observer: Any!
  var image: UIImage? {
    didSet {
      imageView.image = image
      let aspectRatio = image!.size.width / image!.size.height
      imageView.isHidden = false
      addPhotoLabel.text = ""
      imageHeight.constant = 260 / aspectRatio
      tableView.reloadData()
    }
  }
  var locationToEdit: Location? {
    didSet {
      if let location = locationToEdit {
        descriptionText = location.locationDescription
        categoryName = location.category
        date = location.date
        coordinate = CLLocationCoordinate2DMake(
          location.latitude,
          location.longitude)
        placemark = location.placemark
      }
    }
  }
  var descriptionText = ""
  
    //MARK: - @IBOutlets
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var categoryLabel: UILabel!
  @IBOutlet var latitudeLabel: UILabel!
  @IBOutlet var longitudeLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var addPhotoLabel: UILabel!
  @IBOutlet var imageHeight: NSLayoutConstraint!
  
  
  //MARK: - @IBActions
  @IBAction func done() {
    guard let mainView = navigationController?.parent?.view else { return }
    let hudView = HudView.hud(inView: mainView, animated: true)
    hudView.text = "Tagged"
    
    let location: Location
    if let temp = locationToEdit {
      hudView.text = "Updated"
      location = temp
    } else {
      hudView.text = "Tagged"
      location = Location(context: managedObjectContext)
      location.photoID = nil
    }
    
    location.locationDescription = descriptionTextView.text
    location.category = categoryName
    location.latitude = coordinate.latitude
    location.longitude = coordinate.longitude
    location.date = date
    location.placemark = placemark
    
    if let image = image {
      if !location.hasPhoto {
        location.photoID = Location.nextPhotoID() as NSNumber
      }
      
      if let data = image.jpegData(compressionQuality: 0.5) {
        do {
          location.photoID = Location.nextPhotoID() as NSNumber
          try data.write(to: location.photoURL, options: .atomic)
          print("LOCATION PHOTOURL === \(location.photoURL)")
        } catch {
          print("Error writing file: \(error)")
        }
      }
    }
    
    do {
      try managedObjectContext.save()
      afterDelay(0.6) {
        hudView.hide(animated: true)
        self.navigationController?.popViewController(animated: true)
      }
    } catch {
      fatalCoreDateError(error)
    }
  }
  
  @IBAction func cancel() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
  
    //MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    listenForBackgroundNotification()
    
    if locationToEdit == nil {
      configureAddLocationUI()
    } else {
      configureEditLocationUI()
    }
  }
  
  func configureAddLocationUI() {
      //defaults!
    title = "Add Location"
    addPhotoLabel.text = "Add Photo"
    descriptionTextView.text = ""
    categoryLabel.text = categoryName
    latitudeLabel.text = String(coordinate.latitude)
    longitudeLabel.text = String(coordinate.longitude)
    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    } else {
      addressLabel.text = "No Address Found"
    }
    
    dateLabel.text = format(date: date)
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }
  
  func configureEditLocationUI() {
    guard let location = locationToEdit else { return }
    title = "Edit Location"
    
    if location.hasPhoto {
      if let theImage = location.photoImage {
        self.image = theImage
//        print("theImage === \(location.photoURL)")
      }
    }
    descriptionTextView.text = descriptionText
    categoryLabel.text = categoryName
    latitudeLabel.text = String(coordinate.latitude)
    longitudeLabel.text = String(coordinate.longitude)
    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    } else {
      addressLabel.text = "No Address Found"
    }
    
    dateLabel.text = format(date: date)
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }
  
//  func show(image: UIImage) {
//    imageView.image = image
//    imageView.isHidden = false
//    addPhotoLabel.text = ""
//  }
  
    //MARK: - Helper methods
  func string(from placemark: CLPlacemark) -> String {
    
    var line = ""
    line.add(text: placemark.subThoroughfare)
    line.add(text: placemark.thoroughfare, separatedBy: " ")
    line.add(text: placemark.locality, separatedBy: ", ")
    line.add(text: placemark.administrativeArea, separatedBy: ", ")
    line.add(text: placemark.postalCode, separatedBy: " ")
    line.add(text: placemark.country, separatedBy: ", ")
    return line
  }
  
  func format(date: Date) -> String {
    return dateFormatter.string(from: date)
  }
  
  @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
    let point = gestureRecognizer.location(in: tableView)
    
    guard let indexPath = tableView.indexPathForRow(at: point) else {
      descriptionTextView.resignFirstResponder()
      return
    }
    
    if indexPath.section == 0 && indexPath.row == 0 {
      return
    }
    descriptionTextView.resignFirstResponder()
  }
  
  func listenForBackgroundNotification() {
    observer = NotificationCenter.default.addObserver(
      forName: UIScene.didEnterBackgroundNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] _ in
        guard let self = self else { return }
        if self.presentedViewController != nil {
          self.dismiss(animated: false)
        }
        self.descriptionTextView.resignFirstResponder()
      }
  }
  
    // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    //this code is janky and needs replaced
    if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      
      descriptionTextView.becomeFirstResponder()
    } else if indexPath.section == 2 && indexPath.row == 0 {
      tableView.deselectRow(at: indexPath, animated: true)
      pickPhoto()
    }
  }
  
  
    // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }
  
    //MARK: - deinit
  deinit {
    print("### DEINIT \(self)")
    NotificationCenter.default.removeObserver(observer!)
  }
}
  //MARK: - Image Helper Methods
extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//    if let theImage = image {
//      show(image: theImage)
//    }
    dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func pickPhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }
  
  func showPhotoMenu() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let actCancel = UIAlertAction(title: "Cancel", style: .cancel)
    let actPhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
      self.takePhotoWithCamera()
    }
    let actLibrary = UIAlertAction(title: "Choose From Library", style: .default) { _ in
      self.choosePhotoFromLibrary()
    }
    
    alert.addAction(actCancel)
    alert.addAction(actPhoto)
    alert.addAction(actLibrary)
    
    present(alert, animated: true)
  }
  
  
}
