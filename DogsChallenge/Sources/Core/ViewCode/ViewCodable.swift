import UIKit

protocol ViewCodable where Self: UIView {
    func buildViewCode()
    func addSubviews()
    func setupConstraints()
    func setupAppearance()
}

extension ViewCodable {
    func buildViewCode() {
        addSubviews()
        setupConstraints()
        setupAppearance()
    }
    
    func setupAppearance() {}
}
