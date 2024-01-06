final class CouponInteractor {
    private let remoteDataSource: CouponRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension CouponInteractor {
    func create(
        id: Int,
        completion: @escaping (CouponResponse?, String?) -> Void
    ) {
        remoteDataSource.create(id: id, completion: completion)
    }
}
