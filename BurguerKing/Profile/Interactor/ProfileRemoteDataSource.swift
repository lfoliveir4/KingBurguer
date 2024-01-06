import Foundation

final class ProfileRemoteDataSource {
    static let instance = ProfileRemoteDataSource()
    private let webService: WebService = .instance
    
    func fetch(completion: @escaping (ProfileResponse?, String?) -> Void) {
        webService.call(
            path: .me,
            body: Optional<ProfileResponse>.none,
            method: .get
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(ProfileResponse.self, from: data)
                completion(response, nil)
                
            case .failure(let error, let data):
                print("error fetch profile \(error)")
                print("error fetch profile data \(String(describing: data))")
            }
        }
    }
}
