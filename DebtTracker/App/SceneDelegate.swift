import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let diContainer = DIContainer()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let navigationController = UINavigationController()

        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        appCoordinator?.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
