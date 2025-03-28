import SnapKit
import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let elementSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let buttonHeight: CGFloat = 44
    }

    // MARK: - UI Elements

    private let settingsGroupView: UIView = {
        let view = SettingsGroupView(frame: .zero)
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(settingsGroupView)
    }

    private func setupConstraints() {
        settingsGroupView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.horizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.verticalInset)
        }
    }
}
