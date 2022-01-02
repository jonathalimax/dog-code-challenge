import Foundation

protocol FeedViewModelNavigation: AnyObject {
    func feedViewModel(showBreedDetail breed: Breed)
}

protocol FeedViewModelDelegate: AnyObject {
    func onFetchCompleted(response: DataResponse<[Breed]>?)
    func onFetchFailure()
}

protocol FeedViewModelProtocol {
    var delegate: FeedViewModelDelegate? { get set }
    var coordinator: FeedViewModelNavigation? { get set }
    var breedsResponse: DataResponse<[Breed]>? { get }
    func fetchBreeds(loadingMore: Bool)
    func showBreedDetail(_ breed: Breed)
}

class FeedViewModel: FeedViewModelProtocol {
    
    public weak var delegate: FeedViewModelDelegate?
    public weak var coordinator: FeedViewModelNavigation?
    
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
    
    func showBreedDetail(_ breed: Breed) {
        coordinator?.feedViewModel(showBreedDetail: breed)
    }
    
}
