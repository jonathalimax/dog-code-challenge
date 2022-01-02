import UIKit

typealias SearchSnapshot = NSDiffableDataSourceSnapshot<Int, Breed>

class SearchViewController: UIViewController {
    
    private var searchView: SearchView
    private var viewModel: SearchViewModelProtocol
    private lazy var dataSource = buildDataSource()
    
    private lazy var searchBarController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = "Search breeds"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    init(_ viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        self.searchView = SearchView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = searchView
        navigationItem.searchController = searchBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TabBarItems.search.title
        viewModel.delegate = self
        searchView.tableView.delegate = self
        setupTableView()
    }
    
}

extension SearchViewController {
    
    private func setupTableView() {
        var snapshot = SearchSnapshot()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func buildDataSource() -> UITableViewDiffableDataSource<Int, Breed> {
        
        return UITableViewDiffableDataSource(
            tableView: searchView.tableView,
            cellProvider: { tableView, indexPath, breed in
                
                guard let cell = tableView
                        .dequeueReusableCell(withIdentifier: SearchItemCell.identifier,
                                             for: indexPath) as? SearchItemCell else {
                    return nil
                }
                
                cell.textLabel?.text = breed.name
                
                return cell
            }
        )
        
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBreed = viewModel.breedsResponse?.data[indexPath.row] else {
            return
        }
        viewModel.showBreedDetail(selectedBreed)
    }
    
}

extension SearchViewController: SearchViewModelDelegate {
    
    func onFetchCompleted(response: DataResponse<[Breed]>?) {
        guard let response = response else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Breed>()
        snapshot.appendSections([0])
        snapshot.appendItems(response.data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onFetchFailure() {}
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchBreed(by: searchText)
    }
    
}
