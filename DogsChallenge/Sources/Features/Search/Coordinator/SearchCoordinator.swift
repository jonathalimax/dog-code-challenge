import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var rootViewController: UIViewController?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        self.rootViewController = searchNavigation
    }
    
}
