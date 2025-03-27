import SwiftUI

struct CalculatorView: View {
    @State private var inputAmount: Double = 0
    @State private var inputRate: Double = 0
    @State private var inputTerm: Double = 0

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
            VStack(alignment: .leading, spacing: 12) {
                Spacer()

                Text("Calculate your monthly payments and total amount")
                    .lineLimit(2)
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                VStack(spacing: 16) {
                    InputField(
                        title: "Loan amount",
                        value: $inputAmount,
                        keyboardType: .decimalPad
                    )

                    InputField(
                        title: "Interest Rate",
                        value: $inputRate,
                        keyboardType: .decimalPad
                    )

                    InputField(
                        title: "Loan term (months)",
                        value: $inputTerm,
                        keyboardType: .numberPad
                    )

                    PrimaryButton(title: "Calculate", action: calculatePayments)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                }
                .padding(.horizontal, 24)
                .background(Color(.systemBackground))
                .cornerRadius(14)

                VStack(spacing: 12) {
                    InfoCard(
                        title: "Monthly payment",
                        value: String(format: "$%.2f", monthlyPayment),
                        color: .red
                    )

                    InfoCard(
                        title: "Total interest",
                        value: String(format: "$%.2f", totalInterest),
                        color: .blue
                    )

                    InfoCard(
                        title: "Total payment",
                        value: String(format: "$%.2f", totalPayment),
                        color: .green
                    )
                }
                .padding(.horizontal, 24)
                .transition(.slide)

                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .navigationBarHidden(false)
        .background(Color(.systemGray6))
    }

    private func calculatePayments() {}
}

#Preview {
    CalculatorView()
}
