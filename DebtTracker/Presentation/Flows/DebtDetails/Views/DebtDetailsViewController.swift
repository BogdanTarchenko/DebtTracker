import SnapKit
import UIKit

// MARK: - DebtDetailsViewController

final class DebtDetailsViewController: UIViewController {
    // MARK: - UI Components

    private let generalDebtInfo = DebtDetailsGeneralInfo()
    private let debtTermInfo = DebtDetailsBlock(
        frame: .zero,
        .init(
            leftImage: .percent,
            rightImage: .clock,
            leftTitle: LocalizedKey.DebtDetails.loanRate,
            rightTitle: LocalizedKey.DebtDetails.loanTerm,
            leftAmount: "12.5%",
            rightAmount: "36 месяцев"
        )
    )

    private let debtDateInfo = DebtDetailsBlock(
        frame: .zero,
        .init(
            leftImage: .calendar,
            rightImage: .dollarsign,
            leftTitle: LocalizedKey.DebtDetails.openedDate,
            rightTitle: LocalizedKey.DebtDetails.nextPayment,
            leftAmount: "25.04.2025",
            rightAmount: "25.05.2025"
        )
    )

    private let debtProgressInfo = DebtDetailsProgressInfo()
    private let debtPaymentsHistory = DebtDetailsPaymentHistory()
    private let addTransactionButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func configureView() {
        view.backgroundColor = .systemBackground
        configureAddTransactionButton()

        [
            generalDebtInfo,
            debtTermInfo,
            debtDateInfo,
            debtProgressInfo,
            debtPaymentsHistory,
            addTransactionButton
        ].forEach { customView in
            view.addSubview(customView)
        }
    }

    private func configureAddTransactionButton() {
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        var config = UIButton.Configuration.filled()

        config.title = LocalizedKey.DebtDetails.addTransaction
        config.image = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        config.imagePadding = Constants.imagePadding
        config.imagePlacement = .leading
        config.contentInsets = Constants.contentInsets
        config
            .titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                return outgoing
            }
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(named: "BlackCustomColor")

        addTransactionButton.configuration = config
        addTransactionButton.layer.cornerRadius = Constants.cornerRadius
        addTransactionButton.layer.masksToBounds = true
    }

    private func setupConstraints() {
        generalDebtInfo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.topInset)
        }

        debtTermInfo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(generalDebtInfo.snp.bottom).offset(Constants.verticalSpacing)
        }

        debtDateInfo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(debtTermInfo.snp.bottom).offset(Constants.verticalSpacing)
        }

        debtProgressInfo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(debtDateInfo.snp.bottom).offset(Constants.verticalSpacing)
        }

        addTransactionButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.bottomInset)
        }

        debtPaymentsHistory.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(debtProgressInfo).inset(Constants.verticalSpacing)
            $0.bottom.equalTo(addTransactionButton.snp.top).offset(-Constants.verticalSpacing)
        }
    }
}

// MARK: DebtDetailsViewController.Constants

private extension DebtDetailsViewController {
    enum Constants {
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 16
        static let bottomInset: CGFloat = 16
        static let verticalSpacing: CGFloat = 8

        static let imagePadding: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
    }
}
