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
                    
                    sut.getBreeds(page: 1) { result in
                        switch result {
                        case let .success(response):
                            expect(response.data).to(beAnInstanceOf([Breed].self))
                            expect(response.data.count).toEventually(equal(2))
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
                        case let .success(response):
                            expect(response.data).toEventually(beAnInstanceOf([Breed].self))
                            expect(response.data.count).toEventually(equal(1))
                            expect(response.data.first?.name).toEventually(equal("Alapaha Blue Blood Bulldog"))
                        case .failure:
                            fail("Unexpected result case")
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
