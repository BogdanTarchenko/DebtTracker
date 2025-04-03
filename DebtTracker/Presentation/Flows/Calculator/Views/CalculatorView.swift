import SwiftUI

// MARK: - CalculatorView

struct CalculatorView: View {
    @StateObject private var viewModel: CalculatorViewModel

    init(viewModel: CalculatorViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - View Components

private extension CalculatorView {
    @ViewBuilder
    var calculatorInputsView: some View {
        VStack(spacing: Metrics.contentSpacing) {
            calculatorInputView(
                title: LocalizedKey.Calculator.creditSum,
                text: $viewModel.amountText,
                error: viewModel.amountError,
                icon: "dollarsign.circle.fill",
                onTextChange: viewModel.validateAmount
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.loanPercentage,
                text: $viewModel.rateText,
                error: viewModel.rateError,
                icon: "percent",
                onTextChange: viewModel.validateRate
            )

            calculatorInputView(
                title: LocalizedKey.Calculator.periodInMonths,
                text: $viewModel.termText,
                error: viewModel.termError,
                icon: "calendar",
                onTextChange: viewModel.validateTerm
            )

            calculateButton
        }
        .padding(Metrics.cardPadding)
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var calculatorResultsView: some View {
        VStack(spacing: Metrics.resultSpacing) {
            calculatorResultView(
                title: LocalizedKey.Calculator.monthlyPayment,
                value: String(format: "$%.2f", viewModel.monthlyPayment),
                icon: "creditcard.fill"
            )

            calculatorResultView(
                title: LocalizedKey.Calculator.overPayment,
                value: String(format: "$%.2f", viewModel.overpayment),
                icon: "chart.line.uptrend.xyaxis"
            )

            calculatorResultView(
                title: LocalizedKey.Calculator.totalDebtAmount,
                value: String(format: "$%.2f", viewModel.totalPaid),
                icon: "dollarsign.circle.fill"
            )
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var calculateButton: some View {
        Button(action: viewModel.calculate) {
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
    func calculatorInputView(
        title: String,
        text: Binding<String>,
        error: Bool,
        icon: String,
        onTextChange: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: Metrics.inputSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.white).opacity(0.7))
            }

            ZStack(alignment: .trailing) {
                TextField("", text: text)
                    .keyboardType(.decimalPad)
                    .font(.system(size: Metrics.inputFontSize, weight: .bold))
                    .foregroundColor(Color(UIColor.App.white))
                    .padding()
                    .background(Color(UIColor.App.white).opacity(0.1))
                    .cornerRadius(Metrics.inputCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Metrics.inputCornerRadius)
                            .stroke(error ? Color.red : Color.clear, lineWidth: 1)
                    )
                    .onChange(of: text.wrappedValue) { _, newValue in
                        onTextChange(newValue)
                    }

                if error {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 8)
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
        .background(gradientBackground)
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
    }

    @ViewBuilder
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
