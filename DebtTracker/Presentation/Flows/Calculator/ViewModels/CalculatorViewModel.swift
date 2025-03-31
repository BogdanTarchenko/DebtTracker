import SwiftUI

@MainActor
final class CalculatorViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var amountText: String = ""
    @Published var termText: String = ""
    @Published var rateText: String = ""

    @Published var amount: Double?
    @Published var term: Double?
    @Published var rate: Double?

    @Published var amountError: Bool = false
    @Published var termError: Bool = false
    @Published var rateError: Bool = false

    @Published private(set) var monthlyPayment: Double = 0.0
    @Published private(set) var overpayment: Double = 0.0
    @Published private(set) var totalPaid: Double = 0.0

    // MARK: - Dependencies

    private let useCase: CalculatorUseCaseProtocol

    init(useCase: CalculatorUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Public Methods

    func calculate() {
        guard let amount,
              let term,
              let rate
        else {
            validateInputs()
            return
        }

        let result = useCase.calculate(
            amount: amount,
            term: term,
            interestRate: rate
        )

        monthlyPayment = result.monthlyPayment
        overpayment = result.overpayment
        totalPaid = result.totalPaid
    }

    func validateAmount(_ text: String) {
        if let value = Double(text) {
            amount = value
            amountError = false
        } else {
            amount = nil
            amountError = !text.isEmpty
        }
    }

    func validateTerm(_ text: String) {
        if let value = Double(text) {
            term = value
            termError = false
        } else {
            term = nil
            termError = !text.isEmpty
        }
    }

    func validateRate(_ text: String) {
        if let value = Double(text) {
            rate = value
            rateError = false
        } else {
            rate = nil
            rateError = !text.isEmpty
        }
    }

    // MARK: - Private Methods

    private func validateInputs() {
        amountError = amount == nil && !amountText.isEmpty
        termError = term == nil && !termText.isEmpty
        rateError = rate == nil && !rateText.isEmpty
    }
}
