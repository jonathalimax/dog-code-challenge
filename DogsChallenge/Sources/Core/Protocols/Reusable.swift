import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable where Self: UIView {
    
    static var identifier: String {
        return NSStringFromClass(self)
    }

}
