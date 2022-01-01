import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, Breed>

enum FeedSection {
    case main
}

enum CollectionViewMode {
    case list
    case grid
}

class FeedViewController: UIViewController {
    
    var feedView: FeedView
    var viewModel: FeedViewModel
    private lazy var dataSource = buildDataSource()
    
    private var viewModeImage: UIImage? {
        switch viewMode {
        case .grid:
            return UIImage(named: "grid_icon")
        case .list:
            return UIImage(named: "list_icon")
        }
    }
    private var viewMode: CollectionViewMode
    private lazy var orderBarButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "sort_icon"),
                        style: .done,
                        target: nil,
                        action: nil)
    }()
    
    private lazy var viewModeBarButton: UIBarButtonItem = {
        UIBarButtonItem(image: viewModeImage,
                        style: .done,
                        target: self,
                        action: #selector(updateCollectionLayout))
    }()
    
    init() {
        viewMode = .list
        feedView = FeedView(collectionType: viewMode)
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
        title = TabBarItems.feed.title        
        feedView.collectionView.delegate = self

        navigationItem.rightBarButtonItems = [
            orderBarButton,
            viewModeBarButton
        ]
        
        viewModel.fetchBreeds { [weak self] breeds in
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(breeds)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
    @objc
    func updateCollectionLayout() {
        switch viewMode {
        case .list:
            viewMode = .grid
        case .grid:
            viewMode = .list
        }
        
        viewModeBarButton.image = viewModeImage
        feedView.updateCollectionLayout(viewMode)
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
