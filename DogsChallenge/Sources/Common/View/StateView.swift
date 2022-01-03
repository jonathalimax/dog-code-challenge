import UIKit

enum ViewState {
    case error(title: String?, tryAgainCompletion: (() -> Void)?)
    case empty(title: String?)
    case success
    case loading
}

class StateView: UIView {
    
    private(set) var state: ViewState
    private var tryAgainCompletion: (() -> Void)?
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView()
        loaderView.isHidden = true
        loaderView.startAnimating()
        return loaderView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tentar novamente", for: .normal)
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(tryAgainButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancelar", for: .normal)
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(cancelButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    init(_ state: ViewState) {
        self.state = state
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateState(_ state: ViewState) {
        self.state = state
        
        switch state {
        case let .error(title, completion):
            self.tryAgainCompletion = completion
            titleLabel.text = title ?? "Algo inesperado aconteceu!"
            loaderView.isHidden = true
            titleLabel.isHidden = false
            tryAgainButton.isHidden = false
            cancelButton.isHidden = false
        case .loading:
            loaderView.isHidden = false
            titleLabel.isHidden = true
            tryAgainButton.isHidden = true
            cancelButton.isHidden = true
        case let .empty(title):
            titleLabel.text = title ?? "Não há dados disponíveis!"
            loaderView.isHidden = true
            titleLabel.isHidden = false
            tryAgainButton.isHidden = true
            cancelButton.isHidden = true
        case .success: break
        }
        
        self.layoutIfNeeded()
    }
    
    @objc
    private func tryAgainButtonAction() {
        tryAgainCompletion?()
    }
    
    @objc
    private func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
}

extension StateView: ViewCodable {
    
    func addSubviews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(loaderView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(tryAgainButton)
        contentStack.addArrangedSubview(cancelButton)
    }
    
    func setupConstraints() {
        let spacing = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStack.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor,
                                                  constant: spacing),
            contentStack.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor,
                                                   constant: -spacing),
        ])
    }
    
    func setupAppearance() {
        backgroundColor = .white
    }
    
}

