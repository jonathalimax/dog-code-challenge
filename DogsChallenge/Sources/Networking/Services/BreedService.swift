typealias BreedsResultType = (Result<[Breed], ApiError>) -> Void

protocol BreedServiceProtocol {
    func getBreeds(_ callback: @escaping BreedsResultType)
    func searchBreed(by name: String, _ callback: @escaping BreedsResultType)
}

class BreedService: BreedServiceProtocol {
    
    private(set) var api: ApiClientProtocol
    
    init(api: ApiClientProtocol = ApiClient.shared) {
        self.api = api
    }
    
    func getBreeds(_ callback: @escaping BreedsResultType) {
        api.requestDecodable(route: TheDogApiRouter.getBreeds,
                             callback: callback)
    }
    
    func searchBreed(by name: String, _ callback: @escaping BreedsResultType) {
        api.requestDecodable(route: TheDogApiRouter.searchBreeds(breed: name),
                             callback: callback)
    }
    
}
