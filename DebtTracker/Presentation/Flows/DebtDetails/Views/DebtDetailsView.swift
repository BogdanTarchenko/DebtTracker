import SwiftUI

struct DebtDetailsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DebtDetailsViewController {
        let controller = DebtDetailsViewController()
        updateUIViewController(controller, context: context)
        return controller
    }

    func updateUIViewController(_ controller: DebtDetailsViewController, context: Context) {}
}
