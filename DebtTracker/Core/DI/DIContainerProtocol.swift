//
//  DIContainerProtocol.swift
//  DebtTracker
//
//  Created by Богдан Тарченко on 25.03.2025.
//

import UIKit

@MainActor
protocol DIContainerProtocol {
    func makeMainViewController() -> UIViewController
}
