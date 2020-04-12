import Foundation
import UIKit

class CityCoordinator: Coordinatable {

    var childCoordinators = [Coordinatable]()
    var rootViewController: UINavigationController!
    var cityViewController: CityListViewController!

    func start() {
        let cityViewController: CityListViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        self.cityViewController = cityViewController
        self.cityViewController.delegate = self
        self.cityViewController.viewModel = CityListViewModel()
        rootViewController = UINavigationController(rootViewController: cityViewController)
    }
}

// MARK: - CityListViewControllerDelegate Conformance
extension CityCoordinator: CityListViewControllerDelegate {
    func didTapCity(_ city: City) {
        let cityDetailVC: CityDetailViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        cityDetailVC.viewModel = CityDetailViewModel()
        cityDetailVC.cityID = city.id
        cityDetailVC.cityName = city.name
        rootViewController.pushViewController(cityDetailVC, animated: true)
    }
}
