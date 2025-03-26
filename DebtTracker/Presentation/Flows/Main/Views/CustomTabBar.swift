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
            Spacer()

            tabButton(tab: .home, image: ImageAssets.home)

            Spacer()

            tabButton(tab: .calculator, image: ImageAssets.calculator)

            Spacer()

            Spacer().frame(width: Metrics.centerButtonWidth)

            Spacer()

            tabButton(tab: .stats, image: ImageAssets.stats)

            Spacer()

            tabButton(tab: .settings, image: ImageAssets.settings)

            Spacer()
        }
        .frame(height: Metrics.backgroundHeight)
        .background(Color(UIColor.App.black))
        .cornerRadius(Metrics.backgroundCornerRadius)
        .padding(.horizontal)
        .padding(.bottom, Metrics.backgroundBottomPadding)
    }

    @ViewBuilder
    func tabButton(tab: Tab, image: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(image)
                .renderingMode(.template)
                .foregroundColor(
                    selectedTab == tab ? Color(UIColor.App.tabBarItemActive) :
                        Color(UIColor.App.tabBarItemInactive)
                )
        }
    }

    @ViewBuilder
    var centerButton: some View {
        Button(action: {}) {
            Circle()
                .foregroundColor(Color(UIColor.App.tabBarItemActive))
                .frame(width: Metrics.centerButtonWidth, height: Metrics.centerButtonWidth)
                .overlay(
                    Image(ImageAssets.plus)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(UIColor.App.white))
                )
        }
        .offset(y: Metrics.centerButtonOffset)
    }
}

// MARK: - Metrics & Image Assets

private extension CustomTabBar {
    enum Metrics {
        static let tabBarHeight: CGFloat = 80
        static let backgroundHeight: CGFloat = 64
        static let backgroundCornerRadius: CGFloat = 16
        static let backgroundBottomPadding: CGFloat = 16
        static let centerButtonWidth: CGFloat = 80
        static let centerButtonOffset: CGFloat = -8
    }

    enum ImageAssets {
        static let home = "Home"
        static let calculator = "Calculator"
        static let stats = "Stats"
        static let settings = "Settings"
        static let plus = "Plus"
    }
}

#Preview {
    CustomTabBar(selectedTab: .home)
}
