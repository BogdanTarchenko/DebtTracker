import SwiftUI
import UIKit

@MainActor
protocol MainViewFactory {
    func makeHomeView() -> HomeView
    func makeCalculatorView() -> CalculatorView
    func makeDebtDetailsViewController() -> DebtDetailsViewController
    func makeAddDebtViewController() -> AddDebtViewController
    func makeSettingsViewController() -> SettingsViewController
}
