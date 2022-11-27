//
//  CalculatorBrain.swift
//  Tipsy
//
//  Created by Michael Brockman on 7/4/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    //declare variable for tip percentage, split between people, and bill total
    var tipPct = 0
    var people = 0
    var totalBill = 0.0
    
    //method for calculating resulting bill per person
    mutating func calculateTip(tipPct: Int, people: Int, totalBill: Float) -> Float {
        let splitBill = ( totalBill * (1 + Float(tipPct/100)) )
                                / Float(people)
        return splitBill
    }
}
