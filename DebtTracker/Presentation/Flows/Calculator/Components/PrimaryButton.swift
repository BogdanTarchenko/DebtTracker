import SwiftUI

// MARK: - PrimaryButton

struct PrimaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(UIColor.App.white))
                .frame(maxWidth: 280)
                .padding()
                .background(Color(UIColor.App.blue))
                .cornerRadius(14)
        }
    }
}
