import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, Breed>

class FeedViewController: UIViewController {
    
    var feedView: FeedView
    var viewModel: FeedViewModel
    private lazy var dataSource = buildDataSource()
    
    private var viewMode: FeedViewMode
    
    private var viewModeImage: UIImage? {
        switch viewMode {
        case .grid:
            return UIImage(named: "list_icon")
        case .list:
            return UIImage(named: "grid_icon")
        }
    }
    
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
        viewMode = .grid
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
        viewModel.delegate = self
        feedView.collectionView.delegate = self
        
        navigationItem.rightBarButtonItems = [
            orderBarButton,
            viewModeBarButton
        ]
        
        viewModel.fetchBreeds()
    }
    
}

extension FeedViewController {
    
    @objc
    private func updateCollectionLayout() {
        switch viewMode {
        case .list:
            viewMode = .grid
        case .grid:
            viewMode = .list
        }
        
        viewModeBarButton.image = viewModeImage
        feedView.updateCollectionLayout(viewMode)
    }
    
    private func buildDataSource() -> UICollectionViewDiffableDataSource<FeedSection, Breed> {
        
        return UICollectionViewDiffableDataSource(
            collectionView: feedView.collectionView,
            cellProvider: { collectionView, indexPath, breed in
                
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

extension FeedViewController: FeedViewModelDelegate {
    
    func onFetchCompleted(response: DataResponse<[Breed]>?) {
        guard let response = response else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(response.data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onFetchFailure() {}
    
}

extension FeedViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let response = viewModel.breedsResponse else { return }
        
        let scrollHeight = scrollView.contentSize.height - scrollView.frame.size.height
        let reachedBottom = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= scrollHeight
        
        if reachedBottom && response.hasNexPage {
            viewModel.fetchBreeds(loadingMore: true)
        }
    }
    
}
