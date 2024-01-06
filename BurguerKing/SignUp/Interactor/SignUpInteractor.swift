final class SignUpInteractor {
    private let remoteDataSource: SignUpRemoteDataSource = .instance
}

extension SignUpInteractor {
    func createUser(
        request: SignUpRequest,
        completion: @escaping (Bool?, String?) -> Void
    ) {
        remoteDataSource.createUser(request: request, completion: completion)
    }
}
