import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted(response: DataResponse<[Breed]>?)
    func onFetchFailure()
}

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    func searchBreed(by name: String)
}

class SearchViewModel: SearchViewModelProtocol {
    
    weak var delegate: SearchViewModelDelegate?
    
    private var service: BreedServiceProtocol
    private(set) var breedsResponse: DataResponse<[Breed]>?
    
    init(service: BreedServiceProtocol = BreedService()) {
        self.service = service
    }
    
    func searchBreed(by name: String) {
        service.searchBreed(by: name) { result in
            switch result {
            case let .success(response):
                self.breedsResponse = response
                
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
