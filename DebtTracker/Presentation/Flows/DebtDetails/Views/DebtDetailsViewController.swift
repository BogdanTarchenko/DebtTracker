import _SwiftData_SwiftUI
import SnapKit
import SwiftUI
import UIKit

// MARK: - DebtDetailsViewController

final class DebtDetailsViewController: UIViewController {
    var credit: CreditModel

    // MARK: UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(
            ofSize: UIFont.preferredFont(
                forTextStyle: .subheadline
            ).pointSize
        )
        label.textColor = .white
        label.textAlignment = .center
        label.text = credit.name
        return label
    }()

    lazy var generalDebtInfo: DebtDetailsGeneralInfo = .init(frame: .zero, amount: credit.amount)
    lazy var debtTermInfo: DebtDetailsBlock = .init(frame: .zero, .init(
        leftImage: .percent,
        rightImage: .clock,
        leftTitle: LocalizedKey.DebtDetails.loanRate,
        rightTitle: LocalizedKey.DebtDetails.loanTerm,
        leftAmount: "\(credit.percentage)%",
        rightAmount: "\(credit.period) месяцев"
    ))
    lazy var debtDateInfo: DebtDetailsBlock = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current // или явно указать нужную локаль

        let leftAmount = dateFormatter.string(from: credit.startDate)
        let rightAmount = dateFormatter
            .string(from: credit.startDate) // предполагается, что такое поле есть в модели

        return DebtDetailsBlock(
            frame: .zero,
            .init(
                leftImage: .calendar,
                rightImage: .dollarsign,
                leftTitle: LocalizedKey.DebtDetails.openedDate,
                rightTitle: LocalizedKey.DebtDetails.nextPayment,
                leftAmount: leftAmount,
                rightAmount: rightAmount
            )
        )
    }()

    lazy var debtProgressInfo: DebtDetailsProgressInfo = {
        let view = DebtDetailsProgressInfo()
        view.configure(with: credit)
        return view
    }()

    lazy var debtPaymentsHistory: DebtDetailsPaymentHistory = .init(data: credit.payments)

    let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)

        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.title = LocalizedKey.DebtDetails.addTransaction
        config.image = UIImage(systemName: "plus", withConfiguration: symbolConfig)

        config.imagePadding = 8
        config.imagePlacement = .leading

        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                return outgoing
            }

        config.baseForegroundColor = UIColor.App.white
        config.baseBackgroundColor = UIColor.App.black

        button.configuration = config

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureAddTransactionButton()
        setupConstraints()
    }

    init(for credit: CreditModel) {
        self.credit = credit
        super.init(nibName: nil, bundle: nil)
        debtPaymentsHistory = DebtDetailsPaymentHistory(data: credit.payments)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configureView() {
        view.backgroundColor = .black

        [
            titleLabel,
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
        config.background.backgroundColor = UIColor.App.purple
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
        config.baseBackgroundColor = UIColor.App.black

        addTransactionButton.configuration = config
        addTransactionButton.layer.cornerRadius = Constants.cornerRadius
        addTransactionButton.layer.masksToBounds = true
        addTransactionButton
            .addTarget(
                self,
                action: #selector(
                    addTransactionButtonTapped
                ),
                for: .touchUpInside
            )
    }

    @objc func addTransactionButtonTapped() {
        let alert = UIAlertController(
            title: "Добавить платеж",
            message: "\n\n\n\n\n\n", // Место для пикера
            preferredStyle: .alert
        )

        // Поле для ввода суммы
        alert.addTextField { textField in
            textField.placeholder = "Сумма"
            textField.keyboardType = .decimalPad
        }

        // PickerView для выбора типа
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 100))
        pickerView.dataSource = self
        pickerView.delegate = self

        alert.view.addSubview(pickerView)

        // Действия
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self,
                  let amountText = alert.textFields?.first?.text,
                  let amount = Double(amountText)
            else {
                return
            }

            let selectedType = paymentTypes[pickerView.selectedRow(inComponent: 0)]
            handlePaymentCreation(amount: amount, type: selectedType)
        })

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(alert, animated: true)
    }

    private func handlePaymentCreation(amount: Double, type: String) {
        print("Создаем платеж: \(amount), тип: \(type)")
        let payment = PaymentModel(
            id: UUID().uuidString,
            amount: amount,
            date: Date.now,
            paymentType: PaymentTypeDTO(rawValue: type) ?? .monthlyAnnuity
        )

        // 1. Добавляем платеж в хранилище
        let creditStorage: CreditStorage = .init()
        creditStorage.addPayment(for: credit.id, with: payment)

        // 2. Обновляем локальную копию
        credit.payments.append(payment)
        credit.depositedAmount += amount // Важно обновить depositedAmount

        // 3. Обновляем UI
        debtPaymentsHistory.paymentHistoryItems = credit.payments
        debtProgressInfo.configure(with: credit) // Обновляем прогресс

        // 4. Анимация обновления
        UIView.transition(
            with: debtPaymentsHistory,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { self.debtPaymentsHistory.reloadData() }
        )
    }
}

extension DebtDetailsViewController {
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.topInset)
        }

        generalDebtInfo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.topInset)
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
            $0.height.equalTo(Constants.buttonHeight)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.bottomInset)
        }

        debtPaymentsHistory.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            $0.top.equalTo(debtProgressInfo.snp.bottom).offset(Constants.verticalSpacing)
            $0.bottom.equalTo(addTransactionButton.snp.top).offset(-Constants.verticalSpacing)
        }
    }
}

// MARK: UIPickerViewDataSource, UIPickerViewDelegate

extension DebtDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    var paymentTypes: [String] {
        var arr = [String]()
        for type in PaymentTypeDTO.allCases {
            arr.append(type.rawValue)
        }
        return arr
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        paymentTypes.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        paymentTypes[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.text = paymentTypes[row]
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
}

// MARK: DebtDetailsViewController.Constants

private extension DebtDetailsViewController {
    enum Constants {
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 16
        static let bottomInset: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
        static let buttonHeight: CGFloat = 50

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
