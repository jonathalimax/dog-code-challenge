import Alamofire

protocol ApiClient {
    
    func requestDecodable<T: Decodable>(route: ApiRouter,
                                        callback: @escaping (Result<T, ApiError>) -> Void)
    
}
