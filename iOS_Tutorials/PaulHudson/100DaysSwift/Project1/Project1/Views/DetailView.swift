    //
    //  DetailView.swift
    //  Project1
    //
    //  Created by Michael Brockman on 8/30/22.
    //

import UIKit

class DetailView: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageIndex: Int?
    var totalImageCount: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageNum = selectedImageIndex ?? Int.min
        let imageCount = totalImageCount ?? Int.min
        
        if imageNum == Int.min {
            title = selectedImage
        } else {
            title = "Image \(imageNum + 1) of \(imageCount)"
        }
        navigationItem.largeTitleDisplayMode = .never
        
        performSelector(onMainThread: #selector(loadPictures), with: nil, waitUntilDone: false)
        assert(selectedImage != nil)
    }
    
    @objc func loadPictures() {
        if let imageToLoad = selectedImage {
          
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
}
