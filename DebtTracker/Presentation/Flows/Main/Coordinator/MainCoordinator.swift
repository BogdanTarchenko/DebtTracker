import SwiftUI
import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainerProtocol

    init(navigationController: UINavigationController, container: DIContainerProtocol) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let mainView = container.makeMainView()

        let hostingController = UIHostingController(rootView: mainView)

        navigationController.pushViewController(hostingController, animated: false)
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
