//
//  GFError.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/20/22.
//

import Foundation

enum GFError: String, Error {
  case unableToComplete = "Unable to complete your request. Please check your internet connection."
  case invalidUsername = "This username created an invalid request. Please try again."
  case invalidResponse = "Invalid response from the server. Please try again."
  case invalidData = "The data received from the server was invalid. Please try again."
  case unableToFavorite = "We were unable to favorite this user for some reason. Please try again."
  case favoriteAlreadyInFavorites = "You already favorited this user. You must REALLY like them."
}
