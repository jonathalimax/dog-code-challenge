import UIKit
import Kingfisher

class FeedItemViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.round(withRadius: 6)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func bindData(with breed: Breed) {
        titleLabel.text = breed.name
        if let image = breed.image {
            imageView.kf.setImage(with: URL(string: image.url))
        }
    }
    
}

extension FeedItemViewCell: ViewCodable, Reusable {
    
    func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        let edges: CGFloat = 8
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edges),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: edges),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edges),
            imageView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -edges),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edges),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edges),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edges),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
    }
    
}
