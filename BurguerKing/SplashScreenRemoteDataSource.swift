import Foundation

final class SplashScreenRemoteDataSource {
    static let instance = SplashScreenRemoteDataSource()
    let webService: WebService = .instance
    
    func login(
        request: SplashScreenRequest,
        accessToken: String,
        completion: @escaping (SignInResponse?, Bool) -> Void
    ) {
        webService.call(
            path: .refreshToken,
            body: request,
            method: .put
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(SignInResponse.self, from: data)
                completion(response, false)
                break
                
            case .failure:
                completion(nil, true)
                break
            }
        }
    }
}
