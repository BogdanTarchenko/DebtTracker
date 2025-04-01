@testable import DebtTracker

// MARK: - MockCalculatorRepository

final class MockCalculatorRepository: CalculatorRepositoryProtocol {
    var monthlyPaymentToReturn: Double = 0
    var overpaymentToReturn: Double = 0
    var totalPaidToReturn: Double = 0

    var calculateMonthlyPaymentCallCount = 0
    var calculateOverpaymentCallCount = 0
    var calculateTotalPaidCallCount = 0
    var saveCalculationCallCount = 0

    func calculateMonthlyPayment(amount: Double, term: Double, interestRate: Double) -> Double {
        calculateMonthlyPaymentCallCount += 1
        return monthlyPaymentToReturn
    }

    func calculateOverpayment(monthlyPayment: Double, term: Double, amount: Double) -> Double {
        calculateOverpaymentCallCount += 1
        return overpaymentToReturn
    }

    func calculateTotalPaid(monthlyPayment: Double, term: Double) -> Double {
        calculateTotalPaidCallCount += 1
        return totalPaidToReturn
    }

    func saveCalculation(_ calculation: DebtCalculation) async throws {
        saveCalculationCallCount += 1
    }
}
