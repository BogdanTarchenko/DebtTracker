import SnapKit
import UIKit

class SettingsGroupView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let buttonHeight: CGFloat = 44
    }

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

    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedKey.Settings.changePassword, for: .normal)
        button.backgroundColor = UIColor.App.purple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 8
        button.alpha = 0
        button.isHidden = true
        return button
    }()

    private var changePasswordButtonHeightConstraint: Constraint?

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

    override var intrinsicContentSize: CGSize {
        let topInset = Constants.verticalInset
        let bottomInset = Constants.verticalInset
        let contentHeight = passwordToggleLabel.intrinsicContentSize.height +
            Constants.elementSpacing +
            faceIDToggleLabel.intrinsicContentSize.height +
            Constants.elementSpacing * 2 +
            Constants.buttonHeight

        let totalHeight = topInset + contentHeight + bottomInset
        let width = UIView.noIntrinsicMetric

        return CGSize(
            width: width,
            height: totalHeight
        )
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
            faceIDToggleSwitch,
            changePasswordButton
        ]

        for view in views {
            addSubview(view)
            view.isUserInteractionEnabled = true
        }

        faceIDToggleSwitch.alpha = 0.7
        faceIDToggleLabel.alpha = 0.7

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

        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(faceIDToggleLabel.snp.bottom).offset(Constants.elementSpacing * 2)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            changePasswordButtonHeightConstraint = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview().inset(Constants.verticalInset).priority(.low)
        }
    }

    @objc private func handlePasswordToggleSwitchValueChanged() {
        let isPasswordEnabled = passwordToggleSwitch.isOn

        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            guard let self else { return }

            faceIDToggleSwitch.isUserInteractionEnabled = isPasswordEnabled
            faceIDToggleSwitch.alpha = isPasswordEnabled ? 1.0 : 0.7
            faceIDToggleLabel.alpha = isPasswordEnabled ? 1.0 : 0.7

            changePasswordButton.alpha = isPasswordEnabled ? 1.0 : 0
            changePasswordButton.isHidden = !isPasswordEnabled
            changePasswordButtonHeightConstraint?.update(offset: isPasswordEnabled ? Constants.buttonHeight : 0)

            layoutIfNeeded()
        })
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

    @objc private func changePasswordTapped() {
        print("Кнопка 'Сменить пароль' нажата")
    }
}
