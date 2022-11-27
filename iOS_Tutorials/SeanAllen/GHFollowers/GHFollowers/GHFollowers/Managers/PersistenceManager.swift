//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/25/22.
//

import Foundation

enum PersistenceActionType {
  case add, remove
}

enum PersistenceManager {
  
  static private let defaults = UserDefaults.standard
  enum Keys { static let favorites = "favorites" }
  
  
  static func updateWith(favorite: Follower, actionType: PersistenceActionType) async throws {
    do {
      var favorites = try await retrieveFavorites()
      switch actionType {
      case .add:
        guard !favorites.contains(favorite) else {
          throw GFError.favoriteAlreadyInFavorites
        }
        favorites.append(favorite)
      case .remove:
        favorites.removeAll { $0.login == favorite.login }
      }
      try? await save(favorites: favorites)
    } catch {
      throw GFError.unableToFavorite
    }
  }
  
  static func retrieveFavorites() async throws -> [Follower] {
    guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
      return [Follower]()
    }
    
    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([Follower].self, from: favoritesData)
      return favorites
    } catch {
      throw GFError.unableToFavorite
    }
  }
  
  static func save(favorites: [Follower]) async throws {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favorites)
    } catch {
      throw GFError.unableToFavorite
    }
  }
}
