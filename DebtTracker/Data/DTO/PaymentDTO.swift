import Foundation

struct PaymentDTO: Codable {
    let id: String
    let amount: Double
    let date: Date
    let type: PaymentTypeDTO
}
