import SnapKit
import UIKit

class DebtDateInfo: UIView {
    private let dateOpenedBlock: DebtInfoBlock = .init(
        title: "Дата открытия",
        amount: "25.04.2025",
        icon: .calendar
    )

    private let nextPaymentDateBlock: DebtInfoBlock = .init(
        title: "Следующий платеж",
        amount: "25.05.2025",
        icon: .dollarsign
    )

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(named: "BlackCustomColor")
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(dateOpenedBlock)
        addSubview(nextPaymentDateBlock)

        dateOpenedBlock.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(nextPaymentDateBlock.snp.leading).offset(-16)
        }

        nextPaymentDateBlock.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(16)
            make.width.equalTo(dateOpenedBlock)
        }
    }
}
