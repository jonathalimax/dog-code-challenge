@testable import DogsChallenge

class FeedViewModelNavigationMock: FeedViewModelNavigation {
    
    var breedPassed: Breed? = nil
    var showBreedDetailCalled: Bool = false
    
    func feedViewModel(showBreedDetail breed: Breed) {
        self.breedPassed = breed
        self.showBreedDetailCalled = true
    }
    
}
