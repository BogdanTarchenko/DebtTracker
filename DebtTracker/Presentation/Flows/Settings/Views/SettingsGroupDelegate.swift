@MainActor
protocol SettingsGroupDelegate: AnyObject {
    func hideButton()
    func showButton()
    func turnOffPassword()
    func createPassword()
}
