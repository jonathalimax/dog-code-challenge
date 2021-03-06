import Alamofire
import Foundation

enum TheDogApiRouter: ApiRouter {
    
    case getBreeds(page: Int)
    case searchBreeds(breed: String)
    
    var baseUrl: String {
        Environment.baseUrl.value
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("x-api-key", forHTTPHeaderField: Environment.apiKey.value)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

extension TheDogApiRouter {
    
    private var method: HTTPMethod {
        switch self {
        case .getBreeds:
            return .get
        case .searchBreeds:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getBreeds:
            return "breeds"
        case .searchBreeds:
            return "breeds/search"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case let .getBreeds(page):
            return [
                "page": page,
                "limit": ApiConstants.dataResponseLimit
            ]
        case let .searchBreeds(breed):
            return ["q": breed]
        }
    }
    
}
