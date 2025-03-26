import UIKit

@MainActor
protocol DIContainerProtocol {
    func makeMainViewController() -> UIViewController
}
