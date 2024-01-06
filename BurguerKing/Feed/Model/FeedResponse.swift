struct FeedResponse: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let id: Int
    let name: String
    let products: [Product]
}

struct Product: Decodable {
    let id: Int
    let name: String
    let description: String
    let pictureURL: String
    let price: Double
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case pictureURL = "picture_url"
        case price
        case createdDate = "created_date"
    }
}
