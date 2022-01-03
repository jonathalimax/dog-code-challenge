import Alamofire
import Foundation

struct DataResponse<T: Decodable> {
    var data: T
    var headers: HTTPHeaders?
    
    var paginationTotal: Int? {
        guard let total = headers?.value(for: "Pagination-Count") else {
            return nil
        }
        return Int(total)
    }
    
    var paginationLimit: Int? {
        guard let limit = headers?.value(for: "Pagination-Limit") else {
            return nil
        }
        return Int(limit)
    }
    
    var paginationPage: Int? {
        guard let limit = headers?.value(for: "Pagination-Page") else {
            return nil
        }
        return Int(limit)
    }
    
    var paginationNext: Int {
        guard let currentPage = paginationPage else {
            return 1
        }
        
        return currentPage + 1
    }
    
    var hasNexPage: Bool {
        guard let paginationTotal = paginationTotal else {
            return false
        }
        return paginationNext < paginationTotal
    }
}

protocol ApiClientProtocol {
    
    func requestDecodable<T: Decodable>(route: ApiRouter,
                                        callback: @escaping (Result<DataResponse<T>, ApiError>) -> Void)
    
}

class ApiClient: ApiClientProtocol {
    
    private var reachability: Reachability = Reachability()
    
    private init() {}
    
    static var shared: ApiClientProtocol = ApiClient()
    
    func requestDecodable<T: Decodable>(route: ApiRouter,
                                        callback: @escaping (Result<DataResponse<T>, ApiError>) -> Void) {
        
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
                        let dataResponse = DataResponse(data: parsed,
                                                        headers: data.response?.headers)
                        callback(.success(dataResponse))
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
