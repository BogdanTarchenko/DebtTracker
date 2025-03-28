import SnapKit
import UIKit

final class DebtDetailsProgressInfo: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.DebtDetails.paymentProgress
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.App.white
        return label
    }()

    private let percentLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.App.white
        label.textAlignment = .right
        return label
    }()

    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.setProgress(0.5, animated: false)
        progressView.trackTintColor = UIColor.App.gray
        progressView.progressTintColor = UIColor.App.white
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
        label.text = "137500.00 ₽"
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
        label.text = "112500.00 ₽"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.App.white
        label.textAlignment = .right
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

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
