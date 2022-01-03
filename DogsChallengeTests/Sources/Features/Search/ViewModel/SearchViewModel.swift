import Quick
import Nimble
import Foundation

@testable import DogsChallenge

class SearchViewModelSpec: QuickSpec {
    
    var sut: SearchViewModel!
    var apiMock: ApiClientMock!
    var breedService: BreedService!
    var breedStub: Breed!
    var breedsData: Data!
    var delegateMock: SearchViewModelDelegateMock!
    var coordinatorMock: SearchViewModelNavigationMock!
    
    override func spec() {
        
        describe("SearchViewModel") {
            
            beforeEach {
                self.breedStub = BreedStub.stub
                self.breedsData = JsonHelper.getData(fromFile: .breedsByName)
            }
            
            context("when search breed by name is called") {
                
                context("with success result case") {
                    
                    beforeEach {
                        self.setupScenario(for: .success(self.breedsData))
                        self.sut.searchBreed(by: "Bulldog")
                    }
                    
                    it("should return the searched response and delegate correctly") {
                        expect(self.delegateMock.onFetchCompletedCalled).toEventually(beTrue())
                        expect(self.delegateMock.response).toEventuallyNot(beNil())
                        expect(self.delegateMock.response?.data.count).toEventually(equal(1))
                    }
                    
                }
                
                context("with failure result case") {
                    
                    beforeEach {
                        self.setupScenario(for: .failure(.internalServerError))
                        self.sut.searchBreed(by: "Bulldog")
                    }
                    
                    it("should delegate failure correctly") {
                        expect(self.delegateMock.onFetchFailureCalled).toEventually(beTrue())
                    }
                    
                }
                
            }
            
            context("when show detail method is called") {
                
                beforeEach {
                    self.setupScenario(for: .success(self.breedsData))
                    self.sut.showBreedDetail(self.breedStub)
                }
                
                it("should delegate navigation") {
                    expect(self.coordinatorMock.showBreedDetailCalled).to(beTrue())
                    expect(self.coordinatorMock.breedPassed).toNot(beNil())
                    expect(self.coordinatorMock.breedPassed?.name).to(equal("Rottweiler"))
                }
                
            }
            
        }
        
    }
    
}

extension SearchViewModelSpec {
    
    private func setupScenario(for result: ApiResultMock) {
        
        switch result {
        case .success:
            
            apiMock = ApiClientMock(resultMock: .success(breedsData))
            breedService = BreedService(api: apiMock)
            sut = SearchViewModel(service: breedService)
            delegateMock = SearchViewModelDelegateMock()
            coordinatorMock = SearchViewModelNavigationMock()
            sut.delegate = delegateMock
            sut.coordinator = coordinatorMock
            
        case .failure:
            
            apiMock = ApiClientMock(resultMock: .failure(.notFound))
            breedService = BreedService(api: apiMock)
            sut = SearchViewModel(service: breedService)
            delegateMock = SearchViewModelDelegateMock()
            coordinatorMock = SearchViewModelNavigationMock()
            sut.delegate = delegateMock
            sut.coordinator = coordinatorMock
            
        case .empty: break
        }
        
    }
    
}
