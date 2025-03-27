import SwiftUI

struct CalculatorViewController: View {
    @Binding var inputAmount: String
    @Binding var inputRate: String
    @Binding var inputTerm: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            Text("Calculate your monthly payments and total amount").lineLimit(10)
                .fontWidth(.standard)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 16, trailing: 24))
            VStack(spacing: 16) {
                InputField(
                    title: "Loan amount",
                    text: $inputAmount,
                    keyboardType: .decimalPad
                )
                InputField(
                    title: "Interest Rate",
                    text: $inputRate,
                    keyboardType: .decimalPad
                )
                InputField(
                    title: "Loan term",
                    text: $inputTerm,
                    keyboardType: .decimalPad
                )
                PrimaryButton(title: "Calculate", action: fc)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
            }
            .padding(EdgeInsets(
                top: 16,
                leading: 24,
                bottom: 0,
                trailing: 24
            ))
            .background(Color(UIColor.App.white))
            .cornerRadius(14)
            VStack {
                InfoCard(
                    title: "Monthly payment",
                    value: "$301.80",
                    color: Color(UIColor.App.red)
                )

                InfoCard(
                    title: "Monthly payment",
                    value: "$52.193",
                    color: Color(UIColor.App.yellow)
                )

                InfoCard(
                    title: "Monthly payment",
                    value: "$140.5",
                    color: Color(UIColor.App.blue)
                )
            }
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            .frame(height: 353)

            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(Color(.systemGray6))
    }

    func fc() {
        print("hello")
    }
}
