import Quick
import Nimble
import SnapshotTesting

@testable import DogsChallenge

class BreedDetailViewControllerSpec: QuickSpec {
    
    var sut: BreedDetailViewController!
    var viewModel: BreedDetailViewModel!
    
    override func spec() {
        
        describe("BreedDetailViewController") {
            
            beforeEach {
                self.viewModel = BreedDetailViewModel(breed: BreedStub.stub)
                self.sut = BreedDetailViewController(viewModel: self.viewModel)
            }
            
            context("when view controller finish loading") {
                
                it("should render layout correctly") {
                    assertSnapshot(matching: self.sut, as: .image)
                }
                
            }
            
        }
        
    }
    
}
