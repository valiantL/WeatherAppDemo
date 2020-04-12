import Foundation
import UIKit

class AppCoordinator: Coordinatable {
    // MARK: - Properties
    var childCoordinators = [Coordinatable]()
    var window: UIWindow

    // MARK: - Inits
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Public Functions
    func start() {
        let coordinator = CityCoordinator()
        coordinator.start()
        addChildCoordinator(coordinator)
        self.window.rootViewController = coordinator.rootViewController
        self.window.makeKeyAndVisible()
    }
}
