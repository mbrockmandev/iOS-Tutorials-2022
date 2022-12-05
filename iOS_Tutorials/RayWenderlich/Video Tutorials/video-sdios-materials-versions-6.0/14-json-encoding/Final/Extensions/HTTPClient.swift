//
//  HTTPClient.swift
//  TaskList
//
//  Created by Michael Brockman on 12/5/22.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case decodingError
}

enum HttpMethod {
  case get([URLQueryItem])
  case post(Data?)
  case delete
  
  var name: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .delete:
      return "DELETE"
    }
  }
}

struct Resource<T: Codable> {
  let url: URL
  var headers: [String: String] = [:]
  var method: HttpMethod = .get([])
}

class StoreHTTPClient {
  func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
    print(resource.url.absoluteString)
    
    var request = URLRequest(url: resource.url)
    
    switch resource.method {
    case .get(let queryItems):
      var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
      components?.queryItems = queryItems
      guard let url = components?.url else {
        throw NetworkError.invalidURL
      }
      
      request = URLRequest(url: url)
      
    case .post(let data):
      request.httpBody = data
      
    default:
      break
    }
    
    request.allHTTPHeaderFields = resource.headers
    request.httpMethod = resource.method.name
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
    
    let session = URLSession(configuration: configuration)
    
    let (data, response) = try await session.data(for: request)
    guard let _ = response as? HTTPURLResponse
    else {
      throw NetworkError.invalidResponse
    }
    
    guard let result = try? JSONDecoder().decode(T.self, from: data) else {
      throw NetworkError.decodingError
    }
    
    return result
  
  }
  
  
}


