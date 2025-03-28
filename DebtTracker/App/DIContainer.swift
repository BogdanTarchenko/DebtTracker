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

    // MARK: - Views

    func makeMainView() -> MainView {
        let factory = DefaultMainViewFactory(container: self)
        return MainView(factory: factory)
    }

    func makeHomeView() -> HomeView {
        HomeView()
    }

    func makeCalculatorView() -> CalculatorView {
        CalculatorView()
    }

    func makeStatsView() -> StatsView {
        StatsView()
    }

    func makeDebtDetailsViewController() -> DebtDetailsViewController {
        DebtDetailsViewController()
    }

    func makeSettingsViewController() -> SettingsViewController {
        SettingsViewController()
    }

    func makePasswordSetupViewController() -> PasswordSetupViewController {
        PasswordSetupViewController()
    }

    func makeAddDebtViewController() -> AddDebtViewController {
        AddDebtViewController()
    }
}

// MARK: - DefaultMainViewFactory

private final class DefaultMainViewFactory: MainViewFactory {
    private let container: DIContainerProtocol

    init(container: DIContainerProtocol) {
        self.container = container
    }

    func makeHomeView() -> HomeView {
        container.makeHomeView()
    }

    func makeCalculatorView() -> CalculatorView {
        container.makeCalculatorView()
    }

    func makeStatsView() -> StatsView {
        container.makeStatsView()
    }

    func makeDebtDetailsViewController() -> DebtDetailsViewController {
        container.makeDebtDetailsViewController()
    }

    func makeSettingsViewController() -> SettingsViewController {
        container.makeSettingsViewController()
    }

    func makePasswordSetupViewController() -> PasswordSetupViewController {
        container.makePasswordSetupViewController()
    }

    func makeAddDebtViewController() -> AddDebtViewController {
        container.makeAddDebtViewController()
    }
}
