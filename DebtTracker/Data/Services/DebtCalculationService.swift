import Foundation

// MARK: - DebtCalculationProvidable

protocol DebtCalculationProvidable: AnyObject {
    var totalTaken: Double { get set }
    var term: Double { get set }
    var interestRate: Double { get set }

    func setup(totalTaken: Double, term: Double, interestRate: Double)
    func calculateMonthlyPayment() -> Double
    func calculateOverpayment() -> Double
    func calculateTotalPaid() -> Double
}

// MARK: - DebtCalculationService

class DebtCalculationService: DebtCalculationProvidable {
    // MARK: - Properties

    var totalTaken: Double = 0.0
    var term: Double = 0.0
    var interestRate: Double = 0.0

    // MARK: - Methods

    func setup(totalTaken: Double, term: Double, interestRate: Double) {
        self.totalTaken = totalTaken
        self.term = term
        self.interestRate = interestRate
    }

    func calculateMonthlyPayment() -> Double {
        let monthlyRate = interestRate / 12 / 100
        let numerator = monthlyRate * pow(1 + monthlyRate, term)
        let denominator = pow(1 + monthlyRate, term) - 1
        let coefficient = numerator / denominator
        let monthlyPayment = totalTaken * coefficient
        return monthlyPayment
    }

    func calculateOverpayment() -> Double {
        let totalPaid = calculateTotalPaid()
        let overpayment = totalPaid - totalTaken
        return overpayment
    }

    func calculateTotalPaid() -> Double {
        let monthlyPayment = calculateMonthlyPayment()
        let totalPaid = monthlyPayment * term
        return totalPaid
    }
}
