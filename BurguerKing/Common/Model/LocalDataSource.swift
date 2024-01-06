import Foundation

final class LocalDataSource {
    static let instance = LocalDataSource()
    private let userDefaults: UserDefaults = .standard
    private let userIdentifier = "user_key"
    
    func saveUser(user: User) {
        let value = try? PropertyListEncoder().encode(user)
        userDefaults.setValue(value, forKey: userIdentifier)
    }
    
    func getUser() -> User? {
        if let data = userDefaults.value(forKey: userIdentifier) as? Data {
            return try? PropertyListDecoder().decode(User.self, from: data)
        }
        return nil
    }
    
    func logout() {
        userDefaults.removeObject(forKey: userIdentifier)
    }
}
