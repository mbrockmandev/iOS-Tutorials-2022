//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Michael Brockman on 7/4/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var totalBill: Double?
    var people: Int?
    var tip: Float?
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = String(format: "%.2f", totalBill!)
        settingsLabel.text = String("Split between \(people!) people, with \(tip!*100)% tip.")
        
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
