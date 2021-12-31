import Alamofire
import Foundation

class TheDogApi: ApiClient {
    
    private var reachability: Reachability = Reachability()
    
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
