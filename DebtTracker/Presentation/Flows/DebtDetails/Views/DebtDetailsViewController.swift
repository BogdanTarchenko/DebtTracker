import SnapKit
import UIKit

class DebtDetailsViewController: UIViewController {
    // MARK: UI Components

    let generalDebtInfo: DebtDetailsGeneralInfo = .init()
    let debtTermInfo: DebtDetailsBlock = .init(frame: .zero, .init(
        leftImage: .percent,
        rightImage: .clock,
        leftTitle: "Ставка",
        rightTitle: "Срок",
        leftAmount: "12.5%",
        rightAmount: "36 месяцев"
    ))
    let debtDateInfo: DebtDetailsBlock = .init(frame: .zero, .init(
        leftImage: .calendar,
        rightImage: .dollarsign,
        leftTitle: "Дата открытия",
        rightTitle: "Следующий платеж",
        leftAmount: "25.04.2025",
        rightAmount: "25.05.2025"
    ))
    let debtProgressInfo: DebtDetailsProgressInfo = .init()
    let debtPaymentsHistory: DebtDetailsPaymentHistory = .init()
    let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)

        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.title = "Добавить транзакцию"
        config.image = UIImage(systemName: "plus", withConfiguration: symbolConfig)

        config.imagePadding = 8
        config.imagePlacement = .leading

        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config
            .titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                return outgoing
            }
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(named: "BlackCustomColor")

        button.configuration = config

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        return button
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
    }

    // MARK: Private Methods

    private func setupUI() {
        view.addSubview(generalDebtInfo)
        view.addSubview(debtTermInfo)
        view.addSubview(debtDateInfo)
        view.addSubview(debtProgressInfo)
        view.addSubview(debtPaymentsHistory)
        view.addSubview(addTransactionButton)
    }

    private func setupConstraints() {
        generalDebtInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        debtTermInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(generalDebtInfo.snp.bottom).offset(8)
        }

        debtDateInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(debtTermInfo.snp.bottom).offset(8)
        }

        debtProgressInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(debtDateInfo.snp.bottom).offset(8)
        }

        addTransactionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }

        debtPaymentsHistory.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(debtProgressInfo).inset(8)
            make.bottom.equalTo(addTransactionButton.snp.top).inset(-8)
        }
    }
}
