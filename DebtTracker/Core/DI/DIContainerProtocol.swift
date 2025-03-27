import UIKit

@MainActor
protocol DIContainerProtocol {
    // Coordinators
    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator

    // Views
    func makeMainView() -> MainView
    func makeHomeView() -> HomeView
    func makeDebtDetailsViewController() -> DebtDetailsViewController
}
