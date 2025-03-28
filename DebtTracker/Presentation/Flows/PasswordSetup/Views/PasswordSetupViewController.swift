import Security
import SnapKit
import UIKit

// MARK: - PasswordSetupViewController

final class PasswordSetupViewController: UIViewController {
    // MARK: - Properties

    private var passwordDigits: [Int] = []
    private var confirmationDigits: [Int] = []
    private var isConfirming = false
    private var isCheckingExistingPassword = false

    // MARK: - UI Elements

    private let titleLabel = UILabel()
    private let dotsStackView = UIStackView()
    private var dotViews: [UIView] = []
    private let keyboardView = UIView()
    private let errorLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboard()
        checkExistingPassword()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .black

        // Title Label
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.App.white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.titleTopOffset)
            make.centerX.equalToSuperview()
        }

        // Dots StackView
        dotsStackView.axis = .horizontal
        dotsStackView.distribution = .equalSpacing
        dotsStackView.spacing = Constants.dotsSpacing
        view.addSubview(dotsStackView)

        dotsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.dotsTopOffset)
            make.centerX.equalToSuperview()
        }

        // Create 4 dots
        for _ in 0 ..< 4 {
            let dot = UIView()
            dot.backgroundColor = UIColor.App.gray
            dot.layer.cornerRadius = Constants.dotSize / 2
            dotViews.append(dot)
            dotsStackView.addArrangedSubview(dot)

            dot.snp.makeConstraints { make in
                make.width.height.equalTo(Constants.dotSize)
            }
        }

        // Error Label
        errorLabel.textColor = UIColor.App.red
        errorLabel.font = .systemFont(ofSize: Constants.errorFontSize)
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(dotsStackView.snp.bottom).offset(Constants.errorTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.keyboardHorizontalInset)
        }

        // Keyboard View
        keyboardView.backgroundColor = .black
        keyboardView.layer.cornerRadius = 10
        view.addSubview(keyboardView)

        keyboardView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.keyboardBottomOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.keyboardHorizontalInset)
            make.height.equalTo(Constants.keyboardHeight)
        }
    }

    private func setupKeyboard() {
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.distribution = .fillEqually
        gridStack.spacing = 1
        keyboardView.addSubview(gridStack)

        gridStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let buttonTitles = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
        ]

        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 1
            gridStack.addArrangedSubview(rowStack)

            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font =
                    .systemFont(
                        ofSize: Constants.keyboardButtonFontSize,
                        weight: .medium
                    )
                button.backgroundColor = .black
                button.setTitleColor(UIColor.App.white, for: .normal)
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
        }
    }

    // MARK: - Password Management

    private func checkExistingPassword() {
        if retrievePassword() != nil {
            isCheckingExistingPassword = true
//            titleLabel.text = LocalizedKey.PasswordSetup.enterExistingPasswordTitle
            titleLabel.text = "Введите существующий пароль"

        } else {
            titleLabel.text = LocalizedKey.PasswordSetup.welcomeTitle
        }
    }

    private func savePasswordToKeychain(_ password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Constants.passwordKey,
            kSecValueData: passwordData,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func retrievePassword() -> String? {
        guard let kCFBooleanTrue else { return nil }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Constants.passwordKey,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    // MARK: - Actions

    @objc private func keyPressed(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }

        if digit == "⌫" {
            handleBackspace()
        } else if let number = Int(digit) {
            handleDigit(number)
        }
    }

    private func handleDigit(_ digit: Int) {
        if isCheckingExistingPassword {
            if passwordDigits.count < 4 {
                passwordDigits.append(digit)
                updateDots()
                if passwordDigits.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.confirmationDelay) {
                        self.checkExistingPasswordMatch()
                    }
                }
            }
        } else if isConfirming {
            if confirmationDigits.count < 4 {
                confirmationDigits.append(digit)
                updateDots()
                if confirmationDigits.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.confirmationDelay) {
                        self.checkConfirmation()
                    }
                }
            }
        } else {
            if passwordDigits.count < 4 {
                passwordDigits.append(digit)
                updateDots()
                if passwordDigits.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.confirmationDelay) {
                        self.startConfirmation()
                    }
                }
            }
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

    // MARK: - Password Flow

    private func updateDots() {
        let activeDigits = isConfirming ? confirmationDigits : passwordDigits
        for (index, dot) in dotViews.enumerated() {
            dot.backgroundColor = (
                index < activeDigits.count
            ) ? UIColor.App.purple : UIColor.App.gray
        }
    }

    private func checkExistingPasswordMatch() {
        let enteredPassword = passwordDigits.map(String.init).joined()
        if let savedPassword = retrievePassword(), enteredPassword == savedPassword {
            // Correct existing password
            highlightDots(color: UIColor.App.green)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                self.proceedWithNewPasswordSetup()
            }
        } else {
            // Wrong existing password
//            showError(message: LocalizedKey.PasswordSetup.wrongExistingPasswordTitle)
            showError(message: "Введенные пароли не совпадают")

            highlightDots(color: UIColor.App.red)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                self.resetPasswordInput()
            }
        }
    }

    private func proceedWithNewPasswordSetup() {
        isCheckingExistingPassword = false
        passwordDigits = []
        titleLabel.text = LocalizedKey.PasswordSetup.welcomeTitle
        updateDots()
        errorLabel.isHidden = true
    }

    private func startConfirmation() {
        isConfirming = true
        titleLabel.text = LocalizedKey.PasswordSetup.confirmationPasswordTitle
        errorLabel.isHidden = true
        dotViews.forEach { $0.backgroundColor = UIColor.App.white }
    }

    private func checkConfirmation() {
        let passwordString = passwordDigits.map(String.init).joined()

        if passwordDigits == confirmationDigits {
            if savePasswordToKeychain(passwordString) {
                highlightDots(color: UIColor.App.green)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                    self.passwordSetupCompleted()
                }
            } else {
//                showError(message: LocalizedKey.PasswordSetup.saveErrorTitle)
                showError(message: "Ошибка сохранения пароля")
                highlightDots(color: UIColor.App.red)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                    self.resetPasswordInput()
                }
            }
        } else {
            showError(message: LocalizedKey.PasswordSetup.wrongPasswordTitle)
            highlightDots(color: UIColor.App.red)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.successDelay) {
                self.resetPasswordInput()
            }
        }
    }

    private func highlightDots(color: UIColor) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.dotViews.forEach { $0.backgroundColor = color }
        }
    }

    private func passwordSetupCompleted() {
        print("Password setup completed successfully")
        dismiss(animated: true)
    }

    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    private func resetPasswordInput() {
        passwordDigits = []
        confirmationDigits = []
        isConfirming = false
        titleLabel.text = isCheckingExistingPassword ?
//            LocalizedKey.PasswordSetup.enterExistingPasswordTitle :
            "Введите существующий пароль" :
//            LocalizedKey.PasswordSetup.welcomeTitle
            "Введите пароль"

        updateDots()
        errorLabel.isHidden = true
    }
}

// MARK: PasswordSetupViewController.Constants

extension PasswordSetupViewController {
    private enum Constants {
        static let dotSize: CGFloat = 20
        static let dotsSpacing: CGFloat = 20
        static let titleTopOffset: CGFloat = 40
        static let dotsTopOffset: CGFloat = 40
        static let errorTopOffset: CGFloat = 20
        static let keyboardBottomOffset: CGFloat = 20
        static let keyboardHeight: CGFloat = 300
        static let keyboardHorizontalInset: CGFloat = 20
        static let keyboardButtonFontSize: CGFloat = 24
        static let titleFontSize: CGFloat = 18
        static let errorFontSize: CGFloat = 14
        static let animationDuration: TimeInterval = 0.3
        static let confirmationDelay: TimeInterval = 0.3
        static let successDelay: TimeInterval = 0.5
        static let passwordKey = "com.debttracker.password"
    }
}
