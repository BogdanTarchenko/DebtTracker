enum PaymentTypeDTO: String, Codable, CaseIterable {
    case monthlyAnnuity = "Ежемес. аннуитентный платёж"
    case monthlyDiff = "Ежемес. дифференцированный платёж"
    case lateFee = "Штраф за просрочку платежа"
    case insuranceFee = "Страховая премия"
    case earlyPayment = "Досрочное погашение"
}
