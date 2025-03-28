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
        button.isHidden = true
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
        let passwordSetupViewController = PasswordSetupViewController(mode: .changePassword)
        passwordSetupViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordSetupViewController, animated: true)
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
        let passwordSetupViewController = PasswordSetupViewController(mode: .verifyPassword)
        passwordSetupViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordSetupViewController, animated: true)
    }

    func createPassword() {
        let passwordSetupViewController = PasswordSetupViewController(mode: .createPassword)
        passwordSetupViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(passwordSetupViewController, animated: true)
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
