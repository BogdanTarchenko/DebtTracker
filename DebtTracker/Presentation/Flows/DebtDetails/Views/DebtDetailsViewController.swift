import SnapKit
import UIKit

class DebtDetailsViewController: UIViewController {
    // MARK: Lifecycle

    let generalDebtInfo: GeneralDebtInfo = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(generalDebtInfo)
    }

    private func setupConstraints() {
        generalDebtInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
