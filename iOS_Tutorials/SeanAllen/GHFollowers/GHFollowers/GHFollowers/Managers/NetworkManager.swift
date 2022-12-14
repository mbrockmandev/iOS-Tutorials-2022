//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/20/22.
//

import UIKit

struct NetworkManager {
  
  static let shared = NetworkManager()
  private let baseURL = "https://api.github.com"
  private let userURLPart = "/users/"
  let cache = NSCache<NSString, UIImage>()
  let decoder = JSONDecoder()
  
  private init() {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
  }
  
  //old way to program networking concurrency
//  func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
//    let endpoint = baseURL + userURLPart + "\(username)/followers?per_page=100&page=\(page)"
//
//    guard let url = URL(string: endpoint) else {
//      completed(.failure(.invalidUsername))
//      return
//    }
//
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//      if let _ = error {
//        completed(.failure(.unableToComplete))
//        return
//      }
//
//      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//        completed(.failure(.invalidResponse))
//        return
//      }
//
//      guard let data else {
//        completed(.failure(.invalidData))
//        return
//      }
//
//      do {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        let followers = try decoder.decode([Follower].self, from: data)
//        completed(.success(followers))
//        return
//      } catch {
//        completed(.failure(.invalidData))
//        return
//      }
//    }
//    task.resume()
//  }
  
  //new async/await - iOS 15
  func getFollowers(for username: String, page: Int) async throws -> [Follower] {
    let endpoint = baseURL + userURLPart + "\(username)/followers?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
      throw GFError.invalidUsername
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw GFError.invalidResponse
    }
    
    do {
      return try decoder.decode([Follower].self, from: data)
    } catch {
      throw GFError.invalidData
    }
  }
  
  
  func getUserInfo(for username: String) async throws -> User {
    let endpoint = baseURL + userURLPart + "\(username)"
    guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw GFError.invalidResponse
    }
    
    do {
      return try decoder.decode(User.self, from: data)
    } catch {
      throw GFError.invalidData
    }
  }
  
  func downloadImage(from urlString: String) async -> UIImage? {
    let cacheKey = NSString(string: urlString)
    if let image = cache.object(forKey: cacheKey) { return image }
    guard let url = URL(string: urlString) else { return nil }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let image = UIImage(data: data) else { return nil }
      cache.setObject(image, forKey: cacheKey)
      return image
    } catch {
      return nil
    }
  }
}

