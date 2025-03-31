import Foundation

// MARK: - LocalizedKey

struct LocalizedKey: RawRepresentable {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }
}

// MARK: LocalizedKey.Main

extension LocalizedKey {
    enum Main {
        static let homeViewControllerTitle = LocalizedKey(
            rawValue: "main_home_view_controller_title"
        ).localized
    }

    enum Home {
        static let homeTitle = LocalizedKey(
            rawValue: "home_title"
        ).localized

        static let credits = LocalizedKey(
            rawValue: "home_credits"
        ).localized

        static let pickType = LocalizedKey(
            rawValue: "home_pick_type"
        ).localized

        static let paidAmout = LocalizedKey(
            rawValue: "home_paid_amout"
        ).localized

        static let totalDebt = LocalizedKey(
            rawValue: "home_total_debt"
        ).localized

        static let monthlyDifferent = LocalizedKey(
            rawValue: "home_monthly_different"
        ).localized

        static let nextPaymentDate = LocalizedKey(
            rawValue: "home_next_payment_date"
        ).localized

        static let debts = LocalizedKey(
            rawValue: "home_debts"
        ).localized

        static let givenLoans = LocalizedKey(
            rawValue: "home_given_loans"
        ).localized

        static let takenLoans = LocalizedKey(
            rawValue: "home_taken_loans"
        ).localized
    }

    enum Stats {
        static let statsTitle = LocalizedKey(
            rawValue: "stats_title"
        ).localized

        static let totalAmount = LocalizedKey(
            rawValue: "stats_total_amount"
        ).localized

        static let byTypeDistribution = LocalizedKey(
            rawValue: "stats_by_type_distribution"
        ).localized

        static let chartSum = LocalizedKey(
            rawValue: "stats_chart_sum"
        ).localized

        static let additionalInformation = LocalizedKey(
            rawValue: "stats_additional_information"
        ).localized

        static let creditsAmount = LocalizedKey(
            rawValue: "stats_credits_amount"
        ).localized

        static let maxCredit = LocalizedKey(
            rawValue: "stats_max_credit"
        ).localized

        static let minCredit = LocalizedKey(
            rawValue: "stats_min_credit"
        ).localized
    }

    enum Calculator {
        static let title = LocalizedKey(
            rawValue: "calculator_title"
        ).localized

        static let creditSum = LocalizedKey(
            rawValue: "calculator_credit_sum"
        ).localized

        static let loanPercentage = LocalizedKey(
            rawValue: "calculator_loan_percentage"
        ).localized

        static let periodInMonths = LocalizedKey(
            rawValue: "calculator_period_in_months"
        ).localized

        static let calculateButtonTitle = LocalizedKey(
            rawValue: "calculator_calculate_button_title"
        ).localized

        static let monthlyPayment = LocalizedKey(
            rawValue: "calculator_monthly_payment"
        ).localized

        static let overPayment = LocalizedKey(
            rawValue: "calculator_over_payment"
        ).localized

        static let totalDebtAmount = LocalizedKey(
            rawValue: "calculator_total_debt_amount"
        ).localized

        static let validateText = LocalizedKey(
            rawValue: "validate_text"
        ).localized
    }

    enum AddDebt {
        static let consumerLoan = LocalizedKey(
            rawValue: "consumer_loan"
        ).localized
        static let autoLoan = LocalizedKey(
            rawValue: "auto_loan"
        ).localized
        static let mortgageLoan = LocalizedKey(
            rawValue: "mortgage_loan"
        ).localized
        static let microLoan = LocalizedKey(
            rawValue: "micro_loan"
        ).localized
        static let title = LocalizedKey(
            rawValue: "add_debt_title"
        ).localized

        static let givenLoan = LocalizedKey(
            rawValue: "add_debt_given_loan"
        ).localized

        static let takenLoan = LocalizedKey(
            rawValue: "add_debt_taken_loan"
        ).localized

        static let debtSum = LocalizedKey(
            rawValue: "add_debt_debt_sum"
        ).localized

        static let depositedAmount = LocalizedKey(
            rawValue: "add_debt_deposited_amount"
        ).localized

        static let information = LocalizedKey(
            rawValue: "add_debt_information"
        ).localized

        static let debtName = LocalizedKey(
            rawValue: "add_debt_debt_name"
        ).localized

        static let enterDebtNamePlaceholder = LocalizedKey(
            rawValue: "add_debt_enter_debt_name_placeholder"
        ).localized

        static let debtType = LocalizedKey(
            rawValue: "add_debt_debt_type"
        ).localized

        static let loanPercentage = LocalizedKey(
            rawValue: "add_debt_loan_percentage"
        ).localized

        static let periodInMonths = LocalizedKey(
            rawValue: "add_debt_period_in_months"
        ).localized

        static let debtTakenDate = LocalizedKey(
            rawValue: "add_debt_debt_taken_date"
        ).localized

        static let addDebtButtonTitle = LocalizedKey(
            rawValue: "add_debt_add_debt_button_title"
        ).localized
    }

    enum Settings {
        static let title = LocalizedKey(
            rawValue: "settings_title"
        ).localized

        static let passwordTitle = LocalizedKey(
            rawValue: "settings_password_title"
        ).localized

        static let faceIDTitle = LocalizedKey(
            rawValue: "settings_face_id_title"
        ).localized

        static let changePassword = LocalizedKey(
            rawValue: "settings_change_password"
        ).localized
    }

    enum PasswordInput {
        static let verifyTitle = LocalizedKey(
            rawValue: "password_input.verify_title"
        ).localized

        static let createTitle = LocalizedKey(
            rawValue: "password_input.create_title"
        ).localized

        static let confirmationTitle = LocalizedKey(
            rawValue: "password_input.confirmation_title"
        ).localized

        static let dontMatch = LocalizedKey(
            rawValue: "password_input.dont_match"
        ).localized

        static let saveError = LocalizedKey(
            rawValue: "password_input.save_error"
        ).localized

        static let wrongPassword = LocalizedKey(
            rawValue: "password_input.wrong_password"
        ).localized

        static let enterPassword = LocalizedKey(
            rawValue: "password_input.enter_password"
        ).localized
    }

    enum DebtDetails {
        static let loanRate = LocalizedKey(
            rawValue: "loan_rate"
        ).localized
        static let loanTerm = LocalizedKey(
            rawValue: "loan_term"
        ).localized
        static let openedDate = LocalizedKey(
            rawValue: "opened_date"
        ).localized
        static let nextPayment = LocalizedKey(
            rawValue: "next_payment"
        ).localized
        static let addTransaction = LocalizedKey(
            rawValue: "add_transaction"
        ).localized
        static let creditAmount = LocalizedKey(
            rawValue: "credit_amount"
        ).localized
        static let paymentProgress = LocalizedKey(
            rawValue: "payment_progress"
        ).localized
        static let remain = LocalizedKey(
            rawValue: "remain"
        ).localized
        static let paid = LocalizedKey(
            rawValue: "paid"
        ).localized
        static let paymentHistory = LocalizedKey(
            rawValue: "payment_history"
        ).localized
    }
}
