import UIKit

class GeneralDebtInfo: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма кредита"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "2500000.00 ₽"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
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
        backgroundColor = UIColor(named: "BlackCustomColor")
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
