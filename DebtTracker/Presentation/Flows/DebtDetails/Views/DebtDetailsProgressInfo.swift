import SnapKit
import UIKit

// MARK: - DebtDetailsProgressInfo

final class DebtDetailsProgressInfo: UIView {
    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.DebtDetails.paymentProgress
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.App.white
        return label
    }()

    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.App.white
        label.textAlignment = .right
        return label
    }()

    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = UIColor.App.gray
        progressView.progressTintColor = UIColor.App.purple
        return progressView
    }()

    private let leftTitle: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.DebtDetails.remain
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.App.white
        return label
    }()

    private let leftAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.App.white
        return label
    }()

    private let rightTitle: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.DebtDetails.paid
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    private let rightAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.App.white
        label.textAlignment = .right
        return label
    }()

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 120)
    }

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // MARK: - Configuration

    func configure(with credit: CreditModel) {
        let paidAmount = credit.depositedAmount
        let totalAmount = credit.amount

        guard totalAmount > 0 else {
            progressBar.progress = 0
            percentLabel.text = "0%"
            leftAmount.text = 0.formattedAsCurrency()
            rightAmount.text = 0.formattedAsCurrency()
            return
        }

        let remainingAmount = max(0, totalAmount - paidAmount)
        let progress = Float(min(max(0, paidAmount / totalAmount), 1))

        progressBar.setProgress(progress, animated: true)
        percentLabel.text = "\(Int(progress * 100))%"
        leftAmount.text = remainingAmount.formattedAsCurrency()
        rightAmount.text = paidAmount.formattedAsCurrency()
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = UIColor.App.black
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(titleLabel)
        addSubview(percentLabel)
        addSubview(progressBar)
        addSubview(leftTitle)
        addSubview(leftAmount)
        addSubview(rightTitle)
        addSubview(rightAmount)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(percentLabel.snp.leading).offset(-8)
        }

        percentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8).priority(.high)
            make.leading.equalToSuperview().offset(16).priority(.high)
            make.trailing.equalToSuperview().offset(-16).priority(.high)
            make.height.equalTo(4).priority(.high)
        }

        leftTitle.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(12).priority(.high)
            make.leading.equalToSuperview().offset(16)
        }

        rightTitle.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(12).priority(.high)
            make.trailing.equalToSuperview().offset(-16)
        }

        leftAmount.snp.makeConstraints { make in
            make.top.equalTo(leftTitle.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16).priority(.high)
        }

        rightAmount.snp.makeConstraints { make in
            make.top.equalTo(rightTitle.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16).priority(.high)
        }
    }
}

extension Double {
    func formattedAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        formatter.positiveSuffix = " $"
        formatter.negativeSuffix = " $"

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
