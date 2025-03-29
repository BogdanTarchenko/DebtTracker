import SnapKit
import UIKit

// MARK: - SettingsGroupView

class SettingsGroupView: UIView {
    // MARK: - Constants

    weak var delegate: SettingsGroupDelegate?

    // MARK: - UI Elements

    private let gradientLayer = CAGradientLayer()

    private let passwordToggleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.Settings.passwordTitle
        label.textColor = .white
        return label
    }()

    private let passwordToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        return switchView
    }()

    private let faceIDToggleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.Settings.faceIDTitle
        label.textColor = .white
        return label
    }()

    private let faceIDToggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        switchView.isUserInteractionEnabled = false
        return switchView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
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

        let views = [
            passwordToggleLabel,
            passwordToggleSwitch,
            faceIDToggleLabel,
            faceIDToggleSwitch
        ]

        for view in views {
            addSubview(view)
            view.isUserInteractionEnabled = true
        }

        faceIDToggleSwitch.alpha = Constants.lowAlpha
        faceIDToggleLabel.alpha = Constants.lowAlpha

        isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        passwordToggleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalInset)
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

        snp.makeConstraints { make in
            make.bottom.equalTo(faceIDToggleLabel.snp.bottom).offset(Constants.verticalInset)
        }
    }

    @objc private func handlePasswordToggleSwitchValueChanged() {
        let isPasswordEnabled = passwordToggleSwitch.isOn

        if !isPasswordEnabled {
            delegate?.turnOffPassword(completion: {
                self.delegate?.hideButton()
            })
        } else {
            delegate?.createPassword(completion: {
                self.delegate?.showButton()
            })
        }

        UIView.animate(withDuration: Constants.animationDuration, animations: { [self] in
            faceIDToggleSwitch.isUserInteractionEnabled = isPasswordEnabled

            if isPasswordEnabled {
                faceIDToggleSwitch.alpha = Constants.highAlpha
                faceIDToggleLabel.alpha = Constants.highAlpha
            } else {
                faceIDToggleSwitch.alpha = Constants.lowAlpha
                faceIDToggleLabel.alpha = Constants.lowAlpha
                faceIDToggleSwitch.setOn(false, animated: true)
            }

            layoutIfNeeded()
        })
    }

    private func setupActions() {
        passwordToggleSwitch.addTarget(
            self,
            action: #selector(handlePasswordToggleSwitchValueChanged),
            for: .valueChanged
        )
    }
}

// MARK: SettingsGroupView.Constants

extension SettingsGroupView {
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let lowAlpha = 0.7
        static let highAlpha = 1.0
    }
}
