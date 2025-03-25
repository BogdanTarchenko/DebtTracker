//
//  SceneDelegate.swift
//  DebtTracker
//
//  Created by Богдан Тарченко on 25.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = ViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
