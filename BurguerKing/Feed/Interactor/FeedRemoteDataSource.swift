import Foundation

struct FeedRequest: Encodable {}

final class FeedRemoteDataSource {
    static let instance = FeedRemoteDataSource()
    private let webService: WebService = .instance
    
    func fetch(completion: @escaping (FeedResponse?, String?) -> Void) {
        webService.call(
            path: .feed,
            body: Optional<FeedRequest>.none,
            method: .get
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(FeedResponse.self, from: data)
                completion(response, nil)
                break
                
            case .failure(let error, let data):
                guard let data = data else { return }
                debugPrint("error is \(error)")
                debugPrint("error on data is \(data)")
            }
        }
    }
    
    func fetch(completion: @escaping (HighlightResponse?, String?) -> Void) {
        webService.call(
            path: .highlight,
            body: Optional<FeedRequest>.none,
            method: .get
        ) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(HighlightResponse.self, from: data)
                completion(response, nil)
                break
                
            case .failure(let error, let data):
                guard let data = data else { return }
                debugPrint("error is \(error)")
                debugPrint("error on data is \(data)")
            }
        }
    }
}
