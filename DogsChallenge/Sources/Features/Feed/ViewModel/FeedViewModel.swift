typealias FetchingBreedsCompletion = (([Breed]) -> Void)?

class FeedViewModel {
    
    var breeds: [Breed] = []
    var service: BreedServiceProtocol
    
    init(service: BreedServiceProtocol = BreedService()) {
        self.service = service
    }
    
    func fetchBreeds(completion: FetchingBreedsCompletion) {
        
        service.getBreeds { result in
            
            switch result {
            case let .success(breeds):
                self.breeds = breeds
                completion?(breeds)
            case .failure:
                break
            }
            
        }
        
    }
    
}
