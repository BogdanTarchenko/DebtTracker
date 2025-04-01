protocol CalculatorRepositoryProtocol {
    func calculateMonthlyPayment(amount: Double, term: Double, interestRate: Double) -> Double
    func calculateOverpayment(monthlyPayment: Double, term: Double, amount: Double) -> Double
    func calculateTotalPaid(monthlyPayment: Double, term: Double) -> Double
    func saveCalculation(_ calculation: DebtCalculation) async throws
}
