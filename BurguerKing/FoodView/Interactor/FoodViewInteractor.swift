final class FoodViewInteractor {
    private let remoteDataSource: FoodViewRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension FoodViewInteractor {
    func fetch(
        id: Int,
        completion: @escaping (FoodViewResponse?, String?) -> Void
    ) {
        return remoteDataSource.fetch(id: id, completion: completion)
    }
}
