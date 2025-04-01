import Foundation
import SwiftData

@Model
final class PaymentModel {
    var id: String
    var amount: Double
    var date: Date
    var paymentType: PaymentTypeDTO

    init(id: String, amount: Double, date: Date, paymentType: PaymentTypeDTO) {
        self.id = id
        self.amount = amount
        self.date = date
        self.paymentType = paymentType
    }

    convenience init(from dto: PaymentDTO) {
        self.init(
            id: dto.id,
            amount: dto.amount,
            date: dto.date,
            paymentType: dto.type
        )
    }
}
