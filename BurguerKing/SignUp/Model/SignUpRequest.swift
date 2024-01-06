import Foundation

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let document: String
    let birthday: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case document
        case birthday
    }
}
