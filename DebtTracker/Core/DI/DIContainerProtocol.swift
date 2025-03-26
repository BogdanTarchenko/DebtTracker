import UIKit

@MainActor
protocol DIContainerProtocol {
    // Координаторы
    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator

    // Контроллеры
    func makeMainViewController() -> MainViewController
    func makeHomeViewController() -> HomeViewController
}
