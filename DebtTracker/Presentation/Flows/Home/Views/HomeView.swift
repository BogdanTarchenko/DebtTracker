import SwiftData
import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    // MARK: - Private Properties

    @State private var selectedCategory: String?
    @State private var showingCategoryMenu = false
    @State private var isDebtDetailsPresented: Bool = false
    @State private var selectedDebtId: CreditModel?
    @State private var refreshTrigger = false
    @StateObject private var creditStorage: CreditStorage = .init()

    private let creditCategories = [
        LocalizedKey.AddDebt.consumerLoan,
        LocalizedKey.AddDebt.autoLoan,
        LocalizedKey.AddDebt.mortgageLoan,
        LocalizedKey.AddDebt.microLoan
    ]

    // MARK: - Body

    var body: some View {
        var totalDebt: Double {
            creditStorage.loadCredits().reduce(0) { $0 + $1.amount }
        }

        ScrollView {
            VStack(spacing: Metrics.sectionSpacing) {
                debtCardView(totalDebt: "$ " + formatAmount(totalDebt))
                loanInfoView()
                creditsHeaderView
                creditsGridView
                loansHeaderView
                loansGridView
                Spacer()
            }
            .padding(.vertical)
            .padding(.bottom, Metrics.bottomPadding)
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizedKey.Home.homeTitle)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.App.white))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.App.purple))
                }
            }
        }
        .toolbarBackground(Color(UIColor.App.black), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onReceive(NotificationCenter.default.publisher(for: .creditAdded)) { _ in
            refreshTrigger = refreshTrigger == false ? true : false
            Task { await creditStorage.updateCredits() }
        }
        .sheet(item: $selectedDebtId) {
            DebtDetailsView(credit: $0)
                .background(.black)
        }
    }
}

// MARK: - View Components

private extension HomeView {
    @ViewBuilder
    var creditsHeaderView: some View {
        HStack {
            Text(LocalizedKey.Home.credits)
                .font(.title2)
                .bold()
                .foregroundColor(Color(UIColor.App.white))
            Spacer()
            categoryMenuView
        }
        .padding(.top)
        .padding(.horizontal)
    }

    @ViewBuilder
    var categoryMenuView: some View {
        Menu {
            ForEach(creditCategories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    HStack {
                        Text(category)
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: Metrics.menuIconSpacing) {
                Text(selectedCategory ?? LocalizedKey.Home.pickType)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.purple))
                Image(systemName: "chevron.down")
                    .font(.system(size: Metrics.menuIconSize))
                    .foregroundColor(Color(UIColor.App.purple))
            }
        }
    }

    @ViewBuilder
    var creditsGridView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: Metrics.gridSpacing
        ) {
            ForEach(creditStorage.loadCredits().filter { $0.creditTarget == .taken }) { credit in
                creditCardView(
                    credit: credit,
                    title: credit.name,
                    amount: credit.amount,
                    paidAmount: credit.depositedAmount,
                    progressColor: .purple
                )
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var loansHeaderView: some View {
        HStack {
            Text(LocalizedKey.Home.loans)
                .font(.title2)
                .bold()
                .foregroundColor(Color(UIColor.App.white))
            Spacer()
            categoryMenuView
        }
        .padding(.top)
        .padding(.horizontal)
    }

    @ViewBuilder
    var loansGridView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: Metrics.gridSpacing
        ) {
            ForEach(creditStorage.loadCredits().filter { $0.creditTarget == .given }) { credit in
                creditCardView(
                    credit: credit,
                    title: credit.name,
                    amount: credit.amount,
                    paidAmount: credit.depositedAmount,
                    progressColor: .purple
                )
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func debtCardView(totalDebt: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.cardContentSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Metrics.textSpacing) {
                    Text(LocalizedKey.Home.totalDebt)
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.App.white).opacity(0.7))

                    Text(totalDebt)
                        .font(.system(size: Metrics.totalDebtSize, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                Image(systemName: "dollarsign.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(UIColor.App.purple))
                    .frame(width: Metrics.debtIconSize, height: Metrics.debtIconSize)
                    .background(Color(UIColor.App.purple).opacity(0.2))
                    .clipShape(Circle())
            }

            HStack(spacing: Metrics.debtInfoSpacing) {
                nextPaymentView
            }
        }
        .padding(Metrics.cardPadding)
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
        .padding(.horizontal)
    }

    @ViewBuilder
    private var debtChangeView: some View {
        VStack(alignment: .leading, spacing: Metrics.textSpacing) {
            Text(LocalizedKey.Home.monthlyDifferent)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            HStack(spacing: Metrics.textSpacing) {
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                Text("+2.4%")
                    .font(.subheadline)
                    .bold()
            }
            .foregroundColor(Color(UIColor.App.red))
        }
    }

    @ViewBuilder
    private var nextPaymentView: some View {
        var nextPaymentInfo: (amount: Double, date: String) {
            let currentDate = Date()
            let calendar = Calendar.current

            let futureCredits = creditStorage.loadCredits()
                .compactMap { credit -> (amount: Double, paymentDate: Date)? in
                    var nextPaymentDate = credit.startDate
                    while nextPaymentDate <= currentDate {
                        let newDate = calendar.date(byAdding: .month, value: 1, to: nextPaymentDate)
                        nextPaymentDate = newDate ?? Date.now
                    }
                    return (amount: credit.amount, paymentDate: nextPaymentDate)
                }
                .sorted {
                    $0.paymentDate < $1.paymentDate
                }

            if let nextPayment = futureCredits.first {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                dateFormatter.locale = Locale(identifier: "ru_RU")
                let dateString = dateFormatter.string(from: nextPayment.paymentDate)

                return (nextPayment.amount, dateString)
            }
            return (0, "")
        }

        VStack(alignment: .leading, spacing: Metrics.textSpacing) {
            Text(LocalizedKey.Home.nextPaymentDate)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            HStack(spacing: Metrics.textSpacing) {
                Text("\(formatAmount(nextPaymentInfo.amount))")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.App.white))
                Text("•")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.purple))
                Text(nextPaymentInfo.date)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.purple))
            }
        }
    }

    @ViewBuilder
    func loanInfoView() -> some View {
        VStack(alignment: .leading, spacing: Metrics.cardContentSpacing) {
            Text(LocalizedKey.Home.debts)
                .font(.headline)
                .foregroundColor(Color(UIColor.App.white))

            HStack(spacing: Metrics.loanInfoSpacing) {
                let creditsList = creditStorage.loadCredits()
                var takenAmount: Double {
                    creditsList.filter { $0.creditTarget == .taken }.reduce(0) { $0 + $1.amount }
                }
                loanTypeView(
                    icon: "creditcard.fill",
                    title: LocalizedKey.Home.takenLoans,
                    count: creditStorage.loadCredits().filter { $0.creditTarget == .taken }.count,
                    amount: formatAmount(takenAmount)
                )

                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: Metrics.dividerWidth, height: Metrics.dividerHeight)

                var givenAmount: Double {
                    creditsList.filter { $0.creditTarget == .given }.reduce(0) { $0 + $1.amount }
                }
                loanTypeView(
                    icon: "person.2.fill",
                    title: LocalizedKey.Home.givenLoans,
                    count: creditStorage.loadCredits().filter { $0.creditTarget == .given }.count,
                    amount: formatAmount(givenAmount)
                )
            }
        }
        .padding(.horizontal, Metrics.loanInfoHorizontalPadding)
        .padding(.vertical, Metrics.loanInfoVerticalPadding)
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
        .padding(.horizontal)
    }

    @ViewBuilder
    private func loanTypeView(
        icon: String,
        title: String,
        count: Int,
        amount: String
    ) -> some View {
        VStack(alignment: .leading, spacing: Metrics.loanTypeSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: Metrics.loanIconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: Metrics.textSpacing) {
                Text("\(count)")
                    .font(.system(size: Metrics.loanCountSize, weight: .bold))
                    .foregroundColor(Color(UIColor.App.white))
                Text("$ \(amount)")
                    .font(.system(size: Metrics.loanAmountSize, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func creditCardView(
        credit: CreditModel,
        title: String,
        amount: Double,
        paidAmount: Double,
        progressColor: Color
    ) -> some View {
        Button(action: {
            isDebtDetailsPresented = true
            selectedDebtId = credit
        }) {
            VStack(alignment: .leading, spacing: Metrics.cardContentSpacing) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(UIColor.App.white))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.App.purple))
                }

                VStack(alignment: .leading, spacing: Metrics.textSpacing) {
                    Text("\(String(format: "%.2f", amount)) $")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(UIColor.App.white))

                    Text("\(LocalizedKey.Home.paidAmout): \(String(format: "%.2f", paidAmount))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                ProgressView(value: min(max(paidAmount / amount, 0), 1))
                    .tint(progressColor)
                    .frame(height: Metrics.progressHeight)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(Metrics.progressCornerRadius)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: Metrics.creditCardHeight)
            .background(Color(UIColor.App.black))
            .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        }
    }
}

// MARK: HomeView.Metrics

private extension HomeView {
    enum Metrics {
        static let bottomPadding: CGFloat = 64
        static let sectionSpacing: CGFloat = 16
        static let gridSpacing: CGFloat = 16
        static let cardContentSpacing: CGFloat = 12
        static let textSpacing: CGFloat = 4
        static let iconSpacing: CGFloat = 6
        static let menuIconSpacing: CGFloat = 4
        static let menuIconSize: CGFloat = 12
        static let debtIconSize: CGFloat = 48
        static let debtInfoSpacing: CGFloat = 16
        static let loanInfoSpacing: CGFloat = 16
        static let loanTypeSpacing: CGFloat = 6
        static let loanIconSize: CGFloat = 14
        static let loanCountSize: CGFloat = 22
        static let loanAmountSize: CGFloat = 18
        static let dividerWidth: CGFloat = 1
        static let dividerHeight: CGFloat = 32
        static let loanInfoHorizontalPadding: CGFloat = 16
        static let loanInfoVerticalPadding: CGFloat = 12
        static let totalDebtSize: CGFloat = 32
        static let progressHeight: CGFloat = 4
        static let progressCornerRadius: CGFloat = 2
        static let creditCardHeight: CGFloat = 120
        static let cardPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 16
    }
}
