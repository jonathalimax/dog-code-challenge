import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, Breed>

class FeedViewController: UIViewController {
    
    var feedView: FeedView
    var viewModel: FeedViewModelProtocol
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
                        target: self,
                        action: #selector(orderBreedsByName))
    }()
    
    private lazy var viewModeBarButton: UIBarButtonItem = {
        UIBarButtonItem(image: viewModeImage,
                        style: .done,
                        target: self,
                        action: #selector(updateCollectionLayout))
    }()
    
    private lazy var refreshControl = UIRefreshControl()
    
    init(_ viewModel: FeedViewModelProtocol) {
        viewMode = .grid
        feedView = FeedView(collectionType: viewMode)
        self.viewModel = viewModel
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
        
        refreshControl.addTarget(self,
                                 action: #selector(refreshCollection),
                                 for: .valueChanged)
        
        feedView.collectionView.refreshControl = refreshControl
        viewModel.fetchBreeds(loadingMore: false)
    }
    
}

extension FeedViewController {
    
    @objc
    private func refreshCollection() {
        viewModel.fetchBreeds(loadingMore: false)
    }
    
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
    
    @objc
    private func orderBreedsByName() {
        viewModel.orderBreeds()
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
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        guard let response = response else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(response.data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onFetchFailure() {}
    
}

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedBreed = viewModel.breedsResponse?.data[indexPath.row] else {
            return
        }
        viewModel.showBreedDetail(selectedBreed)
    }
    
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
