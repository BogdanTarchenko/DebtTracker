import Foundation
import SnapKit
import SwiftUI
import UIKit

// MARK: - AddDebtViewController

class AddDebtViewController: UIViewController {
    private let addDebtScrollView = UIScrollView()
    private let contentView = UIView()

    private let debtTypeView = UIView()
    private let debtTypeTitleLabel = UILabel()
    private let debtBorrowedButton = UIButton()
    private let debtLentButton = UIButton()

    private let amountInputContainerView = UIView()
    private let amountTitleLabel = UILabel()
    private let amountInputTextField = UITextField()

    private let infoDebtView = UIView()
    private let creditNameLabel = UILabel()
    private let creditNameTextField = UITextField()
    private let purposeTextLabel = UILabel()
    private let purposeTextField = UITextField()

    private let dateContainerView = UIView()
    private let dateTitleLabel = UILabel()
    private let dateTextField = UIDatePicker()

    private let addDebtButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6

        addDebtScrollView.addSubview(contentView)
        addDebtScrollView.isScrollEnabled = true
        view.addSubview(addDebtScrollView)

        setupDebtContainer()
        setupAmountContainer()
        setupInfoContainer()
        setupDateContainer()
        setupDebtButton()

        setupConstraints()
    }

    fileprivate func setupDebtContainer() {
        debtTypeView.backgroundColor = UIColor(named: "RedCustomColor")
        debtTypeView.layer.cornerRadius = 10
        contentView.addSubview(debtTypeView)

        debtTypeTitleLabel.text = "Debt type"
        debtTypeTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        debtTypeTitleLabel.textColor = .white

        debtBorrowedButton.backgroundColor = UIColor(
            named: "BlackCustomColor"
        )
        debtBorrowedButton.layer.cornerRadius = 10
        debtLentButton.backgroundColor = .white
        debtLentButton.layer.cornerRadius = 10

        debtTypeView.addSubViews(debtTypeTitleLabel, debtBorrowedButton, debtLentButton)
    }

    fileprivate func setupAmountContainer() {
        amountInputContainerView.layer.cornerRadius = 12
        amountInputContainerView.backgroundColor = .systemBackground
        contentView.addSubview(amountInputContainerView)

        amountTitleLabel.text = "Amount Details"
        amountTitleLabel.font = standartFont16Bold
        amountInputContainerView.addSubview(amountTitleLabel)

        amountInputTextField.placeholder = "$ 0.00"
        amountInputTextField.borderStyle = .roundedRect
        amountInputContainerView.addSubview(amountInputTextField)
    }

    fileprivate func setupInfoContainer() {
        infoDebtView.backgroundColor = .systemBackground
        infoDebtView.layer.cornerRadius = 12
        contentView.addSubview(infoDebtView)

        creditNameTextField.placeholder = "Enter name"
        creditNameTextField.borderStyle = .roundedRect
        infoDebtView.addSubview(creditNameTextField)

        creditNameLabel.text = "Credit name"
        creditNameLabel.textColor = UIColor(named: "BlackCustomColor")
        creditNameLabel.font = standartFont16Bold
        infoDebtView.addSubview(creditNameLabel)

        purposeTextLabel.text = "Purpose / Description"
        purposeTextLabel.textColor = UIColor(named: "BlackCustomColor")
        purposeTextLabel.font = standartFont16Bold
        infoDebtView.addSubview(purposeTextLabel)

        purposeTextField.placeholder = "What is this debt for?"
        purposeTextField.borderStyle = .roundedRect
        infoDebtView.addSubview(purposeTextField)
    }

    fileprivate func setupDateContainer() {
        dateContainerView.backgroundColor = .white
        dateContainerView.layer.cornerRadius = 12
        contentView.addSubview(dateContainerView)

        dateTitleLabel.text = "Due date"
        dateTitleLabel.font = standartFont16Bold
        dateTitleLabel.textColor = UIColor(named: "BlackCustomColor")
        dateContainerView.addSubview(dateTitleLabel)

        dateTextField.layer.cornerRadius = 14
        dateContainerView.addSubview(dateTextField)
    }

    fileprivate func setupDebtButton() {
        let title = "Add debt"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        addDebtButton.setAttributedTitle(attributedTitle, for: .normal)
        addDebtButton.backgroundColor = .systemBlue
        addDebtButton.setTitleColor(UIColor(named: "BlackCustomColor"), for: .normal)
        addDebtButton.layer.cornerRadius = 8
        contentView.addSubview(addDebtButton)
    }

    // swiftlint:disable function_body_length
    private func setupConstraints() {
        addDebtScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(addDebtButton.snp.bottom).offset(20)
        }

        infoDebtView.snp.makeConstraints { make in
            make.top.equalTo(amountInputContainerView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(310)
        }

        creditNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
        }

        creditNameTextField.snp.makeConstraints { make in
            make.top.equalTo(creditNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }

        purposeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(creditNameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }

        purposeTextField.snp.makeConstraints { make in
            make.top.equalTo(purposeTextLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        amountInputContainerView.snp.makeConstraints { make in
            make.top.equalTo(debtTypeView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(100)
        }

        amountTitleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }

        amountInputTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }

        debtTypeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(176)
        }

        debtTypeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.top.left.right.equalToSuperview().inset(21)
        }

        debtBorrowedButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(84)
            make.width.equalTo(153)
        }

        debtLentButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(84)
            make.width.equalTo(153)
        }

        dateContainerView.snp.makeConstraints { make in
            make.top.equalTo(infoDebtView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(92)
        }

        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }

        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel).offset(25)
            make.centerX.equalToSuperview()
        }

        addDebtButton.snp.makeConstraints { make in
            make.top.equalTo(dateContainerView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    // swiftlint:enable function_body_length
}

extension AddDebtViewController {
    var standartFont16Bold: UIFont {
        UIFont.systemFont(ofSize: 16, weight: .bold)
    }
}

#Preview {
    AddDebtViewController()
}
