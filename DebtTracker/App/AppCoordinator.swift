//
//  AppCoordinator.swift
//  DebtTracker
//
//  Created by Богдан Тарченко on 25.03.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let diContainer: DIContainer
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let viewController = diContainer.makeMainViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
