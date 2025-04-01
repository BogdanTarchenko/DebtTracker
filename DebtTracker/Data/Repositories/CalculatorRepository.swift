import Foundation

final class CalculatorRepository: CalculatorRepositoryProtocol {
    func calculateMonthlyPayment(
        amount: Double,
        term: Double,
        interestRate: Double
    ) -> Double {
        let monthlyRate = interestRate / 12 / 100
        let numerator = monthlyRate * pow(1 + monthlyRate, term)
        let denominator = pow(1 + monthlyRate, term) - 1
        let coefficient = numerator / denominator
        return amount * coefficient
    }

    func calculateOverpayment(
        monthlyPayment: Double,
        term: Double,
        amount: Double
    ) -> Double {
        let totalPaid = calculateTotalPaid(monthlyPayment: monthlyPayment, term: term)
        return totalPaid - amount
    }

    func calculateTotalPaid(
        monthlyPayment: Double,
        term: Double
    ) -> Double {
        monthlyPayment * term
    }

    func saveCalculation(_ calculation: DebtCalculation) async throws {}
}
