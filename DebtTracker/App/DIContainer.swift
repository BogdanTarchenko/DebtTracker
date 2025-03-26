import UIKit

// MARK: - DIContainer

final class DIContainer: DIContainerProtocol {
    // MARK: - Coordinators

    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController, container: self)
    }

    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        MainCoordinator(navigationController: navigationController, container: self)
    }

    // MARK: - ViewControllers

    func makeMainViewController() -> MainViewController {
        let factory = DefaultMainViewControllerFactory(container: self)
        return MainViewController(factory: factory)
    }

    func makeHomeViewController() -> HomeViewController {
        HomeViewController()
    }
}

// MARK: - DefaultMainViewControllerFactory

private final class DefaultMainViewControllerFactory: MainViewControllerFactory {
    private let container: DIContainerProtocol

    init(container: DIContainerProtocol) {
        self.container = container
    }

    func makeHomeViewController() -> UIViewController {
        container.makeHomeViewController()
    }

    func makeDebtDetailsViewController() -> UIViewController {
        let debtDetailsViewController = DebtDetailsViewController()
        return debtDetailsViewController
    }
}
