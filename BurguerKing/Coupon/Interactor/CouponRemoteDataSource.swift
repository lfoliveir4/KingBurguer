import Foundation

final class CouponRemoteDataSource {
    static let instance = CouponRemoteDataSource()
    private let webService: WebService = .instance
    
    func create(
        id: Int,
        completion: @escaping (CouponResponse?, String?) -> Void
    ) {
        let path = String(format: Endpoint.coupon.rawValue, id)
        
        webService.call(
            path: path,
            method: .post
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(CouponResponse.self, from: data)
                completion(response, nil)
                break
                
            case .failure(let error, let data):
                guard let data = data else { return }
                print("error on fetch create coupon \(error)")
                print("error on fetch product create coupon data \(data)")
            }
        }
    }
}
