import Charts
import SwiftData
import SwiftUI

// MARK: - StatsView

struct StatsView: View {
    private let creditStorage: CreditStorage = .init()

    // MARK: - Private Properties

    private var credits: [CreditModel] {
        creditStorage.loadCredits()
    }

    private func amount(for type: CreditTypeDTO) -> Double {
        credits.filter { $0.creditType == type }.reduce(0) { $0 + $1.amount }
    }

    // swiftlint:disable large_tuple
    private var creditTypes: [(title: String, amount: Double, color: Color)] {
        [
            (LocalizedKey.AddDebt.consumerLoan, amount(for: .consumer), Color(UIColor.App.purple)),
            (LocalizedKey.AddDebt.autoLoan, amount(for: .car), Color(UIColor.App.blue)),
            (LocalizedKey.AddDebt.mortgageLoan, amount(for: .mortgage), Color(UIColor.App.green)),
            (LocalizedKey.AddDebt.microLoan, amount(for: .microloan), Color(UIColor.App.orange))
        ]
    }

    // swiftlint:enable large_tuple

    private var totalAmount: Double {
        creditTypes.reduce(0) { sum, creditType in
            sum + Double(creditType.1)
        }
    }

    private var maxAmount: Double {
        let amounts = creditTypes.map(\.1)
        return Double(amounts.max() ?? 0)
    }

    private var minAmount: Double {
        let amounts = creditStorage.loadCredits().map(\.amount)
        return Double(amounts.min() ?? 0)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Metrics.sectionSpacing) {
                totalAmountView
                pieChartView
                additionalStatsView
            }
            .padding(.vertical)
            .padding(.bottom, Metrics.bottomPadding)
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizedKey.Stats.statsTitle)
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

private extension StatsView {
    @ViewBuilder
    var totalAmountView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.Stats.totalAmount)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Text("$ \(totalAmount, format: .number)")
                .font(.system(size: Metrics.totalAmountSize, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(Metrics.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    var pieChartView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.Stats.byTypeDistribution)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Chart {
                ForEach(creditTypes, id: \.0) { type in
                    SectorMark(
                        angle: .value(LocalizedKey.Stats.chartSum, type.1),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
                    )
                    .foregroundStyle(type.2)
                }
            }
            .frame(height: Metrics.chartHeight)
            .padding(.vertical, Metrics.chartPadding)

            VStack(alignment: .leading, spacing: Metrics.legendSpacing) {
                ForEach(creditTypes, id: \.0) { type in
                    HStack {
                        Circle()
                            .fill(type.2)
                            .frame(width: Metrics.legendDotSize, height: Metrics.legendDotSize)
                        Text(type.0)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("$ \(type.1, format: .number)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(Metrics.cardPadding)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.App.black),
                    Color(UIColor.App.black).opacity(Metrics.defaultLinearOpacity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }

    @ViewBuilder
    var additionalStatsView: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            HStack(spacing: Metrics.iconSpacing) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: Metrics.iconSize))
                    .foregroundColor(Color(UIColor.App.purple))
                Text(LocalizedKey.Stats.additionalInformation)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: Metrics.statsSpacing) {
                StatRow(
                    title: LocalizedKey.Stats.creditsAmount,
                    value: "\(credits.count)"
                )
                StatRow(
                    title: LocalizedKey.Stats.maxCredit,
                    value: "$ \(maxAmount)"
                )
                StatRow(
                    title: LocalizedKey.Stats.minCredit,
                    value: "$ \(minAmount)"
                )
            }
        }
        .padding(Metrics.cardPadding)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.App.black),
                    Color(UIColor.App.black).opacity(Metrics.defaultLinearOpacity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: Metrics.cornerRadius))
        .padding(.horizontal)
    }
}

// MARK: StatsView.Metrics

private extension StatsView {
    enum Metrics {
        static let bottomPadding: CGFloat = 64
        static let sectionSpacing: CGFloat = 16
        static let contentSpacing: CGFloat = 16
        static let iconSpacing: CGFloat = 8
        static let iconSize: CGFloat = 16
        static let totalAmountSize: CGFloat = 32
        static let chartHeight: CGFloat = 200
        static let chartPadding: CGFloat = 8
        static let legendSpacing: CGFloat = 12
        static let legendDotSize: CGFloat = 8
        static let statsSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 16
        static let defaultLinearOpacity: Double = 0.8
    }
}
