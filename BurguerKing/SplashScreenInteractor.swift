import Foundation

struct SplashScreenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

final class SplashScreenInteractor {
    private let remoteDataSource: SplashScreenRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension SplashScreenInteractor {
    func login(
        request: SplashScreenRequest,
        completion: @escaping (SignInResponse?, Bool) -> Void
    ) {
        guard let accessToken = localDataSource.getUser()?.accessToken else {
            completion(nil, true)
            return
        }
        
        remoteDataSource.login(request: request, accessToken: accessToken) { response, error in
            self.localDataSource.saveUser(user: .init(
                accessToken: response?.accessToken ?? "",
                refreshToken: response?.refreshToken ?? "",
                expiresSeconds: Int(Date().timeIntervalSince1970 + Double(response?.expiresSeconds ?? 0)),
                tokenType: response?.tokenType ?? ""
            ))
            completion(response, error)
        }
    }
}
