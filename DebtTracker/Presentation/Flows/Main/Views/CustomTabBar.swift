import SwiftUI

// MARK: - CustomTabBar

struct CustomTabBar: View {
    // MARK: - Public Properties

    @State var selectedTab: Tab

    var body: some View {
        ZStack {
            tabBarBackground
            centerButton
        }
        .frame(height: Metrics.tabBarHeight)
    }
}

// MARK: - View Components

private extension CustomTabBar {
    @ViewBuilder
    var tabBarBackground: some View {
        HStack {
            tabButton(tab: .home, image: ImageAssets.home)

            Spacer()

            tabButton(tab: .calculator, image: ImageAssets.calculator)

            Spacer()

            Spacer().frame(width: Metrics.centerButtonWidth)

            Spacer()

            tabButton(tab: .stats, image: ImageAssets.stats)

            Spacer()

            tabButton(tab: .settings, image: ImageAssets.settings)
        }
        .frame(height: Metrics.backgroundHeight)
        .padding(.horizontal, 24)
        .background(Color(UIColor.App.black))
    }

    @ViewBuilder
    func tabButton(tab: Tab, image: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 24)
                .foregroundColor(
                    selectedTab == tab ? Color(UIColor.App.tabBarItemActive) :
                        Color(UIColor.App.tabBarItemInactive)
                )
        }
    }

    @ViewBuilder
    var centerButton: some View {
        Button(action: {}) {
            Image(systemName: ImageAssets.plus)
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color(UIColor.App.tabBarItemInactive))
        }
    }
}

// MARK: - Metrics & Image Assets

private extension CustomTabBar {
    enum Metrics {
        static let tabBarHeight: CGFloat = 64
        static let backgroundHeight: CGFloat = 64
        static let centerButtonWidth: CGFloat = 48
    }

    enum ImageAssets {
        static let home = "house"
        static let calculator = "percent.ar"
        static let stats = "chart.pie"
        static let settings = "gearshape"
        static let plus = "plus.app"
    }
}

#Preview {
    CustomTabBar(selectedTab: .home)
}
