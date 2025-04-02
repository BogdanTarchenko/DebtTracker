import SwiftUI
import UIKit

@MainActor
protocol MainViewFactory {
    func makeHomeView() -> HomeView
    func makeCalculatorView() -> CalculatorView
    func makeStatsView() -> StatsView
    func makeDebtDetailsViewController(credit: CreditModel) -> DebtDetailsViewController
    func makeAddDebtViewController() -> AddDebtViewController
    func makeSettingsViewController() -> SettingsViewController
}
