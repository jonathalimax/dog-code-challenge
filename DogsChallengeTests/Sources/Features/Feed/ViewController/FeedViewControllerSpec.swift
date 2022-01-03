import Quick
import Nimble
import Foundation
import SnapshotTesting
import UIKit

@testable import DogsChallenge

class FeedViewControllerSpec: QuickSpec {
    
    var navigation: UINavigationController!
    var sut: FeedViewController!
    var viewModel: FeedViewModel!
    var apiMock: ApiClientMock!
    var breeds: Data!
    
    override func spec() {
        
        describe("FeedViewControllerSpec") {
            
            beforeEach {
                self.breeds = JsonHelper.getData(fromFile: .breeds)
                self.apiMock = ApiClientMock(resultMock: .success(self.breeds))
                self.viewModel = FeedViewModel(service: BreedService(api: self.apiMock))
                self.sut = FeedViewController(self.viewModel)
                self.navigation = UINavigationController(rootViewController: self.sut)
            }
            
            context("when view controller finish loading") {
                
                beforeEach {
                    self.sut.viewDidLoad()
                }
                
                it("should render layout correctly") {
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            done()
                        }
                    }
                    
                    assertSnapshot(matching: self.navigation, as: .image)
                    
                }
                
            }
            
        }
        
    }
    
}
