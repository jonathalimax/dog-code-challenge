import UIKit

class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var rootViewController: UIViewController?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedViewModel = FeedViewModel()
        let feedViewController = FeedViewController(feedViewModel)
        let feedNavigation = UINavigationController(rootViewController: feedViewController)
        self.rootViewController = feedNavigation
        feedViewModel.coordinator = self
    }
    
    private func showDetail(_ breed: Breed) {
        let viewModel = BreedDetailViewModel(breed: breed)
        let breedDetailViewController = BreedDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(breedDetailViewController, animated: true)
    }
    
}


extension FeedCoordinator: FeedViewModelNavigation {
    
    func feedViewModel(showBreedDetail breed: Breed) {
        showDetail(breed)
    }
    
}
