import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var rootViewController: UIViewController?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel)
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        self.rootViewController = searchNavigation
        viewModel.coordinator = self
    }
    
    private func showDetail(_ breed: Breed) {
        let viewModel = BreedDetailViewModel(breed: breed)
        let breedDetailViewController = BreedDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(breedDetailViewController, animated: true)
    }
    
}


extension SearchCoordinator: SearchViewModelNavigation {
    
    func searchViewModel(showBreedDetail breed: Breed) {
        showDetail(breed)
    }
    
}
