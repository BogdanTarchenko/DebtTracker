import UIKit

final class DebtDetailsGeneralInfo: UIView {
    var amount: Double

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.DebtDetails.creditAmount
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.App.white
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(amount) $"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = UIColor.App.white
        return label
    }()

    init(frame: CGRect, amount: Double) {
        self.amount = amount
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.App.black
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(titleLabel)
        addSubview(amountLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
