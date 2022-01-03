import UIKit

class BreedDetailView: UIView {
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category:"
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var originTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Origin:"
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var originLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var temperamentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperament:"
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var temperamentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    init(breed: Breed) {
        super.init(frame: .zero)
        buildViewCode()
        bind(breed)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ breed: Breed) {
        let emptyString = "-"
        nameLabel.text = breed.name
        categoryLabel.text = breed.breedGroup ?? emptyString
        originLabel.text = breed.origin ?? emptyString
        temperamentLabel.text = breed.temperament ?? "-"
    }
    
}

extension BreedDetailView: ViewCodable {
    
    func addSubviews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(nameTitleLabel)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(categoryTitleLabel)
        contentStack.addArrangedSubview(categoryLabel)
        contentStack.addArrangedSubview(originTitleLabel)
        contentStack.addArrangedSubview(originLabel)
        contentStack.addArrangedSubview(temperamentTitleLabel)
        contentStack.addArrangedSubview(temperamentLabel)
    }
    
    func setupConstraints() {
        let stackSpacing = CGFloat(18)
        let marginSpacing = CGFloat(18)
        let margins = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: marginSpacing),
            contentStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: marginSpacing),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -marginSpacing),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor, constant: -marginSpacing)
        ])
        
        contentStack.setCustomSpacing(stackSpacing, after: nameLabel)
        contentStack.setCustomSpacing(stackSpacing, after: categoryLabel)
        contentStack.setCustomSpacing(stackSpacing, after: originLabel)
        contentStack.setCustomSpacing(stackSpacing, after: temperamentLabel)
    }
    
    func setupAppearance() {
        backgroundColor = .white
    }
    
}
