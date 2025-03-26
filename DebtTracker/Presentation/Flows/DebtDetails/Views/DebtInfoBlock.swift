import SnapKit
import UIKit

class DebtInfoBlock: UIView {
    enum DebtInfoIcons: String {
        case percent
        case clock
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(title: String, amount: String, icon: DebtInfoIcons) {
        super.init(frame: .zero)
        titleLabel.text = title
        amountLabel.text = amount
        iconImageView.image = UIImage(systemName: icon.rawValue)

        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(amountLabel)
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.top.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
