import Foundation

final class SignInInteractor {
    let remoteDataSource: SignInRemoteDataSource = .instance
    let localDataSource: LocalDataSource = .instance
}

extension SignInInteractor {
    func login(
        request: SignInRequest,
        completion: @escaping (SignInResponse?, String?) -> Void
    ) {
        remoteDataSource.login(request: request) { response, error in
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
