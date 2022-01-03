@testable import DogsChallenge

class FeedViewModelDelegateMock: FeedViewModelDelegate {
    
    var onFetchCompletedCalled: Bool = false
    var onFetchFailureCalled: Bool = false
    var response: DataResponse<[Breed]>? = nil
    
    func onFetchCompleted(response: DataResponse<[Breed]>?) {
        self.onFetchCompletedCalled = true
        self.response = response
    }
    
    func onFetchFailure() {
        self.onFetchFailureCalled = true
    }
    
}
