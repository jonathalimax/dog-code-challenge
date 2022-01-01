import UIKit

enum TabBarItems {
    case feed
    case search
    
    var title: String {
        switch self {
        case .feed:
            return "Breeds"
        case .search:
            return "Search"
        }
    }
    
    var index: Int {
        switch self {
        case .feed:
            return 0
        case .search:
            return 1
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .feed:
            return UIImage(named: "list_icon")
        case .search:
            return UIImage(named: "search_icon")
        }
    }
    
    var item: UITabBarItem {
        let tabbarItem = UITabBarItem(title: title, image: icon, selectedImage: icon)
        return tabbarItem
    }
    
}
