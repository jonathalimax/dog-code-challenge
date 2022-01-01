import Quick
import Nimble
import Foundation

@testable import DogsChallenge

class BreedServiceSpec: QuickSpec {
    
    override func spec() {
        
        var sut: BreedService!
        var apiMock: ApiClientProtocol!
        var breedsData: Data!
        var breedsByNameData: Data!
        
        beforeEach {
            breedsData = JsonHelper.getData(fromFile: .breeds)
            breedsByNameData = JsonHelper.getData(fromFile: .breedsByName)
        }
        
        describe("BreedService") {
            
            context("when initialized") {
                
                beforeEach {
                    apiMock = ApiClientMock(resultMock: .empty(Data()))
                    sut = BreedService(api: apiMock)
                }
                
                it("must set the api passed") {
                    expect(sut.api).to(beIdenticalTo(apiMock))
                }
            }
            
            context("when receiving breeds result from the API") {
                
                beforeEach {
                    apiMock = ApiClientMock(resultMock: .success(breedsData))
                    sut = BreedService(api: apiMock)
                }
                
                it("must return the breeds on the callback") {
                    
                    sut.getBreeds { result in
                        switch result {
                        case let .success(breeds):
                            expect(breeds).to(beAnInstanceOf([Breed].self))
                            expect(breeds.count).toEventually(equal(2))
                        case .failure:
                            fail("Unexpected result case")
                        }
                    }
                    
                }
                
            }
            
            context("when receiving a breeds searched by name result from the API") {
                
                beforeEach {
                    apiMock = ApiClientMock(resultMock: .success(breedsByNameData))
                    sut = BreedService(api: apiMock)
                }
                
                it("must return the breeds on the callback") {
                    
                    sut.searchBreed(by: "Bulldog") { result in
                        switch result {
                        case let .success(breeds):
                            expect(breeds).toEventually(beAnInstanceOf([Breed].self))
                            expect(breeds.count).toEventually(equal(1))
                            expect(breeds.first?.name).toEventually(equal("Alapaha Blue Blood Bulldog"))
                        case .failure:
                            fail("Unexpected result case")
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
