import SnapKit
import UIKit

final class PasswordSetupViewController: UIViewController {
    // MARK: - Properties

    private var passwordDigits: [Int] = []
    private var confirmationDigits: [Int] = []
    private var isConfirming = false

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
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Title Label
        titleLabel.text = LocalizedKey.PasswordSetup.welcomeTitle
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        // Dots StackView
        dotsStackView.axis = .horizontal
        dotsStackView.distribution = .equalSpacing
        dotsStackView.spacing = 20
        view.addSubview(dotsStackView)

        dotsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }

        // Create 4 dots
        for _ in 0 ..< 4 {
            let dot = UIView()
            dot.backgroundColor = .systemGray4
            dot.layer.cornerRadius = 10
            dotViews.append(dot)
            dotsStackView.addArrangedSubview(dot)

            dot.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
        }

        // Error Label
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(dotsStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // Keyboard View
        keyboardView.backgroundColor = .systemGray6
        keyboardView.layer.cornerRadius = 10
        view.addSubview(keyboardView)

        keyboardView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
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
                button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
                button.backgroundColor = UIColor.App.white
                button.setTitleColor(UIColor.App.black, for: .normal)
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
        }
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
        if isConfirming {
            if confirmationDigits.count < 4 {
                confirmationDigits.append(digit)
                updateDots()
                if confirmationDigits.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.checkConfirmation()
                    }
                }
            }
        } else {
            if passwordDigits.count < 4 {
                passwordDigits.append(digit)
                updateDots()
                if passwordDigits.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.startConfirmation()
                    }
                }
            }
        }
    }

    private func handleBackspace() {
        if isConfirming {
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
            dot.backgroundColor = (index < activeDigits.count) ? UIColor.App.blue : .systemGray4
        }
    }

    private func startConfirmation() {
        print("Введен пароль: \(passwordDigits.map(String.init).joined())")
        isConfirming = true
        titleLabel.text = LocalizedKey.PasswordSetup.confirmationPasswordTitle
        errorLabel.isHidden = true
        dotViews.forEach { $0.backgroundColor = .systemGray4 }
    }

    private func checkConfirmation() {
        let passwordString = passwordDigits.map(String.init).joined()
        let confirmationString = confirmationDigits.map(String.init).joined()

        print("Пароль: \(passwordString)")
        print("Подтверждение: \(confirmationString)")

        if passwordDigits == confirmationDigits {
            // Верный пароль - зеленая подсветка
            highlightDots(color: .systemGreen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.savePassword()
            }
        } else {
            // Неверный пароль - красная подсветка
            highlightDots(color: .systemRed)
            showError(message: LocalizedKey.PasswordSetup.wrongPasswordTitle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.resetPasswordInput()
            }
        }
    }

    private func highlightDots(color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.dotViews.forEach { $0.backgroundColor = color }
        }
    }

    private func savePassword() {
        let password = passwordDigits.map(String.init).joined()
        print("Пароль успешно установлен: \(password)")
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
        titleLabel.text = LocalizedKey.PasswordSetup.welcomeTitle
        updateDots()
        errorLabel.isHidden = true
    }
}
