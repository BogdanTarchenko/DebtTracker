import Foundation
import SwiftData

@Model
final class CreditModel {
    @Attribute(.unique) var id: String
    var name: String
    var amount: Double
    var depositedAmount: Double
    var percentage: Double
    var creditType: CreditTypeDTO
    var creditTarget: CreditTargetDTO
    var startDate: Date
    var period: Int
    var payments: [PaymentModel]

    init(
        id: String,
        name: String,
        amount: Double,
        depositedAmount: Double,
        percentage: Double,
        creditType: CreditTypeDTO,
        creditTarget: CreditTargetDTO,
        startDate: Date,
        period: Int,
        payments: [PaymentModel] = []
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.depositedAmount = depositedAmount
        self.percentage = percentage
        self.creditType = creditType
        self.creditTarget = creditTarget
        self.startDate = startDate
        self.period = period
        self.payments = payments
    }

    convenience init(from dto: CreditDTO) {
        let paymentModels = dto.payments.map { PaymentModel(from: $0) }
        self.init(
            id: dto.id,
            name: dto.name,
            amount: dto.amount,
            depositedAmount: dto.depositedAmount,
            percentage: dto.percentage,
            creditType: dto.creditType,
            creditTarget: dto.creditTarget,
            startDate: dto.startDate,
            period: dto.period,
            payments: paymentModels
        )
    }
}
