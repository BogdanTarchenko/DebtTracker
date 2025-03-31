import LocalAuthentication
import SnapKit
import UIKit

// MARK: - SettingsGroupView

@MainActor
final class SettingsGroupView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let lowAlpha: CGFloat = 0.7
        static let highAlpha: CGFloat = 1.0
        static let faceIDKey = "isFaceIDEnabled"
    }

    // MARK: - Properties

    weak var delegate: SettingsGroupDelegate?

    var isPasswordEnabled: Bool {
        KeychainService.hasPassword()
    }

    var isFaceIDEnabled: Bool {
        UserDefaults.standard.bool(forKey: Constants.faceIDKey)
    }

    // MARK: - UI Elements

    private let gradientLayer = CAGradientLayer()

    private lazy var passwordToggleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.Settings.passwordTitle
        label.textColor = .white
        return label
    }()

    private lazy var passwordToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = isPasswordEnabled
        switchView
            .addTarget(
                self,
                action: #selector(
                    handlePasswordToggleSwitchValueChanged
                ),
                for: .valueChanged
            )
        return switchView
    }()

    private lazy var faceIDToggleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.Settings.faceIDTitle
        label.textColor = .white
        return label
    }()

    private lazy var faceIDToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = isFaceIDEnabled && isPasswordEnabled
        switchView.isUserInteractionEnabled = isPasswordEnabled
        switchView
            .addTarget(
                self,
                action: #selector(
                    handleFaceIDToggleSwitchValueChanged
                ),
                for: .valueChanged
            )
        return switchView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        updateUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Private Methods

    private func setupUI() {
        layer.cornerRadius = 12
        layer.masksToBounds = true

        gradientLayer.colors = [
            UIColor.App.black.cgColor,
            UIColor.App.black.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        for item in [
            passwordToggleLabel,
            passwordToggleSwitch,
            faceIDToggleLabel,
            faceIDToggleSwitch
        ] {
            addSubview(item)
        }
    }

    private func setupConstraints() {
        passwordToggleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.verticalInset)
            $0.leading.equalToSuperview().offset(Constants.horizontalInset)
        }

        passwordToggleSwitch.snp.makeConstraints {
            $0.centerY.equalTo(passwordToggleLabel)
            $0.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        faceIDToggleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordToggleLabel.snp.bottom).offset(Constants.elementSpacing)
            $0.leading.equalToSuperview().offset(Constants.horizontalInset)
        }

        faceIDToggleSwitch.snp.makeConstraints {
            $0.centerY.equalTo(faceIDToggleLabel)
            $0.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        snp.makeConstraints {
            $0.bottom.equalTo(faceIDToggleLabel.snp.bottom).offset(Constants.verticalInset)
        }
    }

    private func updateUI() {
        let isEnabled = passwordToggleSwitch.isOn
        faceIDToggleSwitch.isUserInteractionEnabled = isEnabled
        faceIDToggleSwitch.setOn(isEnabled && isFaceIDEnabled, animated: true)

        let alpha: CGFloat = isEnabled ? Constants.highAlpha : Constants.lowAlpha
        UIView.animate(withDuration: Constants.animationDuration) {
            self.faceIDToggleSwitch.alpha = alpha
            self.faceIDToggleLabel.alpha = alpha
        }
    }

    // MARK: - Actions

    @objc private func handlePasswordToggleSwitchValueChanged() {
        let isPasswordEnabled = passwordToggleSwitch.isOn

        if !isPasswordEnabled {
            UserDefaults.standard.set(false, forKey: Constants.faceIDKey)
            delegate?.turnOffPassword()
        } else {
            delegate?.createPassword()
        }

        UIView.animate(withDuration: Constants.animationDuration) {
            self.updateUI()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPasswordEnabled ? self.delegate?.showButton() : self.delegate?.hideButton()
        }
    }

    @objc private func handleFaceIDToggleSwitchValueChanged() {
        let isEnabled = faceIDToggleSwitch.isOn

        guard isEnabled else {
            UserDefaults.standard.set(false, forKey: Constants.faceIDKey)
            delegate?.faceIDToggleChanged(isEnabled: isEnabled)
            return
        }

        Task {
            let biometricService = BiometricService()
            switch await biometricService
                .authenticate(reason: "Включите Face ID для входа в приложение")
            {
            case .success:
                faceIDToggleSwitch.setOn(true, animated: true)
                UserDefaults.standard.set(true, forKey: Constants.faceIDKey)
                delegate?.faceIDToggleChanged(isEnabled: true)

            case let .failure(error):
                faceIDToggleSwitch.setOn(false, animated: true)
                delegate?.showFaceIDError(message: error.localizedDescription)
            }
        }
    }
}
