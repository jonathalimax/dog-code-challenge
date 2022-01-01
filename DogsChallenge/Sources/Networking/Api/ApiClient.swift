import Alamofire
import Foundation

protocol ApiClientProtocol {
    
    func requestDecodable<T: Decodable>(route: ApiRouter,
                                        callback: @escaping (Result<T, ApiError>) -> Void)
    
}

class ApiClient: ApiClientProtocol {
    
    private var reachability: Reachability = Reachability()
    
    private init() {}
    
    static var shared: ApiClientProtocol = ApiClient()
    
    func requestDecodable<T: Decodable>(route: ApiRouter,
                                        callback: @escaping (Result<T, ApiError>) -> Void) {
        
        if !reachability.isReachable() {
            callback(.failure(.noInternetConnection))
            return
        }
        
        AF.request(route)
            .validate(statusCode: 200..<300)
            .responseData { data in
                
                switch data.result {
                case let .success(response):
                    
                    do {
                        let parsed = try JSONDecoder().decode(T.self, from: response)
                        callback(.success(parsed))
                    } catch {
                        print(error)
                        callback(.failure(.invalidParse))
                    }
                    
                case let .failure(error):
                    print(error.localizedDescription)
                    callback(.failure(.internalServerError))
                    return
                }
                
            }
    }
    
}
