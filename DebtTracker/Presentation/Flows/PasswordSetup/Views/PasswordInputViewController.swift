import SnapKit
import UIKit

// MARK: - PasswordInputViewController

final class PasswordInputViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: PasswordInputViewModel

    // MARK: - UI Elements

    private let titleLabel = UILabel()
    private let passwordDotsView = PasswordDotsView()
    private let keyboardView: KeyboardView
    private let errorLabel = UILabel()

    // MARK: - Initialization

    init(viewModel: PasswordInputViewModel) {
        self.viewModel = viewModel
        keyboardView = KeyboardView(
            frame: .zero,
            isFaceIDEnabled: UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
        )
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
        bindViewModel()
    }

    // MARK: - Binding ViewModel

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            updateUI()
        }

        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            Task {
                updateUI()
                try await Task.sleep(for: .seconds(0.3))
                dismiss(animated: true)
            }
        }

        viewModel.onFailure = { [weak self] message in
            guard let self else { return }
            showError(message: message)
        }

        updateUI()
    }

    // MARK: - UI Setup

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

    // MARK: - UI Updates

    private func updateUI() {
        titleLabel.text = viewModel.title
        passwordDotsView.filledDotsCount = viewModel.filledDotsCount

        if let color = viewModel.highlightColor {
            passwordDotsView.highlight(with: color)
        }

        if let message = viewModel.errorMessage {
            showError(message: message)
        } else {
            hideError()
        }
    }

    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        errorLabel.alpha = 1
    }

    private func hideError() {
        errorLabel.isHidden = true
    }
}

// MARK: KeyboardViewDelegate

extension PasswordInputViewController: KeyboardViewDelegate {
    func keyPressed(_ key: String) {
        if key == "⌫" {
            viewModel.handleBackspaceTapped()
        } else if let number = Int(key) {
            viewModel.handleDigitTapped(number)
        }
    }

    func faceIDTapped() {
        viewModel.handleFaceIDTapped()
    }
}

// MARK: PasswordInputViewController.Constants

extension PasswordInputViewController {
    private enum Constants {
        static let titleTopOffset: CGFloat = 40
        static let dotsTopOffset: CGFloat = 40
        static let errorTopOffset: CGFloat = 20
        static let errorHorizontalInset: CGFloat = 40
        static let errorFontSize: CGFloat = 16
        static let keyboardBottomOffset: CGFloat = 20
        static let keyboardHeight: CGFloat = 300
        static let keyboardHorizontalInset: CGFloat = 20
        static let titleFontSize: CGFloat = 20
    }
}
