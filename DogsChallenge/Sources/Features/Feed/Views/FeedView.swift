import UIKit

class FeedView: UIView {
    
    init() {
        super.init(frame: .zero)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedView: ViewCodable {
    func addSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupAppearance() {
        backgroundColor = .red
    }
    
}
