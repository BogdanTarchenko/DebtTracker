import SnapKit
import UIKit

class DebtDualDetailsBlock: UIView {
    private let leftBlock: DebtInfoBlock
    private let rightBlock: DebtInfoBlock

    init(frame: CGRect, _ model: DebtDetailsBlockModel) {
        leftBlock = DebtInfoBlock(
            title: model.leftTitle,
            amount: model.leftAmount,
            icon: model.leftImage
        )
        rightBlock = DebtInfoBlock(
            title: model.rightTitle,
            amount: model.rightAmount,
            icon: model.rightImage
        )
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(named: "BlackCustomColor")
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(leftBlock)
        addSubview(rightBlock)

        leftBlock.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(rightBlock.snp.leading).offset(-16)
        }

        rightBlock.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(16)
            make.width.equalTo(leftBlock)
        }
    }
}
