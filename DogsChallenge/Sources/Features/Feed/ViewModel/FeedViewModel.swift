import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func onFetchCompleted(response: DataResponse<[Breed]>?)
    func onFetchFailure()
}

protocol FeedViewModelProtocol {
    func fetchBreeds(loadingMore: Bool)
}

class FeedViewModel: FeedViewModelProtocol {
    
    public weak var delegate: FeedViewModelDelegate?
    
    private var service: BreedServiceProtocol
    private(set) var breedsResponse: DataResponse<[Breed]>?
    
    private var isLoading: Bool = false
    
    init(service: BreedServiceProtocol = BreedService()) {
        self.service = service
    }
    
    func fetchBreeds(loadingMore: Bool = false) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        let nextPage = loadingMore ? breedsResponse?.paginationNext ?? 1 : 1
        service.getBreeds(page: nextPage) { result in
            
            self.isLoading = false
            
            switch result {
            case let .success(response):
                if loadingMore && self.breedsResponse != nil {
                    self.breedsResponse?.data.append(contentsOf: response.data)
                    self.breedsResponse?.headers = response.headers
                } else {
                    self.breedsResponse = response
                }
                
                DispatchQueue.main.async {
                    self.delegate?.onFetchCompleted(response: self.breedsResponse)
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailure()
                }
            }
            
        }
        
    }
    
}
