import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                debtCardView(totalDebt: "25,000.40 $")
                loanInfoView(activeLoans: 5, nextPayment: "17,000", paymentDate: "Март 25")

                Text("Кредиты")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    creditCardView(title: "Iphone 13 Mini", amount: "699$", progressColor: .red)
                    creditCardView(title: "Macbook Pro M1", amount: "1,499$", progressColor: .pink)
                    creditCardView(title: "Car", amount: "1,499$", progressColor: .pink)
                    creditCardView(title: "House", amount: "1,499$", progressColor: .green)
                    creditCardView(title: "Yandex", amount: "1,499$", progressColor: .yellow)
                    creditCardView(title: "Watch", amount: "1,499$", progressColor: .brown)
                    creditCardView(title: "Iphone 13 Mini", amount: "699$", progressColor: .red)
                    creditCardView(title: "Macbook Pro M1", amount: "1,499$", progressColor: .pink)
                    creditCardView(title: "Car", amount: "1,499$", progressColor: .pink)
                    creditCardView(title: "House", amount: "1,499$", progressColor: .green)
                    creditCardView(title: "Yandex", amount: "1,499$", progressColor: .yellow)
                    creditCardView(title: "Watch", amount: "1,499$", progressColor: .brown)
                }
                Spacer()
            }
            .padding()
            .padding(.bottom, 80)
        }
        .background(Color(.systemGray6))
    }

    @ViewBuilder
    private func debtCardView(totalDebt: String) -> some View {
        VStack {
            Text("Общий долг")
                .font(.headline)
                .foregroundColor(.white)

            Text(totalDebt)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 128)
        .background(.black)
        .clipShape(.rect(cornerRadius: 16))
        .padding(.horizontal)
    }

    @ViewBuilder
    private func loanInfoView(
        activeLoans: Int,
        nextPayment: String,
        paymentDate: String
    ) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Активные займы")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(activeLoans)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()

            Spacer()

            VStack(alignment: .trailing) {
                Text("Следующий платёж")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("$ \(nextPayment) (\(paymentDate))")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 64)
        .background(.black)
        .clipShape(.rect(cornerRadius: 16))
        .padding(.horizontal)
    }

    @ViewBuilder
    private func creditCardView(title: String, amount: String, progressColor: Color) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            Text(amount)
                .font(.title3)
                .bold()
                .foregroundColor(.black)
            ProgressView(value: 0.5)
                .tint(progressColor)
                .frame(height: 5)
                .background(.gray.opacity(0.3))
                .cornerRadius(2.5)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
    }
}
