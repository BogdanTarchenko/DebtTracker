import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
    }

    private enum Localization {
        static let passwordTitle = "Защитить паролем"
        static let faceIDTitle = "Вход по FaceID"
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

            if !isPasswordEnabled {
                faceIDToggleSwitch.setOn(false, animated: true)
            }
        }
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let views = [
            passwordToggleLabel,
            passwordToggleSwitch,
            faceIDToggleLabel,
            faceIDToggleSwitch
        ]

        views.forEach { view.addSubview($0) }

        faceIDToggleSwitch.alpha = passwordToggleSwitch.isOn ? 1.0 : 0.7
        faceIDToggleLabel.alpha = passwordToggleSwitch.isOn ? 1.0 : 0.7
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
    }

    private func setupActions() {
        passwordToggleSwitch.addTarget(
            self,
            action: #selector(handlePasswordToggleSwitchValueChanged),
            for: .valueChanged
        )
    }
}
