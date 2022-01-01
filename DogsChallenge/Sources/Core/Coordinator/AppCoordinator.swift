import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.start()
        addChildCoordinator(tabBarCoordinator)
        rootViewController = tabBarCoordinator.rootViewController
    }
}
