//
//  Question.swift
//  MultiplicationTables
//
//  Created by Michael Brockman on 11/12/22.
//

import Foundation

struct Question: Identifiable {
  let id = UUID()
  let questionPrompt: String
  let answerPrompt: String
  let answer: String
  var userAnswer: String
  
  init(questionPrompt: String = "", answerPrompt: String = "", answer: String = "", userAnswer: String = "") {
    self.questionPrompt = questionPrompt
    self.answerPrompt = answerPrompt
    self.answer = answer
    self.userAnswer = userAnswer
  }
}


