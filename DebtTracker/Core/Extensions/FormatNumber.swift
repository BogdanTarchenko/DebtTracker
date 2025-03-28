func formatAmount(_ amount: Double) -> String {
    if amount >= 1_000_000 {
        return String(format: "%.1fM", amount / 1_000_000)
    } else if amount >= 1000 {
        return String(format: "%.1fK", amount / 1000)
    }
    return String(format: "%.0f", amount)
}
