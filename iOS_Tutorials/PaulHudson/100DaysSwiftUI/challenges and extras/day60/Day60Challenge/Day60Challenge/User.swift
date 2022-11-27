//
//  User.swift
//  Day60Challenge
//
//  Created by Michael Brockman on 10/29/22.
//
//  is the JSON file
import Foundation

struct User: Codable, Identifiable {
  
  let id: String
  let name: String
//  let age: Int
  let email: String
  let address: String
  let about: String
//  let friends: [Friend]
  
  enum DataKeys: String, CodingKey {
    case id, name, email, address, about, friends
  }
  
  enum FriendKeys: String, CodingKey {
    case id, name
  }
  
  static var linkURLString: String {
    "https://www.hackingwithswift.com/samples/friendface.json"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DataKeys.self)
    let id = try container.decode(String.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let email = try container.decode(String.self, forKey: .email)
    let address = try container.decode(String.self, forKey: .address)
    let about = try container.decode(String.self, forKey: .about)
//    let friendDict = try container.nestedContainer(keyedBy: FriendKeys.self, forKey: friends)
    
    //let age
    
    self.id = id
    self.name = name
    self.email = email
    self.address = address
    self.about = about
    
  }
  
  func encode(to encoder: Encoder) throws {
    //
  }
  
  
}

/*JSON Format for User: Array -> Dictionary -> properties
id: String
 name: String (first and last name)
 age: Int
 email: String
 address: String
 about: String (description)
 friends: Array of Dictionaries with two properties: id and name
          [Dictionary]
*/
