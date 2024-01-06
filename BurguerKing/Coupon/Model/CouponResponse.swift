struct CouponResponse: Decodable {
    let id: Int
    let coupon: String
    let createdDate: String
    let productId: Int
    let userId: Int
    let expiresDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case coupon
        case createdDate = "created_date"
        case productId = "product_id"
        case userId = "user_id"
        case expiresDate = "expires_date"
    }
}
