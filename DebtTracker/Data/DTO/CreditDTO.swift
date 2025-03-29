import Foundation

struct CreditDTO: Codable {
    let id: String
    let name: String
    let amount: Double
    let percentage: Double
    let creditType: CreditTypeDTO
    let creditTarget: CreditTargetDTO
    let startDate: Date
    let endDate: Date
    let payments: [PaymentDTO]
}
