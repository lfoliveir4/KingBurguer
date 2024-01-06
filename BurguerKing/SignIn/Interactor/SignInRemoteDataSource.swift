import Foundation

final class SignInRemoteDataSource {
    static let instance = SignInRemoteDataSource()
    private let webService: WebService = .instance
    
    func login(request: SignInRequest, completion: @escaping (SignInResponse?, String?) -> Void) {
        webService.call(path: .login, body: request, method: .post) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(SignInResponse.self, from: data)
                completion(response, nil)
                break
                
            case .failure(let error, let data):
                print("ERROR: \(error)")

                guard let data = data else { return }
                
                switch error {
                case .unauthorized:
                    let response = try? JSONDecoder().decode(ResponseUnauthorized.self, from: data)
                    completion(nil, response?.detail.message)
                    break
                    
                default:
                    break
                }
                break
            }
        }
    }
}
