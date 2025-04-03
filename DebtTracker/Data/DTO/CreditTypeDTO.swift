enum CreditTypeDTO: String, Codable {
    case consumer = LocalizedKey.AddDebt.consumerLoan
    case car = LocalizedKey.AddDebt.autoLoan
    case mortgage = LocalizedKey.AddDebt.mortgageLoan
    case microloan = LocalizedKey.AddDebt.microLoan
}
