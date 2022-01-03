import Foundation

@testable import DogsChallenge

enum ApiResultMock {
    case empty(Data)
    case success(Data)
    case failure(ApiError)
}
