import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State private var selectedTab: CustomTabBar.Tab = .home
    private let factory: MainViewFactory

    init(factory: MainViewFactory) {
        self.factory = factory
    }

    var body: some View {
        ZStack {
            contentView
            tabBarView
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
        switch selectedTab {
        case .home:
            homeView
        case .calculator:
            homeView
        case .stats:
            homeView
        case .settings:
            homeView
        }
    }

    @ViewBuilder
    var tabBarView: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: selectedTab)
        }
    }
}

#Preview {
    SettingsViewController()
}
