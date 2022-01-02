import UIKit

class BreedDetailViewController: UIViewController {
    
    private var viewModel: BreedDetailViewModel
    private var detailView: BreedDetailView
    
    init(viewModel: BreedDetailViewModel) {
        self.viewModel = viewModel
        detailView = BreedDetailView(breed: viewModel.breed)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
    }
    
}
