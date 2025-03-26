import SnapKit
import UIKit

// MARK: - DebtDetailsPaymentHistory

class DebtDetailsPaymentHistory: UICollectionView,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
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

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            header.configure(title: "История")
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }

    // MARK: - Добавление дефолтных разделителей

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        1 // Отступ между строками (разделитель)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0 // Отступы между ячейками в строке
    }
}

// MARK: - HeaderView

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BlackCustomColor")
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
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
