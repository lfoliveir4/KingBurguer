final class ProfileInteractor {
    private let remoteDataSource: ProfileRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension ProfileInteractor {
    func fetch(completion: @escaping (ProfileResponse?, String?) -> Void) {
        remoteDataSource.fetch(completion: completion)
    }
}
