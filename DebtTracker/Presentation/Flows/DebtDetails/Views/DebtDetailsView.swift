import SwiftUI

struct DebtDetailsView: UIViewControllerRepresentable {
    var credit: CreditModel
    func makeUIViewController(context: Context) -> DebtDetailsViewController {
        let controller = DebtDetailsViewController(for: credit)
        return controller
    }

    func updateUIViewController(_ controller: DebtDetailsViewController, context: Context) {}
}
