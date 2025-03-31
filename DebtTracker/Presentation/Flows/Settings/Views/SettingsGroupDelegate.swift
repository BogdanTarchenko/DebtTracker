// MARK: - SettingsGroupDelegate

@MainActor
protocol SettingsGroupDelegate: AnyObject {
    func turnOffPassword()
    func createPassword()
    func showButton()
    func hideButton()
    func showFaceIDError(message: String)
    func faceIDToggleChanged(isEnabled: Bool)
}
