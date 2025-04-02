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
        if KeychainService.hasPassword() {
            showPasswordVerification()
        } else {
            showMainView(animated: false)
        }
    }

    // MARK: - Password Flow

    private func showPasswordVerification() {
        let passwordVC = container.makePasswordInputViewController(
            mode: .verifyPassword,
            completion: { [weak self] in
                Task {
                    try await Task.sleep(for: .seconds(0.3))
                }
                self?.showMainView(animated: true)
            }
        )
        setRootViewController(passwordVC)
    }

    private func handlePasswordError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.showPasswordVerification()
        })
        navigationController.present(alert, animated: true)
    }

    // MARK: - Main Flow

    private func showMainView(animated: Bool) {
        let mainView = container.makeMainView()
        let hostingController = UIHostingController(rootView: mainView)
        setRootViewController(hostingController, animated: animated)
    }

    // MARK: - Helpers

    private func setRootViewController(_ viewController: UIViewController, animated: Bool = false) {
        if animated {
            UIView.transition(
                with: navigationController.view,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.navigationController.setViewControllers([viewController], animated: false)
                }
            )
        } else {
            navigationController.setViewControllers([viewController], animated: false)
        }
    }

    func childDidFinish(_ child: Coordinator?) {
        childCoordinators.removeAll { $0 === child }
    }
}
