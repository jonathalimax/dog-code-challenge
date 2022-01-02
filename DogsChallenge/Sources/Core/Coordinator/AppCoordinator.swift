import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow?
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init(window: UIWindow) {
        self.window = window
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.start()
        addChildCoordinator(tabBarCoordinator)
        rootViewController = tabBarCoordinator.rootViewController
    }
    
}
