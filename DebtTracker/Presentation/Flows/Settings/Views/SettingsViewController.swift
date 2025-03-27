import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let buttonHeight: CGFloat = 44
    }

    private enum Localization {
        static let passwordTitle = "Защитить паролем"
        static let faceIDTitle = "Вход по FaceID"
        static let changePassword = "Сменить пароль"
    }

    // MARK: - UI Elements

    private let passwordToggleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.passwordTitle
        return label
    }()

    private let passwordToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        return switchView
    }()

    private let faceIDToggleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.faceIDTitle
        return label
    }()

    private let faceIDToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        switchView.isUserInteractionEnabled = false
        return switchView
    }()

    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.changePassword, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 8
        button.alpha = 0
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

    @objc private func handlePasswordToggleSwitchValueChanged() {
        let isPasswordEnabled = passwordToggleSwitch.isOn

        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }

            faceIDToggleSwitch.isUserInteractionEnabled = isPasswordEnabled
            faceIDToggleSwitch.alpha = isPasswordEnabled ? 1.0 : 0.7
            faceIDToggleLabel.alpha = isPasswordEnabled ? 1.0 : 0.7

            changePasswordButton.alpha = isPasswordEnabled ? 1.0 : 0
            changePasswordButton.isHidden = !isPasswordEnabled

            if !isPasswordEnabled {
                faceIDToggleSwitch.setOn(false, animated: true)
            }
        }
    }

    @objc private func changePasswordTapped() {
        print("Кнопка 'Сменить пароль' нажата")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let views = [
            passwordToggleLabel,
            passwordToggleSwitch,
            faceIDToggleLabel,
            faceIDToggleSwitch,
            changePasswordButton
        ]

        views.forEach { view.addSubview($0) }

        faceIDToggleSwitch.alpha = 0.7
        faceIDToggleLabel.alpha = 0.7
    }

    private func setupConstraints() {
        passwordToggleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.verticalInset)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
        }

        passwordToggleSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(passwordToggleLabel)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        faceIDToggleLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordToggleLabel.snp.bottom).offset(Constants.elementSpacing)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
        }

        faceIDToggleSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(faceIDToggleLabel)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(faceIDToggleLabel.snp.bottom).offset(Constants.elementSpacing * 2)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.buttonHeight)
        }
    }

    private func setupActions() {
        passwordToggleSwitch.addTarget(
            self,
            action: #selector(handlePasswordToggleSwitchValueChanged),
            for: .valueChanged
        )

        changePasswordButton.addTarget(
            self,
            action: #selector(changePasswordTapped),
            for: .touchUpInside
        )
    }
}
