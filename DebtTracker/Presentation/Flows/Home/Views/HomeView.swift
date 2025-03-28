import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    // MARK: - Private Properties

    @State private var selectedCategory: String?
    @State private var showingCategoryMenu = false
    @State private var isDebtDetailsPresented: Bool = false

    private let creditCategories = [
        LocalizedKey.AddDebt.consumerLoan,
        LocalizedKey.AddDebt.autoLoan,
        LocalizedKey.AddDebt.mortgageLoan,
        LocalizedKey.AddDebt.microLoan
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Metrics.sectionSpacing) {
                debtCardView(totalDebt: "$ 25 000")
                loanInfoView(activeLoans: 5, nextPayment: "$ 17 000", paymentDate: "Март 27")
                creditsHeaderView
                creditsGridView
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
        .sheet(isPresented: $isDebtDetailsPresented) {
            DebtDetailsView()
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
            creditCardView(
                title: "Iphone 13 Mini",
                amount: "699$",
                paidAmount: "350$",
                progressColor: Color(UIColor.App.purple)
            )
            creditCardView(
                title: "Macbook Pro M1",
                amount: "1,499$",
                paidAmount: "750$",
                progressColor: Color(UIColor.App.purple)
            )
            creditCardView(
                title: "Car",
                amount: "1,499$",
                paidAmount: "1,000$",
                progressColor: Color(UIColor.App.purple)
            )
            creditCardView(
                title: "House",
                amount: "1,499$",
                paidAmount: "500$",
                progressColor: Color(UIColor.App.purple)
            )
            creditCardView(
                title: "Yandex",
                amount: "1,499$",
                paidAmount: "1,200$",
                progressColor: Color(UIColor.App.purple)
            )
            creditCardView(
                title: "Watch",
                amount: "1,499$",
                paidAmount: "800$",
                progressColor: Color(UIColor.App.purple)
            )
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
                debtChangeView
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
        VStack(alignment: .leading, spacing: Metrics.textSpacing) {
            Text(LocalizedKey.Home.nextPaymentDate)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            HStack(spacing: Metrics.textSpacing) {
                Text("$ 17 000")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.App.white))
                Text("•")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.purple))
                Text("27 марта")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.App.purple))
            }
        }
    }

    @ViewBuilder
    func loanInfoView(
        activeLoans: Int,
        nextPayment: String,
        paymentDate: String
    ) -> some View {
        VStack(alignment: .leading, spacing: Metrics.cardContentSpacing) {
            Text(LocalizedKey.Home.debts)
                .font(.headline)
                .foregroundColor(Color(UIColor.App.white))

            HStack(spacing: Metrics.loanInfoSpacing) {
                loanTypeView(
                    icon: "creditcard.fill",
                    title: LocalizedKey.Home.takenLoans,
                    count: activeLoans,
                    amount: formatAmount(25000)
                )

                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: Metrics.dividerWidth, height: Metrics.dividerHeight)

                loanTypeView(
                    icon: "person.2.fill",
                    title: LocalizedKey.Home.givenLoans,
                    count: 3,
                    amount: formatAmount(15000)
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
        title: String,
        amount: String,
        paidAmount: String,
        progressColor: Color
    ) -> some View {
        Button(action: {
            isDebtDetailsPresented = true
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
                    Text(amount)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(UIColor.App.white))

                    Text("\(LocalizedKey.Home.paidAmout): \(paidAmount)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                ProgressView(value: 0.5)
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
