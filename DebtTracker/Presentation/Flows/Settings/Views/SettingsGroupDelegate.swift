@MainActor
protocol SettingsGroupDelegate: AnyObject {
    func hideButton()
    func showButton()
    func turnOffPassword(completion: @escaping () -> Void)
    func createPassword(completion: @escaping () -> Void)
}
