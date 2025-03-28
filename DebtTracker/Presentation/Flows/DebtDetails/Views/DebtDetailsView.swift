import SwiftUI

struct DebtDetailsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DebtDetailsViewController {
        let controller = DebtDetailsViewController()
        return controller
    }

    func updateUIViewController(_ controller: DebtDetailsViewController, context: Context) {}
}
