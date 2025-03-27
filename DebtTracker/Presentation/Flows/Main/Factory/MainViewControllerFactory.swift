import UIKit

@MainActor
protocol MainViewControllerFactory {
    func makeHomeViewController() -> UIViewController
    func makeDebtDetailsViewController() -> DebtDetailsViewController
}
