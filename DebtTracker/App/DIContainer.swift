//
//  DIContainer.swift
//  DebtTracker
//
//  Created by Богдан Тарченко on 25.03.2025.
//

import UIKit

final class DIContainer: DIContainerProtocol {
    func makeMainViewController() -> UIViewController {
        let viewController = MainViewController()
        return viewController
    }
}
