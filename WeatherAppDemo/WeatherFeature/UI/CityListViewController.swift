import UIKit

protocol CityListViewControllerDelegate: class {
    func didTapCity(_ city: City)
}

class CityListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: CityListViewControllerDelegate?

    let searchController = UISearchController(searchResultsController: nil)

    var viewModel: CityListViewModel! {
        didSet {
            viewModel.cities = viewModel.getCities()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        searchController.searchResultsUpdater = self

        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "Search Cities"

        navigationItem.searchController = searchController

        definesPresentationContext = true

        searchController.searchBar.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        viewModel.processfilterCities(viewModel.cities, searchText: searchText.lowercased())
        tableView.reloadData()
    }
    
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            view.layoutIfNeeded()
            return
        }

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITableViewDataSource Conformance
extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city: City
        if isFiltering {
            city = viewModel.filteredCities[indexPath.row]
        } else {
            city = viewModel.cities[indexPath.row]
        }
        cell.textLabel?.text = city.name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredCities.count
        }
        return viewModel.cities.count
    }
}

// MARK: - UITableViewDelegate Conformance
extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city: City = isFiltering ? viewModel.filteredCities[indexPath.row] : viewModel.cities[indexPath.row]
        delegate?.didTapCity(city)
    }
}

// MARK: - UISearchResultsUpdating Conformance
extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: - UISearchBarDelegate Conformance
extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}
