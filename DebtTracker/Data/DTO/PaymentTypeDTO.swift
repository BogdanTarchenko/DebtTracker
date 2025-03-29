enum PaymentTypeDTO: String, Codable {
    case monthlyAnnuity = "Ежемесячный аннуитентный платёж"
    case monthlyDiff = "Ежемесячный дифференцированный платёж"
    case lateFee = "Штраф за просрочку платежа"
    case insuranceFee = "Страховая премия"
    case earlyPayment = "Досрочное погашение"
}
