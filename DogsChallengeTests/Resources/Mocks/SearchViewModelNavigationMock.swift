@testable import DogsChallenge

class SearchViewModelNavigationMock: SearchViewModelNavigation {
    
    var breedPassed: Breed? = nil
    var showBreedDetailCalled: Bool = false
    
    func searchViewModel(showBreedDetail breed: Breed) {
        self.breedPassed = breed
        self.showBreedDetailCalled = true
    }
    
}
