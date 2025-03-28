import SwiftUI

// MARK: - CalculatorView

struct CalculatorView: View {
    // MARK: - Private Properties

    @State private var inputAmount: Double?
    @State private var inputRate: Double?
    @State private var inputTerm: Double?

    private var monthlyPayment: Double {
        0.0
    }

    private var totalInterest: Double {
        0.0
    }

    private var totalPayment: Double {
        0.0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Metrics.sectionSpacing) {
                calculatorInputsView
                calculatorResultsView
            }
            .padding(.vertical)
            .padding(.bottom, Metrics.bottomPadding)
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizedKey.Calculator.title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
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
                value: $inputAmount,
                icon: "dollarsign.circle.fill",
                keyboardType: .decimalPad
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.loanPercentage,
                value: $inputRate,
                icon: "percent",
                keyboardType: .decimalPad
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.periodInMonths,
                value: $inputTerm,
                icon: "calendar",
                keyboardType: .numberPad
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
                .foregroundColor(.white)
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
        value: Binding<Double?>,
        icon: String,
        keyboardType: UIKeyboardType
    ) -> some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            TextField("", value: value, format: .number)
                .keyboardType(keyboardType)
                .font(.system(size: Metrics.inputFontSize, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(Metrics.inputCornerRadius)
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
                        .foregroundColor(.white)
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
    func calculatePayments() {}
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
