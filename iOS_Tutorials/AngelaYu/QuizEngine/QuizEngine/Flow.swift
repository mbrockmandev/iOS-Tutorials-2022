//
//  Flow.swift
//  QuizEngine
//
//  Created by Michael Brockman on 8/5/22.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
}

class Flow {
    let router: Router
    let questions: [String]
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { _ in }
        }
        
        

    }
}
