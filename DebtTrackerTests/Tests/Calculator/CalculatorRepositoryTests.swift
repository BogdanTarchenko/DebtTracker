@testable import DebtTracker
import Testing

// MARK: - CalculatorRepositoryTests

struct CalculatorRepositoryTests {
    @Test func calculateMonthlyPayment_withValidInput_returnsCorrectAmount() async throws {
        // Arrange
        let repository = CalculatorRepository()
        let amount: Double = 100_000
        let term: Double = 12
        let interestRate: Double = 12

        // Act
        let monthlyPayment = repository.calculateMonthlyPayment(
            amount: amount,
            term: term,
            interestRate: interestRate
        )

        // Assert
        #expect(abs(monthlyPayment - 8884.88) < 0.01)
    }

    @Test func calculateOverpayment_withValidInput_returnsCorrectAmount() async throws {
        // Arrange
        let repository = CalculatorRepository()
        let monthlyPayment = 8884.88
        let term: Double = 12
        let amount: Double = 100_000

        // Act
        let overpayment = repository.calculateOverpayment(
            monthlyPayment: monthlyPayment,
            term: term,
            amount: amount
        )

        // Assert
        #expect(abs(overpayment - 6618.56) < 0.01)
    }
}
