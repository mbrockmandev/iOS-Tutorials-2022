//
//  Game.swift
//  BullsEye
//
//  Created by Michael Brockman on 8/7/22.
//

import Foundation

struct LeaderboardEntry {
  let score: Int
  let date: Date
  
}

struct Game {
  var target: Int = Int.random(in: 1...100)
  var score: Int = 0
  var currentRound: Int = 1
  var leaderboardEntries: [LeaderboardEntry] = []
  
  init(loadTestData: Bool = false) {
    if loadTestData {
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
      leaderboardEntries.append(LeaderboardEntry(score: Int.random(in: 1...1000), date: Date()))
    }
  }
  
  
  
  func points(sliderValue: Int) -> Int {
    
    let difference = abs(target - sliderValue)
    let bonus: Int
    
    if (difference == 0) {
        bonus = 100
    } else if (difference <= 2) {
        bonus = 50
    } else {
      bonus = 0
    }
    return 100 - difference + bonus
  }
  
  mutating func startNewRound(points: Int) {
    score += points
    currentRound += 1
    target = Int.random(in: 1...100)
    addToLeaderboard(points: points)
    sortLeaderboard()
  }
  
  mutating func restart() {
    score = 0
    currentRound = 1
    target = Int.random(in: 1...100)
  }
  
  mutating func addToLeaderboard(points: Int) {
    leaderboardEntries.append(LeaderboardEntry(score: points, date: Date()))
  }
  
  mutating func sortLeaderboard() {
    leaderboardEntries.sort { $0.score > $1.score }
  }
}
