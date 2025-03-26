import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainerProtocol

    init(navigationController: UINavigationController, container: DIContainerProtocol) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let mainCoordinator = container.makeMainCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
