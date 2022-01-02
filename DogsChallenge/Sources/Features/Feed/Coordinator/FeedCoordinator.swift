import UIKit

class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var rootViewController: UIViewController?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedViewController = FeedViewController()
        let feedNavigation = UINavigationController(rootViewController: feedViewController)
        self.rootViewController = feedNavigation
    }
    
}
