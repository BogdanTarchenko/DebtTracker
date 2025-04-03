import SwiftUI

// MARK: - AddDebtView

struct AddDebtView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss
    @State private var isBorrowed = true
    @State private var amount: Double?
    @State private var creditName = ""
    @State private var interestRate: Double?
    @State private var paidAmount: Double?
    @State private var selectedCreditType = LocalizedKey.AddDebt.consumerLoan
    @State private var startDate = Date()
    @State private var termMonths: Double?

    private let creditTypes = [
        LocalizedKey.AddDebt.consumerLoan,
        LocalizedKey.AddDebt.autoLoan,
        LocalizedKey.AddDebt.mortgageLoan,
        LocalizedKey.AddDebt.microLoan
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView {
                VStack(spacing: Metrics.sectionSpacing) {
                    debtTypeSelectorView
                    amountInputView
                    paidAmountView
                    creditInfoView
                    datePickerView
                    addButton
                }
                .padding(.vertical)
            }
            .background(Color.black)
        }
        .background(Color.black)
        .onTapGesture {
            UIApplication
                .shared
                .sendAction(#selector(UIResponder.resignFirstResponder),
                            to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - View Components

private extension AddDebtView {
    @ViewBuilder
    var headerView: some View {
        HStack {
            Spacer()
            Text(LocalizedKey.AddDebt.title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(.black)
    }

    @ViewBuilder
    var debtTypeSelectorView: some View {
        HStack(spacing: Metrics.contentSpacing) {
            debtTypeButton(
                title: LocalizedKey.AddDebt.takenLoan,
                icon: "creditcard.fill",
                isSelected: isBorrowed,
                action: { isBorrowed = true }
            )

            debtTypeButton(
                title: LocalizedKey.AddDebt.givenLoan,
                icon: "person.2.fill",
                isSelected: !isBorrowed,
                action: { isBorrowed = false }
            )
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var amountInputView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            Text(LocalizedKey.AddDebt.debtSum)
                .font(.headline)
                .foregroundColor(.white)

            TextField("", value: $amount, format: .number)
                .keyboardType(.decimalPad)
                .font(.system(size: Metrics.inputFontSize, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
        }
        .padding(Metrics.cardPadding)
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var paidAmountView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            Text(LocalizedKey.AddDebt.depositedAmount)
                .font(.headline)
                .foregroundColor(.white)

            TextField("", value: $paidAmount, format: .number)
                .keyboardType(.decimalPad)
                .font(.system(size: Metrics.inputFontSize, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
        }
        .padding(Metrics.cardPadding)
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var creditInfoView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            Text(LocalizedKey.AddDebt.information)
                .font(.headline)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
                creditNameField
                creditTypeMenu
                interestRateField
                termMonthsField
            }
        }
        .padding(Metrics.cardPadding)
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var creditNameField: some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "textformat")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.AddDebt.debtName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            TextField("", text: $creditName)
                .font(.system(size: Metrics.inputFontSize))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
        }
    }

    @ViewBuilder
    var creditTypeMenu: some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "tag.fill")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.AddDebt.debtType)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Menu {
                ForEach(creditTypes, id: \.self) { type in
                    Button(action: { selectedCreditType = type }) {
                        HStack {
                            Text(type)
                            if selectedCreditType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedCreditType)
                        .font(.system(size: Metrics.inputFontSize))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: Metrics.chevronSize))
                        .foregroundColor(Color(UIColor.App.purple))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
            }
        }
    }

    @ViewBuilder
    var interestRateField: some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "percent")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.AddDebt.loanPercentage)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            TextField("", value: $interestRate, format: .number)
                .keyboardType(.decimalPad)
                .font(.system(size: Metrics.inputFontSize))
                .foregroundColor(Color(UIColor.App.white))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
        }
    }

    @ViewBuilder
    var termMonthsField: some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "calendar")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.AddDebt.periodInMonths)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            TextField("", value: $termMonths, format: .number)
                .keyboardType(.numberPad)
                .font(.system(size: Metrics.inputFontSize))
                .foregroundColor(Color(UIColor.App.white))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
        }
    }

    @ViewBuilder
    var datePickerView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.AddDebt.debtTakenDate)
                    .font(.headline)
                    .foregroundColor(Color(UIColor.App.white))
            }

            DatePicker("", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(Color(UIColor.App.purple))
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, Metrics.datePickerPadding)
                .padding(.horizontal, Metrics.datePickerHorizontalPadding)
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
                .accentColor(Color(UIColor.App.purple))
                .colorScheme(.dark)
        }
        .padding(Metrics.cardPadding)
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var addButton: some View {
        Button(action: addDebt) {
            Text(LocalizedKey.AddDebt.addDebtButtonTitle)
                .font(.headline)
                .foregroundColor(Color(UIColor.App.white))
                .frame(maxWidth: .infinity)
                .frame(height: Metrics.buttonHeight)
                .background(Color(UIColor.App.purple))
                .cornerRadius(Metrics.buttonCornerRadius)
        }
        .padding(.horizontal)
        .padding(.top, Metrics.buttonTopPadding)
    }

    @ViewBuilder
    func debtTypeButton(
        title: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: Metrics.buttonIconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.buttonIconSize))
                Text(title)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Metrics.debtTypeButtonHeight)
            .background(isSelected ? Color(UIColor.App.purple) : Color.white.opacity(0.1))
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .cornerRadius(Metrics.buttonCornerRadius)
        }
    }
}

// MARK: - Private Methods

private extension AddDebtView {
    func addDebt() {
        guard !creditName.isEmpty,
              let amount, amount > 0
        else {
            return
        }

        let creditType: CreditTypeDTO = switch selectedCreditType {
        case LocalizedKey.AddDebt.consumerLoan:
            .consumer
        case LocalizedKey.AddDebt.autoLoan:
            .car
        case LocalizedKey.AddDebt.mortgageLoan:
            .mortgage
        case LocalizedKey.AddDebt.microLoan:
            .microloan
        default:
            .consumer
        }

        let credit = CreditModel(
            id: UUID().uuidString,
            name: creditName,
            amount: amount,
            depositedAmount: paidAmount ?? 0.0,
            percentage: interestRate ?? 0.0,
            creditType: creditType,
            creditTarget: isBorrowed ? .taken : .given,
            startDate: startDate,
            period: Int(termMonths ?? 0),
            payments: []
        )

        let storage = CreditStorage()
        storage.saveCredit(credit)

        dismiss()
    }
}

extension Notification.Name {
    static let creditAdded = Notification.Name("creditAdded")
}

// MARK: - Constants

private extension AddDebtView {
    enum Metrics {
        static let sectionSpacing: CGFloat = 16
        static let contentSpacing: CGFloat = 16
        static let inputSpacing: CGFloat = 8
        static let iconSpacing: CGFloat = 8
        static let buttonIconSpacing: CGFloat = 8
        static let buttonTopPadding: CGFloat = 8
        static let datePickerPadding: CGFloat = 12
        static let datePickerHorizontalPadding: CGFloat = 16

        static let iconSize: CGFloat = 16
        static let buttonIconSize: CGFloat = 24
        static let inputFontSize: CGFloat = 16
        static let chevronSize: CGFloat = 12

        static let buttonHeight: CGFloat = 50
        static let debtTypeButtonHeight: CGFloat = 84
        static let buttonCornerRadius: CGFloat = 12
        static let inputCornerRadius: CGFloat = 12
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 20
    }

    var gradientBackground: some View {
        LinearGradient(
            colors: [
                Color(UIColor.App.black),
                Color(UIColor.App.black).opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
