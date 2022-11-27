//
//  PostData.swift
//  h4x0rn3wz
//
//  Created by Michael Brockman on 8/30/22.
//

import Foundation

struct Results: Decodable {
  let hits: [Post]
}

struct Post: Decodable, Identifiable {
  var id: String { return objectID }
  let objectID: String
  let points: Int
  let title: String
  let url: String?
}
