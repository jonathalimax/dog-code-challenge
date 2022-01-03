@testable import DogsChallenge

class SearchViewModelDelegateMock: SearchViewModelDelegate {
    
    var response: DataResponse<[Breed]>? = nil
    var onFetchCompletedCalled: Bool = false
    var onFetchFailureCalled: Bool = false
    
    func onFetchCompleted(response: DataResponse<[Breed]>?) {
        self.response = response
        self.onFetchCompletedCalled = true
    }
    
    func onFetchFailure() {
        self.onFetchFailureCalled = true
    }
    
}
