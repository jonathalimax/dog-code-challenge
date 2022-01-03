import Quick
import Nimble
import Foundation

@testable import DogsChallenge

class FeedViewModelSpec: QuickSpec {
    
    var sut: FeedViewModel!
    var apiMock: ApiClientMock!
    var breedService: BreedService!
    var breedStub: Breed!
    var breedsData: Data!
    var delegateMock: FeedViewModelDelegateMock!
    var coordinatorMock: FeedViewModelNavigationMock!
    
    override func spec() {
        
        describe("FeedViewModel") {
        
            beforeEach {
                self.breedStub = BreedStub.stub
                self.breedsData = JsonHelper.getData(fromFile: .breeds)
            }
            
            context("when fetch breeds is called") {
                
                context("with success result case") {
                
                    beforeEach {
                        self.setupScenario(for: .success(self.breedsData))
                        self.sut.fetchBreeds()
                    }
                    
                    it("should delegate response correctly") {
                        expect(self.delegateMock.onFetchCompletedCalled).toEventually(beTrue())
                        expect(self.delegateMock.response).toEventuallyNot(beNil())
                        expect(self.delegateMock.response?.data.count).toEventually(equal(2))
                    }
                    
                }
                
                context("with failure result case") {
                
                    beforeEach {
                        self.setupScenario(for: .failure(.notFound))
                        self.sut.fetchBreeds()
                    }
                    
                    it("should delegate correctly") {
                        expect(self.delegateMock.onFetchFailureCalled).toEventually(beTrue())
                        expect(self.delegateMock.response).toEventually(beNil())
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
            
            context("when order breeds method is called") {
                
                beforeEach {
                    self.setupScenario(for: .success(self.breedsData))
                    self.sut.fetchBreeds()
                }
                
                context("and order is ascendent") {
                    
                    beforeEach {
                        self.sut.orderBreeds()
                    }
                    
                    it("should order descendent and delegate correctly") {
                        expect(self.delegateMock.onFetchCompletedCalled).to(beTrue())
                        expect(self.delegateMock.response?.data.first?.name).toEventually(equal("Afghan Hound"))
                    }
                    
                }
                
                context("and order is ascendent") {
                    
                    beforeEach {
                        self.sut.orderBreeds()
                        self.sut.orderBreeds()
                    }
                    
                    it("should order descendent and delegate correctly") {
                        expect(self.delegateMock.onFetchCompletedCalled).to(beTrue())
                        expect(self.delegateMock.response).toEventuallyNot(beNil())
                        expect(self.delegateMock.response?.data.first?.name).toEventually(equal("Affenpinscher"))
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension FeedViewModelSpec {
    
    private func setupScenario(for result: ApiResultMock) {
        
        switch result {
        case .success:
            
            apiMock = ApiClientMock(resultMock: .success(breedsData))
            breedService = BreedService(api: apiMock)
            sut = FeedViewModel(service: breedService)
            delegateMock = FeedViewModelDelegateMock()
            coordinatorMock = FeedViewModelNavigationMock()
            sut.delegate = delegateMock
            sut.coordinator = coordinatorMock
            
        case .failure:
            
            apiMock = ApiClientMock(resultMock: .failure(.notFound))
            breedService = BreedService(api: apiMock)
            sut = FeedViewModel(service: breedService)
            delegateMock = FeedViewModelDelegateMock()
            coordinatorMock = FeedViewModelNavigationMock()
            sut.delegate = delegateMock
            sut.coordinator = coordinatorMock
            
        case .empty: break
        }
        
    }
    
}
