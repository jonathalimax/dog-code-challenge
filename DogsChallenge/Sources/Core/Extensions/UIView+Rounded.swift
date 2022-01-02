import UIKit

extension UIView {
    
    func round(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}
