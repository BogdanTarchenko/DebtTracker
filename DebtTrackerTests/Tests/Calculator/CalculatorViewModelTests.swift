@testable import DebtTracker
import Testing

// MARK: - CalculatorViewModelTests

@MainActor
struct CalculatorViewModelTests {
    @Test func validateAmount_withValidInput_updatesAmount() async throws {
        // Arrange
        let mockRepository = MockCalculatorRepository()
        let useCase = CalculatorUseCase(repository: mockRepository)
        let viewModel = CalculatorViewModel(useCase: useCase)

        // Act
        viewModel.validateAmount("100000")

        // Assert
        #expect(viewModel.amount == 100_000)
        #expect(!viewModel.amountError)
    }

    @Test func validateAmount_withInvalidInput_setsError() async throws {
        // Arrange
        let mockRepository = MockCalculatorRepository()
        let useCase = CalculatorUseCase(repository: mockRepository)
        let viewModel = CalculatorViewModel(useCase: useCase)

        // Act
        viewModel.validateAmount("invalid")

        // Assert
        #expect(viewModel.amount == nil)
        #expect(viewModel.amountError)
    }

    @Test func calculate_withValidInputs_updatesResults() async throws {
        // Arrange
        let mockRepository = MockCalculatorRepository()
        mockRepository.monthlyPaymentToReturn = 8884.88
        mockRepository.overpaymentToReturn = 6618.56
        mockRepository.totalPaidToReturn = 106_618.56

        let useCase = CalculatorUseCase(repository: mockRepository)
        let viewModel = CalculatorViewModel(useCase: useCase)

        // Act
        viewModel.validateAmount("100000")
        viewModel.validateTerm("12")
        viewModel.validateRate("12")
        viewModel.calculate()

        // Assert
        #expect(abs(viewModel.monthlyPayment - 8884.88) < 0.01)
        #expect(abs(viewModel.overpayment - 6618.56) < 0.01)
        #expect(abs(viewModel.totalPaid - 106_618.56) < 0.01)
    }
}
