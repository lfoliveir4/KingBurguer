struct HighlightResponse: Decodable {
    let id: Int
    let productId: Int
    let pictureURL: String
    let createdDate: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case pictureURL = "picture_url"
        case createdDate = "created_date"
    }
}
