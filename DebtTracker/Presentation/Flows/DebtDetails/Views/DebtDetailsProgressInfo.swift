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
        let remainingAmount = totalAmount - paidAmount
        let progress = Float(paidAmount / totalAmount)

        // Обновляем прогресс бар
        progressBar.setProgress(progress, animated: true)

        // Обновляем проценты
        let percentValue = Int(progress * 100)
        percentLabel.text = "\(percentValue)%"

        // Обновляем суммы
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

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }

        percentLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(4)
        }

        leftTitle.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }

        rightTitle.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }

        leftAmount.snp.makeConstraints { make in
            make.top.equalTo(leftTitle.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        rightAmount.snp.makeConstraints { make in
            make.top.equalTo(rightTitle.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
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
