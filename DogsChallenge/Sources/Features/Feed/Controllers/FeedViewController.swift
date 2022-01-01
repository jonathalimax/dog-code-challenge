import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, Breed>

enum FeedSection {
    case main
}

class FeedViewController: UIViewController {
    
    var feedView: FeedView
    var viewModel: FeedViewModel
    private lazy var dataSource = buildDataSource()
    
    init() {
        feedView = FeedView()
        viewModel = FeedViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Visualização",
                            style: .plain,
                            target: self,
                            action: #selector(updateCollectionLayout))
        ]
        
        feedView.collectionView.delegate = self
        feedView.collectionView.register(FeedItemViewCell.self,
                                         forCellWithReuseIdentifier: FeedItemViewCell.identifier)
        
        viewModel.fetchBreeds { [weak self] breeds in
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(breeds)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc
    func updateCollectionLayout() {
        feedView.updateCollectionLayout()
    }
    
}

extension FeedViewController {
    
    func buildDataSource() -> UICollectionViewDiffableDataSource<FeedSection, Breed> {
        
        return UICollectionViewDiffableDataSource(
            collectionView: feedView.collectionView,
            cellProvider: {  collectionView, indexPath, breed in
                
                guard let cell = collectionView
                        .dequeueReusableCell(withReuseIdentifier: FeedItemViewCell.identifier,
                                             for: indexPath) as? FeedItemViewCell else {
                    return nil
                }
                
                cell.bindData(with: breed)
                return cell
            }
        )
        
    }
    
}

extension FeedViewController: UICollectionViewDelegate {}
