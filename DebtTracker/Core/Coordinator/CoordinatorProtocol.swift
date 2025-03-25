//
//  CoordinatorProtocol.swift
//  DebtTracker
//
//  Created by Богдан Тарченко on 25.03.2025.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
