// MARK: - CalculatorUseCaseProtocol

protocol CalculatorUseCaseProtocol {
    func calculate(amount: Double, term: Double, interestRate: Double) -> DebtCalculation
    func saveCalculation(_ calculation: DebtCalculation) async throws
}

// MARK: - CalculatorUseCase

final class CalculatorUseCase: CalculatorUseCaseProtocol {
    private let repository: CalculatorRepositoryProtocol

    init(repository: CalculatorRepositoryProtocol) {
        self.repository = repository
    }

    func calculate(amount: Double, term: Double, interestRate: Double) -> DebtCalculation {
        let monthlyPayment = repository.calculateMonthlyPayment(
            amount: amount,
            term: term,
            interestRate: interestRate
        )

        let overpayment = repository.calculateOverpayment(
            monthlyPayment: monthlyPayment,
            term: term,
            amount: amount
        )

        let totalPaid = repository.calculateTotalPaid(
            monthlyPayment: monthlyPayment,
            term: term
        )

        return DebtCalculation(
            totalAmount: amount,
            term: term,
            interestRate: interestRate,
            monthlyPayment: monthlyPayment,
            overpayment: overpayment,
            totalPaid: totalPaid
        )
    }

    func saveCalculation(_ calculation: DebtCalculation) async throws {
        try await repository.saveCalculation(calculation)
    }
}
