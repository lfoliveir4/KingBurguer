import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

enum Endpoint: String {
    case createUser = "/users"
    case login = "/auth/login"
    case refreshToken = "/auth/refresh-token"
    case feed = "/feed"
    case highlight = "/highlight"
    case foodView = "/products/%d"
    case coupon = "/products/%d/coupon"
    case me = "/users/me"
}

enum NetworkError {
    case unauthorized
    case badRequest
    case notFound
    case internalError
    case unknown
}

enum Result {
    case success(Data?)
    case failure(NetworkError, Data?)
}

public final class WebService {
    static let instance = WebService()
    static let API_KEY = ""
    static let baseURL = ""
    private let localDataSource: LocalDataSource = .instance
    
    private func completeUrl(path: String) -> URLRequest? {
        let endpoint = "\(Self.baseURL)\(path)"
        guard let url = URL(string: endpoint) else {
            print("ERROR: URL \(endpoint) malformed!")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func makeRequest(
        path: String,
        body: Encodable?,
        method: HTTPMethod,
        completion: @escaping (Result) -> Void
    ) {
        do {
            guard var request = completeUrl(path: path) else { return }
            
            request.httpMethod = method.rawValue.uppercased()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue(Self.API_KEY, forHTTPHeaderField: "x-secret-key")
            
            if let accessToken = localDataSource.getUser()?.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            
            if let body {
                let jsonRequest = try JSONEncoder().encode(body)
                request.httpBody = jsonRequest
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(.failure(.internalError, data))
                    return
                }
                
                if let r = response as? HTTPURLResponse {
                    switch r.statusCode {
                    case 200:
                        completion(.success(data))
                        break
                    case 401:
                        completion(.failure(.unauthorized, data))
                        break
                    case 404:
                        completion(.failure(.notFound, data))
                        break
                    case 400:
                        completion(.failure(.badRequest, data))
                        break
                    case 500:
                        completion(.failure(.internalError, data))
                        break
                    default:
                        completion(.failure(.unknown, data))
                        break
                    }
                }
            }
            
            task.resume()
        } catch {
            print(error)
            return
        }
    }
    
    func call<R: Encodable>(
        path: Endpoint,
        body: R?,
        method: HTTPMethod,
        completion: @escaping (Result) -> Void
    ) {
        makeRequest(
            path: path.rawValue,
            body: body,
            method: method,
            completion: completion
        )
    }
    
    func call(
        path: String,
        method: HTTPMethod,
        completion: @escaping (Result) -> Void
    ) {
        makeRequest(
            path: path,
            body: nil,
            method: method,
            completion: completion
        )
    }
    
    public init () {}
}
