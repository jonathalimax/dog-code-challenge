import UIKit

class FeedView: UIView {
    
    private var collectionViewMode: CollectionViewMode
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: buildCollectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(FeedItemViewCell.self,
                                forCellWithReuseIdentifier: FeedItemViewCell.identifier)
        return collectionView
    }()
    
    init(collectionType: CollectionViewMode) {
        self.collectionViewMode = collectionType
        super.init(frame: .zero)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedView: ViewCodable {
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: super.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: super.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: super.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: super.bottomAnchor)
        ])
    }
    
    func setupAppearance() {
        backgroundColor = .white
    }
    
}

extension FeedView {
    
    func updateCollectionLayout(_ viewMode: CollectionViewMode) {
        self.collectionViewMode = viewMode
        collectionView.setCollectionViewLayout(buildCollectionLayout(), animated: true)
    }
    
    private func buildCollectionLayout() -> UICollectionViewLayout {
        
        var groupCount: Int
        
        switch collectionViewMode {
        case .list:
            groupCount = 1
        case .grid:
            groupCount = 2
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
