//
//  Sotry.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct Story {
    let title: String
    let choice: Array<String>
    
    init(t: String, c: Array<String>) {
        title = t
        choice = c
    }
}
