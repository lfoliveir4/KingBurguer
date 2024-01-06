import Foundation

final class SignUpRemoteDataSource {
    static let instance = SignUpRemoteDataSource()
    private let webService: WebService = .instance
    
    func createUser(
        request: SignUpRequest,
        completion: @escaping (Bool?, String?) -> Void
    ) {
        webService.call(path: .createUser, body: request, method: .post) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                completion(true, nil)
                break
                
            case .failure(let error, let data):
                print("ERROR: \(error)")
                
                guard let data = data else { return }
                
                switch error {
                case .unauthorized:
                    let response = try? JSONDecoder().decode(ResponseUnauthorized.self, from: data)
                    completion(nil, response?.detail.message)
                    break
                    
                case .badRequest:
                    let response = try? JSONDecoder().decode(SignUpResponseError.self, from: data)
                    completion(nil, response?.detail)
                    break
                    
                default:
                    let response = try? JSONDecoder().decode(SignUpResponseError.self, from: data)
                    completion(nil, response?.detail)
                    break
                }
                break
            }
        }
    }
}
