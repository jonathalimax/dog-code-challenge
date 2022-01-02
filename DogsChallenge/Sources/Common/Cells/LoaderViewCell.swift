import UIKit

class LoaderViewCell: UICollectionViewCell, Reusable {
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        loaderView.startAnimating()
    }
    
    func stopLoading() {
        loaderView.stopAnimating()
    }
    
}

extension LoaderViewCell: ViewCodable {
    
    func addSubviews() {
        contentView.addSubview(loaderView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
