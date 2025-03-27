import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State private var selectedTab: CustomTabBar.Tab = .home
    @State private var isDebtPresented: Bool = false
    private let factory: MainViewFactory

    init(factory: MainViewFactory) {
        self.factory = factory
    }

    var body: some View {
        let addDebtView = AddDebtView(controller: factory.makeAddDebtViewController())
        ZStack {
            contentView
            tabBarView
        }
        .sheet(isPresented: $isDebtPresented) {
            addDebtView
        }
    }
}

// MARK: - View Components

private extension MainView {
    @ViewBuilder
    var contentView: some View {
        tabContent
    }

    @ViewBuilder
    var tabContent: some View {
        let homeView = factory.makeHomeView()
        let calculatorView = factory.makeCalculatorView()
        let settingsView = SettingsView(controller: factory.makeSettingsViewController())
        switch selectedTab {
        case .home:
            homeView
        case .calculator:
            calculatorView
        case .stats:
            homeView
        case .settings:
            settingsView
        }
    }

    @ViewBuilder
    var tabBarView: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: $selectedTab, isAddDebtPresented: $isDebtPresented)
        }
    }
}
