import UIKit

// MARK: - MainViewController

class MainViewController: UITabBarController {
    weak var coordinator: MainCoordinator?
    private let factory: MainViewControllerFactory

    init(
        factory: MainViewControllerFactory
    ) {
        self.factory = factory
        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    @available(
        *,
        unavailable
    )
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
    }
}

private extension MainViewController {
    func setupUI() {
        let appearance = UITabBarAppearance()
        appearance
            .configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.App.tabBar
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.App.tabBarItemActive
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.App.tabBarItemInactive

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.App.tabBarItemActive
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.App.tabBarItemInactive
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    func setupViewControllers() {
        let homeViewController1 = factory.makeDebtDetailsViewController()
        let homeViewController2 = factory.makeHomeViewController()
        let homeViewController3 = factory.makeHomeViewController()

        homeViewController1.tabBarItem = UITabBarItem(
            title: "Подробнее",
            image: UIImage(
                systemName: "house.fill"
            ),
            tag: 0
        )
        homeViewController2.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(
                systemName: "house.fill"
            ),
            tag: 1
        )
        homeViewController3.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(
                systemName: "house.fill"
            ),
            tag: 2
        )

        let viewControllers = [
            homeViewController1,
            homeViewController2,
            homeViewController3
        ]
        self.viewControllers = viewControllers
    }
}
