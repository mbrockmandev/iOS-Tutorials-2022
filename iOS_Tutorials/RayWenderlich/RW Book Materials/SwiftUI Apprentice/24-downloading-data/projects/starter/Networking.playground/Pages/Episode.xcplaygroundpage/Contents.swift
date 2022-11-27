//: ## Episode
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: [VideoURL ->](@next)
struct VideoURLString {
  var urlString: String
  
  enum CodingKeys: CodingKey {
    case data
  }
  
  enum DataKeys: CodingKey {
    case attributes
  }
}

extension VideoURLString: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
    let attr = try dataContainer.decode(VideoAttributes.self, forKey: .attributes)
    urlString = attr.url
  }
}

struct VideoAttributes: Codable {
  var url: String
}

struct EpisodeStore: Decodable {
  var episodes: [Episode] = []
  
  enum CodingKeys: String, CodingKey {
    case episodes = "data"
  }
}

struct Episode: Decodable, Identifiable {
  let id: String
  let uri: String
  let name: String
  let released: String
  let difficulty: String?
  let description: String
    
  var domain = ""
  
  var videoURL: VideoURL?
  
  var linkURLString: String {
    "https://www.raywenderlich.com/redirect?uri=" + uri
  }
  
  static let domainDictionary = [
    "1": "iOS & Swift",
    "2": "Android & Kotlin",
    "3": "Unity",
    "5": "macOS",
    "8": "Server-Side Swift",
    "9": "Flutter"
  ]
  
  enum DataKeys: String, CodingKey {
    case id
    case attributes
    case relationships
  }
  
  enum AttrsKeys: String, CodingKey {
    case uri, name, difficulty
    case releasedAt = "released_at"
    case description = "description_plain_text"
    case videoIdentifier = "video_identifier"
  }
  
  struct Domains: Codable {
    let data: [[String: String]]
  }
  
  enum RelKeys: String, CodingKey {
    case domains
  }
}

extension Episode {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DataKeys.self)
    let id = try container.decode(String.self, forKey: .id)
    let attrs = try container.nestedContainer(keyedBy: AttrsKeys.self, forKey: .attributes)
    
    let uri = try attrs.decode(String.self, forKey: .uri)
    let name = try attrs.decode(String.self, forKey: .name)
    let releasedAt = try attrs.decode(String.self, forKey: .releasedAt)
    let releaseDate = Formatter.iso8601.date(from: releasedAt)!
    let difficulty = try attrs.decode(String?.self, forKey: .difficulty)
    let description = try attrs.decode(String.self, forKey: .description)
    let videoIdentifier = try attrs.decode(Int?.self, forKey: .videoIdentifier)
    
    let rels = try container.nestedContainer(keyedBy: RelKeys.self, forKey: .relationships)
    let domains = try rels.decode(Domains.self, forKey: .domains)
    if let domainId = domains.data.first?["id"] {
      self.domain = Episode.domainDictionary[domainId] ?? ""
    }
    
    self.id = id
    self.uri = uri
    self.name = name
    self.released = DateFormatter.episodeDateFormatter.string(from: releaseDate)
    self.difficulty = difficulty
    self.description = description
    if let videoId = videoIdentifier {
      self.videoURL = VideoURL(videoId: videoId)
    }
  }
}

class VideoURL {
  var urlString = ""
  
  init(videoId: Int) {
    let baseURLString = "https://api.raywenderlich.com/api/videos/"
    let queryURLString = baseURLString + String(videoId) + "/stream"
    guard let queryURL = URL(string: queryURLString) else { return }
    URLSession.shared.dataTask(with: queryURL) { data, response, error in
      if let data, let response = response as? HTTPURLResponse {
        print("\(videoId) \(response.statusCode)")
        if let decodedResponse = try? JSONDecoder().decode(VideoURLString.self, from: data) {
          DispatchQueue.main.async {
            self.urlString = decodedResponse.urlString
            print(self.urlString)
          }
          return
        }
      }
      print("Video fetch failed: " + "\(error?.localizedDescription ?? "Unknown error")")
    }
    .resume()
  }
}

//: [VideoURL ->](@next)
let baseURLString = "https://api.raywenderlich.com/api/"
var urlComponents = URLComponents(string: baseURLString + "contents/")!

var baseParams = [
  "filter[subscription_types][]": "free",
  "filter[content_types][]": "episode",
  "sort": "-popularity",
  "page[size]": "20",
  "filter[q]": ""
]
urlComponents.setQueryItems(with: baseParams)

urlComponents.queryItems! += [URLQueryItem(name: "filter[domain_ids][]", value: "1")]
urlComponents.url?.absoluteString

let contentsURL = urlComponents.url!

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(.apiDateFormatter)

URLSession.shared.dataTask(with: contentsURL) { data, response, error in
  defer { PlaygroundPage.current.finishExecution() }
  if let data, let response = response as? HTTPURLResponse {
    print(response.statusCode)
    if let decodedResponse = try? decoder.decode(EpisodeStore.self, from: data) {
      DispatchQueue.main.async {
        print(decodedResponse.episodes[0].released)
        print(decodedResponse.episodes[0].domain)
      }
      return
    }
  }
  print("Contents fetch failed: " + "\(error?.localizedDescription ?? "Unknown Error")")
}
.resume()


