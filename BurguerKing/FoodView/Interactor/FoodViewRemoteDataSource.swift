import Foundation

final class FoodViewRemoteDataSource {
    static let instance = FoodViewRemoteDataSource()
    private let webService: WebService = .instance
    
    func fetch(
        id: Int,
        completion: @escaping (FoodViewResponse?, String?) -> Void
    ) {
        let path = String(format: Endpoint.foodView.rawValue, id)
        
        webService.call(
            path: path,
            method: .get
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(FoodViewResponse.self, from: data)
                completion(response, nil)
                
            case .failure(let error, let data):
                guard let data = data else { return }
                print("error on fetch product \(error)")
                print("error on fetch product data \(data)")
            }
        }
    }
}
