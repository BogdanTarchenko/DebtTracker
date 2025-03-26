import SnapKit
import UIKit

class DebtDetailsPaymentHistoryCell: UICollectionViewCell {
    static let reuseIdentifier = "DebtDetailsPaymentHistoryCell"

    private let paymentTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let paymentDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = UIColor(named: "BlackCustomColor")
        contentView.layer.masksToBounds = true

        contentView.addSubview(paymentTypeLabel)
        contentView.addSubview(paymentDateLabel)
        contentView.addSubview(amountLabel)

        paymentTypeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }

        paymentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentTypeLabel.snp.bottom)
            make.leading.bottom.equalToSuperview().inset(8)
        }

        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with item: PaymentHistoryItem) {
        paymentTypeLabel.text = item.paymentType
        paymentDateLabel.text = item.paymentDate
        amountLabel.text = item.amount
    }
}
