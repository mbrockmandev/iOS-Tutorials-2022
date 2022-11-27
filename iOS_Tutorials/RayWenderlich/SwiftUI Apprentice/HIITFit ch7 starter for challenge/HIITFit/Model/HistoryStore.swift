//
//  HistoryStore.swift
//  HIITFit
//
//  Created by Michael Brockman on 10/4/22.
//

import Foundation

struct ExerciseDay: Identifiable {
  let id = UUID()
  let date: Date
  var exercises: [String]
}

struct HistoryStore {
  var exerciseDays: [ExerciseDay] = []
  
  init() {
    #if DEBUG
    createDevData()
    #endif
  }
  
  mutating func addDoneExercise(_ exerciseName: String) {
    let today = Date()
    if today.isSameDay(as: exerciseDays[0].date) { // 1
      print("Adding \(exerciseName)")
      exerciseDays[0].exercises.append(exerciseName)
    } else {
      exerciseDays.insert( // 2
        ExerciseDay(date: today, exercises: [exerciseName]),
        at: 0)
    }
  }
}
