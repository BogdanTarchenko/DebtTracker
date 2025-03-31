import SnapKit
import UIKit

// MARK: - PasswordInputViewController

final class PasswordInputViewController: UIViewController {
    // MARK: - Properties

    private let mode: Mode
    private var passwordDigits: [Int] = []
    private var confirmationDigits: [Int] = []
    private var isConfirming = false
    private var isCheckingExistingPassword = false

    // MARK: - UI Elements

    private let titleLabel = UILabel()
    private let passwordDotsView = PasswordDotsView()
    private let keyboardView = KeyboardView()
    private let errorLabel = UILabel()

    // MARK: - Initialization

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkExistingPassword()
    }
}

// MARK: - Setup & UI Configuration

extension PasswordInputViewController {
    private func setupUI() {
        view.backgroundColor = .black
        setupTitleLabel()
        setupPasswordDotsView()
        setupErrorLabel()
        setupKeyboardView()
    }

    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.App.white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.titleTopOffset)
            make.centerX.equalToSuperview()
        }
    }

    private func setupPasswordDotsView() {
        view.addSubview(passwordDotsView)
        passwordDotsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.dotsTopOffset)
            make.centerX.equalToSuperview()
        }
    }

    private func setupErrorLabel() {
        errorLabel.font = .systemFont(ofSize: Constants.errorFontSize)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.App.red
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordDotsView.snp.bottom).offset(Constants.errorTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.errorHorizontalInset)
        }
    }

    private func setupKeyboardView() {
        keyboardView.delegate = self
        view.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.keyboardBottomOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.keyboardHorizontalInset)
            make.height.equalTo(Constants.keyboardHeight)
        }
    }
}

// MARK: - Password Management

extension PasswordInputViewController {
    private func checkExistingPassword() {
        switch mode {
        case .createPassword:
            titleLabel.text = LocalizedKey.PasswordInput.welcomeTitle
            isCheckingExistingPassword = false

        case .changePassword:
            if KeychainService.hasPassword() {
                isCheckingExistingPassword = true
                titleLabel.text = LocalizedKey.PasswordInput.enterExistingPassword
            } else {
                titleLabel.text = LocalizedKey.PasswordInput.welcomeTitle
            }

        case .verifyPassword:
            if KeychainService.hasPassword() {
                isCheckingExistingPassword = true
                titleLabel.text = LocalizedKey.PasswordInput.enterExistingPassword
            } else {
                showError(message: "Пароль не существует")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    private func handleDigit(_ digit: Int) {
        if isCheckingExistingPassword {
            processDigitForVerification(digit)
        } else if isConfirming {
            processDigitForConfirmation(digit)
        } else {
            processDigitForNewPassword(digit)
        }
    }

    private func processDigitForVerification(_ digit: Int) {
        guard passwordDigits.count < 4 else { return }
        passwordDigits.append(digit)
        updateDots()

        if passwordDigits.count == 4 {
            verifyExistingPassword()
        }
    }

    private func processDigitForConfirmation(_ digit: Int) {
        guard confirmationDigits.count < 4 else { return }
        confirmationDigits.append(digit)
        updateDots()

        if confirmationDigits.count == 4 {
            confirmNewPassword()
        }
    }

    private func processDigitForNewPassword(_ digit: Int) {
        guard passwordDigits.count < 4 else { return }
        passwordDigits.append(digit)
        updateDots()

        if passwordDigits.count == 4 {
            DispatchQueue.main
                .asyncAfter(
                    deadline: .now() + Constants.confirmationDelay
                ) { [weak self] in
                    guard let self else { return }
                    startConfirmation()
                }
        }
    }

    private func verifyExistingPassword() {
        let enteredPassword = passwordDigits.map(String.init).joined()

        if KeychainService.verifyPassword(enteredPassword) {
            highlightDots(color: UIColor.App.green)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                if self.mode == .verifyPassword {
                    self.passwordVerifiedSuccessfully()
                } else {
                    self.proceedWithNewPasswordSetup()
                }
            }
        } else {
            showError(message: LocalizedKey.PasswordInput.wrongPassword)
            highlightDots(color: UIColor.App.red)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                self.resetPasswordInput()
            }
        }
    }

    private func confirmNewPassword() {
        let passwordString = passwordDigits.map(String.init).joined()
        let confirmedPassword = confirmationDigits.map(String.init).joined()

        if passwordString == confirmedPassword {
            if KeychainService.savePassword(passwordString) {
                highlightDots(color: UIColor.App.green)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                    self.passwordSetupCompleted()
                }
            } else {
                showError(message: LocalizedKey.PasswordInput.saveError)
                highlightDots(color: UIColor.App.red)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                    self.resetPasswordInput()
                }
            }
        } else {
            showError(message: LocalizedKey.PasswordInput.passwordsDontMatch)
            highlightDots(color: UIColor.App.red)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                self.resetPasswordInput()
            }
        }
    }
}

// MARK: - UI Updates & Animations

extension PasswordInputViewController {
    private func updateDots() {
        let activeDigits = isConfirming ? confirmationDigits : passwordDigits
        passwordDotsView.filledDotsCount = activeDigits.count
    }

    private func highlightDots(color: UIColor) {
        passwordDotsView.highlight(with: color)
    }

    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.alpha = 0
        errorLabel.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 1
        }
    }

    private func hideError() {
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 0
        }) { _ in
            self.errorLabel.isHidden = true
            self.errorLabel.alpha = 1
        }
    }
}

// MARK: - Flow Control

extension PasswordInputViewController {
    private func proceedWithNewPasswordSetup() {
        isCheckingExistingPassword = false
        passwordDigits = []
        titleLabel.text = LocalizedKey.PasswordInput.welcomeTitle
        updateDots()
        hideError()
    }

    private func startConfirmation() {
        isConfirming = true
        titleLabel.text = LocalizedKey.PasswordInput.confirmationTitle
        hideError()
        passwordDotsView.reset()
    }

    private func resetPasswordInput() {
        passwordDigits = []
        confirmationDigits = []
        isConfirming = false

        hideError()

        if isCheckingExistingPassword {
            titleLabel.text = LocalizedKey.PasswordInput.enterExistingPassword
        } else {
            titleLabel.text = mode == .createPassword ?
                LocalizedKey.PasswordInput.welcomeTitle :
                LocalizedKey.PasswordInput.enterPassword
        }
        passwordDotsView.reset()
    }

    private func passwordVerifiedSuccessfully() {
        dismiss(animated: true)
    }

    private func passwordSetupCompleted() {
        dismiss(animated: true)
    }
}

// MARK: KeyboardViewDelegate

extension PasswordInputViewController: KeyboardViewDelegate {
    func keyPressed(_ key: String) {
        if key == "⌫" {
            handleBackspace()
        } else if let number = Int(key) {
            handleDigit(number)
        }
    }

    private func handleBackspace() {
        if isCheckingExistingPassword {
            if !passwordDigits.isEmpty {
                passwordDigits.removeLast()
                updateDots()
            }
        } else if isConfirming {
            if !confirmationDigits.isEmpty {
                confirmationDigits.removeLast()
                updateDots()
            }
        } else {
            if !passwordDigits.isEmpty {
                passwordDigits.removeLast()
                updateDots()
            }
        }
    }
}

// MARK: - Mode & Constants

extension PasswordInputViewController {
    enum Mode {
        case createPassword // Первоначальная установка пароля
        case changePassword // Смена существующего пароля
        case verifyPassword // Проверка пароля (для отключения)
    }

    private enum Constants {
        static let titleTopOffset: CGFloat = 40
        static let dotsTopOffset: CGFloat = 40
        static let errorTopOffset: CGFloat = 20
        static let errorHorizontalInset: CGFloat = 40
        static let errorFontSize: CGFloat = 16
        static let keyboardBottomOffset: CGFloat = 20
        static let keyboardHeight: CGFloat = 300
        static let keyboardHorizontalInset: CGFloat = 20
        static let keyboardButtonFontSize: CGFloat = 32
        static let titleFontSize: CGFloat = 20
        static let confirmationDelay: TimeInterval = 0.5
        static let successDelay: TimeInterval = 0.5
    }
}

// MARK: - Mode Extension

extension PasswordInputViewController.Mode {
    var allowsPasswordChange: Bool {
        switch self {
        case .createPassword, .changePassword: true
        case .verifyPassword: false
        }
    }
}
