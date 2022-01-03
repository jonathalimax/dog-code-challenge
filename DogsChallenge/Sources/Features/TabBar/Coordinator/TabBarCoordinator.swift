import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
    }
    
    func start() {
        let screens: [TabBarItems] = [.feed, .search]
        let controllers = screens.compactMap { buildTabController($0) }
        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.selectedIndex = TabBarItems.feed.index
        navigationController.viewControllers = [tabBarController]
        rootViewController = tabBarController
    }
    
}

extension TabBarCoordinator {
    
    private func buildTabController(_ tabBarItem: TabBarItems) -> UIViewController? {
        switch tabBarItem {
        case .feed:
            
            let feedCoordinator = FeedCoordinator(navigationController)
            feedCoordinator.start()
            feedCoordinator.rootViewController?.tabBarItem = tabBarItem.item
            addChildCoordinator(feedCoordinator)
            return feedCoordinator.rootViewController
            
        case .search:
            
            let searchCoordinator = SearchCoordinator(navigationController)
            searchCoordinator.start()
            searchCoordinator.rootViewController?.tabBarItem = tabBarItem.item
            addChildCoordinator(searchCoordinator)
            return searchCoordinator.rootViewController
                        
        }
    }
    
}
