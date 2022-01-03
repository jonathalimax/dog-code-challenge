import Quick
import Nimble
import Foundation
import SnapshotTesting
import UIKit

@testable import DogsChallenge

class SearchViewControllerSpec: QuickSpec {
    
    var navigation: UINavigationController!
    var sut: SearchViewController!
    var viewModel: SearchViewModel!
    var apiMock: ApiClientMock!
    var searchedBreeds: Data!
    
    override func spec() {
        
        describe("BreedDetailViewController") {
            
            beforeEach {
                self.searchedBreeds = JsonHelper.getData(fromFile: .breedsByName)
                self.apiMock = ApiClientMock(resultMock: .success(self.searchedBreeds))
                self.viewModel = SearchViewModel(service: BreedService(api: self.apiMock))
                self.sut = SearchViewController(self.viewModel)
                self.navigation = UINavigationController(rootViewController: self.sut)
                self.sut.viewDidLoad()
                self.viewModel.searchBreed(by: "Rottweiler")
            }
            
            context("when view controller finish loading") {
                
                it("should render layout correctly") {
                    assertSnapshot(matching: self.navigation, as: .image)
                }
                
            }
            
            context("when view controller finish loading") {
                
                beforeEach {
                    self.sut.onFetchCompleted(response: self.viewModel.breedsResponse)
                }
                
                it("should render layout correctly") {
                    assertSnapshot(matching: self.navigation, as: .image)
                }
                
            }
            
        }
        
    }
    
}
