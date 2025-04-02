import SnapKit
import UIKit

// MARK: - SettingsViewController

final class SettingsViewController: UIViewController {
    // MARK: - UI Elements

    private let settingsGroupView: SettingsGroupView = {
        let view = SettingsGroupView(frame: .zero)
        return view
    }()

    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedKey.Settings.changePassword, for: .normal)
        button.backgroundColor = UIColor.App.purple
        button.setTitleColor(UIColor.App.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 8
        button.isHidden = !KeychainService.hasPassword()
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }

    private func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.App.black
        settingsGroupView.delegate = self
        view.backgroundColor = .black
        view.addSubview(settingsGroupView)
        view.addSubview(changePasswordButton)
    }

    private func setupConstraints() {
        settingsGroupView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.horizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.verticalInset)
        }

        changePasswordButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.horizontalInset)
            make.top.equalTo(settingsGroupView.snp.bottom).offset(Constants.elementSpacing)
            make.height.equalTo(Constants.buttonHeight)
        }
    }

    private func setupActions() {
        changePasswordButton.addTarget(
            self,
            action: #selector(changePasswordButtonTapped),
            for: .touchUpInside
        )
    }

    @objc
    func changePasswordButtonTapped() {
        let passwordInputViewController =
            PasswordInputViewController(
                viewModel: PasswordInputViewModel(
                    mode: .changePassword,
                    completion: nil
                )
            )
        passwordInputViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordInputViewController, animated: true)
    }
}

// MARK: SettingsGroupDelegate

extension SettingsViewController: SettingsGroupDelegate {
    func hideButton() {
        changePasswordButton.isHidden = true
    }

    func showButton() {
        changePasswordButton.isHidden = false
    }

    func turnOffPassword() {
        let passwordInputViewController = PasswordInputViewController(
            viewModel: PasswordInputViewModel(
                mode: .disablePassword,
                completion: nil
            )
        )
        passwordInputViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordInputViewController, animated: true)
    }

    func createPassword() {
        let passwordInputViewController = PasswordInputViewController(
            viewModel: PasswordInputViewModel(
                mode: .createPassword,
                completion: nil
            )
        )
        passwordInputViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordInputViewController, animated: true)
    }

    func showFaceIDError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка Face ID",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ок", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: SettingsViewController.Constants

extension SettingsViewController {
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let buttonHeight: CGFloat = 50
    }
}
