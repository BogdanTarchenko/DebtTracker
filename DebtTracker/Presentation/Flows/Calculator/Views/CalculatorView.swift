import SwiftUI

// MARK: - CalculatorView

struct CalculatorView: View {
    // MARK: - Private Properties

    @State private var inputAmount: Double?
    @State private var inputRate: Double?
    @State private var inputTerm: Double?

    @State private var amountText: String = ""
    @State private var rateText: String = ""
    @State private var termText: String = ""

    @State private var amountError: Bool = false
    @State private var rateError: Bool = false
    @State private var termError: Bool = false

    @State private var calculatedMonthlyPayment: Double = 0.0
    @State private var calculatedTotalInterest: Double = 0.0
    @State private var calculatedTotalPayment: Double = 0.0

    private var monthlyPayment: Double {
        calculatedMonthlyPayment
    }

    private var totalInterest: Double {
        calculatedTotalInterest
    }

    private var totalPayment: Double {
        calculatedTotalPayment
    }

    private let calculationService: DebtCalculationProvidable = DebtCalculationService()

    var body: some View {
        ScrollView {
            VStack(spacing: Metrics.sectionSpacing) {
                calculatorInputsView
                calculatorResultsView
            }
            .padding(.vertical)
            .padding(.bottom, Metrics.bottomPadding)
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizedKey.Calculator.title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.App.white))
            }
        }
        .toolbarBackground(Color(UIColor.App.black), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - View Components

private extension CalculatorView {
    @ViewBuilder
    var calculatorInputsView: some View {
        VStack(spacing: Metrics.contentSpacing) {
            calculatorInputView(
                title: LocalizedKey.Calculator.creditSum,
                text: $amountText,
                value: $inputAmount,
                error: $amountError,
                icon: "dollarsign.circle.fill"
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.loanPercentage,
                text: $rateText,
                value: $inputRate,
                error: $rateError,
                icon: "percent"
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.periodInMonths,
                text: $termText,
                value: $inputTerm,
                error: $termError,
                icon: "calendar"
            )

            calculateButton
        }
        .padding(Metrics.cardPadding)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.App.black),
                    Color(UIColor.App.black).opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var calculateButton: some View {
        Button(action: calculatePayments) {
            Text(LocalizedKey.Calculator.calculateButtonTitle)
                .font(.headline)
                .foregroundColor(Color(UIColor.App.white))
                .frame(maxWidth: .infinity)
                .frame(height: Metrics.buttonHeight)
                .background(Color(UIColor.App.purple))
                .cornerRadius(Metrics.buttonCornerRadius)
        }
    }

    @ViewBuilder
    var calculatorResultsView: some View {
        VStack(spacing: Metrics.resultSpacing) {
            calculatorResultView(
                title: LocalizedKey.Calculator.monthlyPayment,
                value: String(format: "$%.2f", monthlyPayment),
                icon: "creditcard.fill"
            )

            calculatorResultView(
                title: LocalizedKey.Calculator.overPayment,
                value: String(format: "$%.2f", totalInterest),
                icon: "chart.line.uptrend.xyaxis"
            )

            calculatorResultView(
                title: LocalizedKey.Calculator.totalDebtAmount,
                value: String(format: "$%.2f", totalPayment),
                icon: "dollarsign.circle.fill"
            )
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func calculatorInputView(
        title: String,
        text: Binding<String>,
        value: Binding<Double?>,
        error: Binding<Bool>,
        icon: String
    ) -> some View {
        let keyboardType: UIKeyboardType = .decimalPad
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.white).opacity(0.7))
            }

            let validateUsecase = UsecaseValidateImpl()

            ZStack(alignment: .trailing) {
                TextField("", text: text)
                    .keyboardType(keyboardType)
                    .font(.system(size: Metrics.inputFontSize, weight: .bold))
                    .foregroundColor(Color(UIColor.App.white))
                    .padding()
                    .background(Color(UIColor.App.white).opacity(0.1))
                    .cornerRadius(Metrics.inputCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Metrics.inputCornerRadius)
                            .stroke(error.wrappedValue ? Color.red : Color.clear, lineWidth: 1)
                    )
                    .onChange(of: text.wrappedValue) { _, newValue in
                        validateUsecase.execute(text: newValue, value: value, error: error)
                    }

                if error.wrappedValue {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 8)
                        .onTapGesture {
                            showErrorAlert(
                                title: "Error",
                                message: LocalizedKey.Calculator.validateText
                            )
                        }
                }
            }
        }
    }

    @ViewBuilder
    func calculatorResultView(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        HStack {
            HStack(spacing: Metrics.resultIconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.resultIconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                    .frame(width: Metrics.resultIconFrame, height: Metrics.resultIconFrame)
                    .background(Color(UIColor.App.purple).opacity(0.2))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: Metrics.textSpacing) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    Text(value)
                        .font(.system(size: Metrics.resultFontSize, weight: .bold))
                        .foregroundColor(Color(UIColor.App.white))
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.App.black),
                    Color(UIColor.App.black).opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
    }
}

// MARK: - Private Methods

private extension CalculatorView {
    func calculatePayments() {
        guard let inputAmount,
              let inputTerm,
              let inputRate else { return }
        calculationService.setup(totalTaken: inputAmount, term: inputTerm, interestRate: inputRate)

        let monthlyPayment = calculationService.calculateMonthlyPayment()
        let overpayment = calculationService.calculateOverpayment()
        let totalPaid = calculationService.calculateTotalPaid()

        calculatedMonthlyPayment = monthlyPayment
        calculatedTotalInterest = overpayment
        calculatedTotalPayment = totalPaid
    }

    func showErrorAlert(title: String, message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        rootViewController.present(alert, animated: true)
    }
}

// MARK: CalculatorView.Metrics

private extension CalculatorView {
    enum Metrics {
        static let bottomPadding: CGFloat = 64
        static let sectionSpacing: CGFloat = 16
        static let contentSpacing: CGFloat = 16
        static let resultSpacing: CGFloat = 12
        static let inputSpacing: CGFloat = 8
        static let iconSpacing: CGFloat = 8
        static let resultIconSpacing: CGFloat = 12
        static let textSpacing: CGFloat = 4

        static let iconSize: CGFloat = 16
        static let resultIconSize: CGFloat = 20
        static let resultIconFrame: CGFloat = 40
        static let inputFontSize: CGFloat = 20
        static let resultFontSize: CGFloat = 20

        static let buttonHeight: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 12
        static let inputCornerRadius: CGFloat = 12
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 20
    }
}
