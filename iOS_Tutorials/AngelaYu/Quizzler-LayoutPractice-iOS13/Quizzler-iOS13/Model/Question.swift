//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Michael Brockman on 6/23/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct Question {
    let text: String
    let answer: Array<String>
    let cAns: String
    
    init(q: String, a: Array<String>, correctAnswer: String) {
        text = q
        answer = a
        cAns = correctAnswer
    }
}
