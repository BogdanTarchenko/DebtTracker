import UIKit

@MainActor
protocol DIContainerProtocol {
    // Coordinators
    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator

    // Views
    func makeMainView() -> MainView
    func makeHomeView() -> HomeView
    func makeCalculatorView() -> CalculatorView
    func makeStatsView() -> StatsView
    func makeDebtDetailsViewController(credit: CreditModel) -> DebtDetailsViewController
    func makeSettingsViewController() -> SettingsViewController
    func makeAddDebtViewController() -> AddDebtViewController
    func makePasswordInputViewController(mode: PasswordInputMode, completion: (() -> Void)?)
        -> PasswordInputViewController
}
