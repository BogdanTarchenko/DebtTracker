import SwiftUI

struct InfoCard: View {
    var title: String
    var value: String
    var color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.App.white))
            }
            Spacer()
        }
        .padding()
        .background(color)
        .cornerRadius(10)
    }
}
