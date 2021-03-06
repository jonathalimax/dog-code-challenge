import Foundation
@testable import DogsChallenge

class ApiClientMock: ApiClientProtocol {
    
    var apiResultMock: ApiResultMock
    
    init(resultMock: ApiResultMock) {
        self.apiResultMock = resultMock
    }
    
    func requestDecodable<T>(route: ApiRouter,
                             callback: @escaping (Result<DataResponse<T>, ApiError>) -> Void) where T : Decodable {
        
        switch apiResultMock {
        case let .empty(data), let .success(data):
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                callback(.success(DataResponse(data: response, headers: nil)))
            } catch {
                callback(.failure(.invalidParse))
            }
            
        case let .failure(error):
            callback(.failure(error))
        }
    }
    
}
