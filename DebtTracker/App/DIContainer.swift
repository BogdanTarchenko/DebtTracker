import UIKit

final class DIContainer: DIContainerProtocol {
    func makeMainViewController() -> UIViewController {
        let viewController = MainViewController()
        return viewController
    }

    func makeDebtDetailsViewController() -> UIViewController {
        let debtDetailsViewController = DebtDetailsViewController()
        return debtDetailsViewController
    }
}
