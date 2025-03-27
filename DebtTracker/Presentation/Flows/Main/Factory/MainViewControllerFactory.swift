import SwiftUI
import UIKit

@MainActor
protocol MainViewFactory {
    func makeHomeView() -> HomeView
    func makeDebtDetailsViewController() -> DebtDetailsViewController
}
