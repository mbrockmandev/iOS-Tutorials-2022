  //
  //  UserStore.swift
  //  Day60Challenge
  //
  //  Created by Michael Brockman on 10/29/22.
  //

import Foundation

class UserStore: ObservableObject, Decodable {
  @Published var users: [User] = []
  
  init() {
    self.users = users
  }
  
  func fetchContents() async {
    guard users.isEmpty else { return }
    
    do {
      guard let url = URL(string: User.linkURLString) else {
        print("url is incorrect")
        return
      }
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      users = try decoder.decode([User].self, from: data)
    } catch {
      print("Download failed")
  }
    
}


enum CodingKeys: String, CodingKey {
  case users = "data"
}

required init(from decoder: Decoder) throws {
  let container = try decoder.container(keyedBy: CodingKeys.self)
  users = try container.decode([User].self, forKey: .users)
}
}
