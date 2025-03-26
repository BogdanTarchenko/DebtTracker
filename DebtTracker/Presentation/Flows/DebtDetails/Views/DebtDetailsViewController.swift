import SnapKit
import UIKit

class DebtDetailsViewController: UIViewController {
    // MARK: UI Components

    let generalDebtInfo: GeneralDebtInfo = .init()
    let debtTermInfo: DebtTermInfo = .init()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
    }

    // MARK: Private Methods

    private func setupUI() {
        view.addSubview(generalDebtInfo)
        view.addSubview(debtTermInfo)
    }

    private func setupConstraints() {
        generalDebtInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        debtTermInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(generalDebtInfo.snp.bottom).offset(8)
        }
    }
}
