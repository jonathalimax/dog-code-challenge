enum ApiError: Error {
    case forbidden
    case notFound
    case invalidParse
    case internalServerError
    case noInternetConnection
}
