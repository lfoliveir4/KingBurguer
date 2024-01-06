final class FeedInteractor {
    private let remoteDataSource: FeedRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension FeedInteractor {
    func fetch(completion: @escaping (FeedResponse?, String?) -> Void) {
        remoteDataSource.fetch(completion: completion)
    }
    
    func fetch(completion: @escaping (HighlightResponse?, String?) -> Void) {
        remoteDataSource.fetch(completion: completion)
    }
    
    func logout() {
        localDataSource.logout()
    }
}
