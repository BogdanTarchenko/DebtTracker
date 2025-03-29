import UIKit

final class PasswordSetupViewModel {
    // MARK: - Properties

    enum State {
        case initial
        case enteringNewPassword
        case confirmingNewPassword
        case verifyingExistingPassword
        case error(message: String)
        case success
    }

    enum Mode {
        case createPassword
        case changePassword
        case verifyPassword
    }

    private(set) var mode: Mode
    private(set) var state: State = .initial {
        didSet {
            onStateChange?(state)
        }
    }

    var onStateChange: ((State) -> Void)?
    private var passwordDigits: [Int] = []
    private var confirmationDigits: [Int] = []

    // MARK: - Initialization

    init(mode: Mode) {
        self.mode = mode
        setupInitialState()
    }

    // MARK: - Public Methods

    func handleDigit(_ digit: Int) {
        switch state {
        case .initial, .enteringNewPassword:
            processDigitForNewPassword(digit)
        case .confirmingNewPassword:
            processDigitForConfirmation(digit)
        case .verifyingExistingPassword:
            processDigitForVerification(digit)
        case .error, .success:
            break
        }
    }

    func handleBackspace() {
        switch state {
        case .initial, .enteringNewPassword:
            if !passwordDigits.isEmpty {
                passwordDigits.removeLast()
            }
        case .confirmingNewPassword:
            if !confirmationDigits.isEmpty {
                confirmationDigits.removeLast()
            }
        case .verifyingExistingPassword:
            if !passwordDigits.isEmpty {
                passwordDigits.removeLast()
            }
        case .error, .success:
            break
        }
        onStateChange?(state)
    }

    // MARK: - Private Methods

    private func setupInitialState() {
        switch mode {
        case .createPassword:
            state = .enteringNewPassword
        case .changePassword:
            state = KeychainService
                .hasPassword() ? .verifyingExistingPassword : .enteringNewPassword
        case .verifyPassword:
            state = KeychainService
                .hasPassword() ? .verifyingExistingPassword :
                .error(
                    message: "Пароль не существует"
                )
        }
    }

    private func processDigitForVerification(_ digit: Int) {
        guard passwordDigits.count < 4 else { return }
        passwordDigits.append(digit)

        if passwordDigits.count == 4 {
            verifyExistingPassword()
        }
    }

    private func processDigitForConfirmation(_ digit: Int) {
        guard confirmationDigits.count < 4 else { return }
        confirmationDigits.append(digit)

        if confirmationDigits.count == 4 {
            confirmNewPassword()
        }
    }

    private func processDigitForNewPassword(_ digit: Int) {
        guard passwordDigits.count < 4 else { return }
        passwordDigits.append(digit)

        if passwordDigits.count == 4 {
            state = .confirmingNewPassword
            confirmationDigits = []
        }
    }

    private func verifyExistingPassword() {
        let enteredPassword = passwordDigits.map(String.init).joined()

        if KeychainService.verifyPassword(enteredPassword) {
            if mode == .verifyPassword {
                state = .success
            } else {
                state = .enteringNewPassword
                passwordDigits = []
            }
        } else {
            state = .error(message: LocalizedKey.PasswordSetup.wrongPassword)
            scheduleReset(delay: 0.5) { [weak self] in
                self?.resetPasswordInput()
                self?.state = .verifyingExistingPassword
            }
        }
    }

    private func confirmNewPassword() {
        let passwordString = passwordDigits.map(String.init).joined()
        let confirmedPassword = confirmationDigits.map(String.init).joined()

        if passwordString == confirmedPassword {
            if KeychainService.savePassword(passwordString) {
                state = .success
            } else {
                state = .error(message: LocalizedKey.PasswordSetup.saveError)
                scheduleReset(delay: 1.5) { [weak self] in
                    self?.resetPasswordInput()
                }
            }
        } else {
            state = .error(message: LocalizedKey.PasswordSetup.passwordsDontMatch)
            scheduleReset(delay: 1.5) { [weak self] in
                self?.resetPasswordInput()
            }
        }
    }

    private func resetPasswordInput() {
        passwordDigits = []
        confirmationDigits = []

        switch mode {
        case .createPassword:
            state = .enteringNewPassword
        case .changePassword:
            state = KeychainService
                .hasPassword() ? .verifyingExistingPassword : .enteringNewPassword
        case .verifyPassword:
            state = .verifyingExistingPassword
        }
    }

    private func scheduleReset(delay: TimeInterval, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
    }

    // MARK: - Helper Properties

    var currentFilledDotsCount: Int {
        switch state {
        case .initial, .enteringNewPassword, .verifyingExistingPassword:
            passwordDigits.count
        case .confirmingNewPassword:
            confirmationDigits.count
        case .error, .success:
            0
        }
    }

    var shouldHighlightDots: Bool {
        if case .error = state {
            return true
        }
        return false
    }

    var highlightColor: UIColor? {
        if case .error = state {
            return UIColor.App.red
        }
        return nil
    }
}
