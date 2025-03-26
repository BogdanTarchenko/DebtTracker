import SnapKit
import UIKit

// MARK: - DebtDetailsPaymentHistory

class DebtDetailsPaymentHistory: UICollectionView {
    private var paymentHistoryItems: [PaymentHistoryItem] = [
        PaymentHistoryItem(
            paymentType: "Ежемесячный платеж",
            paymentDate: "01.03.2025",
            amount: "-8500 ₽"
        ),
        PaymentHistoryItem(
            paymentType: "Доп. погашение",
            paymentDate: "15.03.2025",
            amount: "-15000 ₽"
        ),
        PaymentHistoryItem(
            paymentType: "Погашение",
            paymentDate: "20.03.2025",
            amount: "-10000 ₽"
        ),
        PaymentHistoryItem(
            paymentType: "Доп. погашение",
            paymentDate: "15.03.2025",
            amount: "-15000 ₽"
        ),
        PaymentHistoryItem(
            paymentType: "Погашение",
            paymentDate: "20.03.2025",
            amount: "-10000 ₽"
        )
    ]

    private enum Constants {
        static let cellHeight: CGFloat = 64
        static let headerHeight: CGFloat = 48
        static let separatorHeight: CGFloat = 1
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 8
        static let interitemSpacing: CGFloat = 0
    }

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: Constants.verticalInset,
            right: 0
        )
        layout.minimumLineSpacing = Constants.separatorHeight
        layout.minimumInteritemSpacing = Constants.interitemSpacing
        layout.sectionHeadersPinToVisibleBounds = true

        super.init(frame: .zero, collectionViewLayout: layout)

        register(
            DebtDetailsPaymentHistoryCell.self,
            forCellWithReuseIdentifier: DebtDetailsPaymentHistoryCell.reuseIdentifier
        )
        register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )

        dataSource = self
        delegate = self

        backgroundColor = UIColor(named: "BlackCustomColor")
        contentInset = .zero
        scrollIndicatorInsets = .zero
        layer.cornerRadius = 10
        layer.masksToBounds = true
        showsVerticalScrollIndicator = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UICollectionViewDataSource

extension DebtDetailsPaymentHistory: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        paymentHistoryItems.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = paymentHistoryItems[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DebtDetailsPaymentHistoryCell.reuseIdentifier,
            for: indexPath
        ) as? DebtDetailsPaymentHistoryCell else { return UICollectionViewCell() }

        cell.configure(with: item)
        cell.isLastCell = indexPath.row == paymentHistoryItems.count - 1
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView else {
                return UICollectionReusableView()
            }

            header.configure(title: "История платежей")
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension DebtDetailsPaymentHistory: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.headerHeight)
    }
}

// MARK: - HeaderView

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let separatorHeight: CGFloat = 1
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BlackCustomColor")
        addSubview(titleLabel)
        addSubview(separatorView)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Constants.separatorHeight)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
