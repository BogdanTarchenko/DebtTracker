import SnapKit
import UIKit

// MARK: - DebtDetailsPaymentHistoryCell

class DebtDetailsPaymentHistoryCell: UICollectionViewCell {
    static let reuseIdentifier = "DebtDetailsPaymentHistoryCell"

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 12
        static let separatorHeight: CGFloat = 1
    }

    var isLastCell: Bool = false {
        didSet {
            separatorView.isHidden = isLastCell
        }
    }

    private let paymentTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let paymentDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.numberOfLines = 1
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return view
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

        contentView.addSubview(paymentTypeLabel)
        contentView.addSubview(paymentDateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(separatorView)

        paymentTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.verticalInset)
            make.leading.equalToSuperview().inset(Constants.horizontalInset)
            make.trailing.lessThanOrEqualTo(amountLabel.snp.leading).offset(-8)
        }

        paymentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentTypeLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.verticalInset)
            make.trailing.lessThanOrEqualTo(amountLabel.snp.leading).offset(-8)
        }

        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.centerY.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(Constants.separatorHeight)
        }
    }

    func configure(with item: PaymentHistoryItem) {
        paymentTypeLabel.text = item.paymentType
        paymentDateLabel.text = item.paymentDate
        amountLabel.text = item.amount
    }
}
