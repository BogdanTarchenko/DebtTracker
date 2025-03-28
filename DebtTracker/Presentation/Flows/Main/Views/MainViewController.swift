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
        let addDebtView = AddDebtView()
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
        let statsView = factory.makeStatsView()
        let settingsView = SettingsView(controller: factory.makeSettingsViewController())
        switch selectedTab {
        case .home:
            homeView
        case .calculator:
            calculatorView
        case .stats:
            statsView
        case .settings:
            settingsView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(LocalizedKey.Settings.title)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .toolbarBackground(Color(UIColor.App.black), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
