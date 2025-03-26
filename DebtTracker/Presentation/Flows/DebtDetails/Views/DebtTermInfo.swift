import SnapKit
import UIKit

class DebtTermInfo: UIView {
    private let interestBlock: DebtInfoBlock = .init(
        title: "Ставка",
        amount: "12.5%",
        icon: .percent
    )

    private let termBlock: DebtInfoBlock = .init(
        title: "Срок",
        amount: "36 месяцев",
        icon: .clock
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

        addSubview(interestBlock)
        addSubview(termBlock)

        interestBlock.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(termBlock.snp.leading).offset(-16)
        }

        termBlock.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(16)
            make.width.equalTo(interestBlock)
        }
    }
}
