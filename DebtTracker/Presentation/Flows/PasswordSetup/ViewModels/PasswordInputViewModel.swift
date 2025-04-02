import UIKit

// MARK: - PasswordInputMode

enum PasswordInputMode {
    case createPassword
    case changePassword
    case verifyPassword
    case disablePassword
}

// MARK: - PasswordInputViewModel.Constants

private extension PasswordInputViewModel {
    enum Constants {
        static let maxPasswordLength = 4
        static let errorDisplayDuration: TimeInterval = 0.5
        static let transitionDelay: TimeInterval = 0.3
    }
}

// MARK: - PasswordInputViewModel

@MainActor
final class PasswordInputViewModel {
    // MARK: - Properties

    private let mode: PasswordInputMode
    private var currentPassword: [Int] = []
    private var newPassword: [Int] = []
    private var isConfirming = false
    private var isCheckingExisting = false

    // Output
    private(set) var title: String = ""
    private(set) var filledDotsCount: Int = 0
    private(set) var isFaceIDEnabled: Bool = false
    private(set) var errorMessage: String?
    private(set) var highlightColor: UIColor?

    // Callbacks
    var onUpdate: (() -> Void)?
    var onSuccess: (() -> Void)?
    var onFailure: ((String) -> Void)?

    var completion: (() -> Void)?

    // MARK: - Init

    init(mode: PasswordInputMode, completion: (() -> Void)?) {
        self.mode = mode
        self.completion = completion
        configureInitialState()
    }

    // MARK: - Input Handlers

    func handleDigitTapped(_ digit: Int) {
        if isCheckingExisting {
            processDigitForVerification(digit)
        } else if isConfirming {
            processDigitForConfirmation(digit)
        } else {
            processDigitForNewPassword(digit)
        }
    }

    func handleBackspaceTapped() {
        if isCheckingExisting {
            _ = currentPassword.popLast()
        } else if isConfirming {
            _ = newPassword.popLast()
        } else {
            _ = currentPassword.popLast()
        }
        updateUI()
    }

    func handleFaceIDTapped() {
        authenticateWithBiometrics()
    }

    // MARK: - Private Methods

    private func configureInitialState() {
        switch mode {
        case .createPassword:
            title = LocalizedKey.PasswordInput.createTitle
            isFaceIDEnabled = false
        case .changePassword, .disablePassword:
            title = LocalizedKey.PasswordInput.verifyTitle
            isCheckingExisting = true
            isFaceIDEnabled = false
        case .verifyPassword:
            title = LocalizedKey.PasswordInput.verifyTitle
            isCheckingExisting = true
            isFaceIDEnabled = true
        }

        updateUI()
    }

    private func processDigitForVerification(_ digit: Int) {
        guard currentPassword.count < Constants.maxPasswordLength else { return }
        currentPassword.append(digit)
        updateUI()

        if currentPassword.count == Constants.maxPasswordLength {
            verifyPassword()
        }
    }

    private func processDigitForNewPassword(_ digit: Int) {
        guard currentPassword.count < Constants.maxPasswordLength else { return }
        currentPassword.append(digit)
        updateUI()

        if currentPassword.count == Constants.maxPasswordLength {
            startConfirmation()
        }
    }

    private func startConfirmation() {
        Task {
            try await Task.sleep(for: .seconds(Constants.transitionDelay))
            isCheckingExisting = false
            isConfirming = true
            title = LocalizedKey.PasswordInput.confirmationTitle
            updateUI()
        }
    }

    private func processDigitForConfirmation(_ digit: Int) {
        guard newPassword.count < Constants.maxPasswordLength else { return }
        newPassword.append(digit)
        updateUI()
        if newPassword.count == Constants.maxPasswordLength {
            confirmNewPassword()
        }
    }

    private func verifyPassword() {
        let password = currentPassword.map(String.init).joined()
        if KeychainService.verifyPassword(password) {
            if mode == .changePassword {
                highlightColor = UIColor.App.green
                updateUI()
                startNewPasswordFlow()
            } else if mode == .verifyPassword {
                highlightColor = UIColor.App.green
                updateUI()
                handleSuccess()
            } else {
                _ = KeychainService.disablePassword()
                handleSuccess()
            }
        } else {
            handleFailure(LocalizedKey.PasswordInput.wrongPassword)
        }
    }

    private func startNewPasswordFlow() {
        Task {
            try await Task.sleep(for: .seconds(Constants.transitionDelay))
            highlightColor = nil
            isCheckingExisting = false
            currentPassword.removeAll()
            title = LocalizedKey.PasswordInput.createTitle
            updateUI()
        }
    }

    private func confirmNewPassword() {
        let original = currentPassword.map(String.init).joined()
        let confirmation = newPassword.map(String.init).joined()

        if original == confirmation {
            savePassword(original)
        } else {
            handleFailure(LocalizedKey.PasswordInput.dontMatch)
        }
    }

    private func savePassword(_ password: String) {
        if KeychainService.savePassword(password) {
            handleSuccess()
        } else {
            handleFailure(LocalizedKey.PasswordInput.saveError)
        }
    }

    private func authenticateWithBiometrics() {
        Task {
            let result = await BiometricService().authenticate()
            switch result {
            case .success:
                currentPassword.append(contentsOf: [1, 1, 1, 1])
                handleSuccess()
            case let .failure(error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }

    private func handleSuccess() {
        highlightColor = .green
        updateUI()

        Task {
            try await Task.sleep(for: .seconds(0.3))

            await MainActor.run {
                self.onSuccess?()

                if self.mode == .verifyPassword {
                    self.completion?()
                }

                self.highlightColor = nil
                self.updateUI()
            }
        }
    }

    private func handleFailure(_ message: String) {
        Task {
            errorMessage = message
            highlightColor = .red
            updateUI()

            onFailure?(message)

            try await Task.sleep(for: .seconds(Constants.errorDisplayDuration))

            if isCheckingExisting {
                currentPassword.removeAll()
            } else {
                newPassword.removeAll()
            }

            highlightColor = nil
            errorMessage = nil
            updateUI()
        }
    }

    private func updateUI() {
        filledDotsCount = isConfirming ? newPassword.count : currentPassword.count
        onUpdate?()
    }
}
