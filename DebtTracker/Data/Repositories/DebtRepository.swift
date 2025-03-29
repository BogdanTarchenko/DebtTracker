import Foundation
import SwiftUI

class RepositoryValidateImpl: RepositoryValidate {
    func validateInput(text: String, value: Binding<Double?>, error: Binding<Bool>) {
        if text.isEmpty {
            value.wrappedValue = nil
            error.wrappedValue = false
            return
        }

        if text == "." || text == "," {
            error.wrappedValue = true
            return
        }

        let allowedChars = "0123456789.,"
        let filtered = text.filter { allowedChars.contains($0) }

        if filtered != text {
            error.wrappedValue = true
            return
        }

        let unified = filtered.replacingOccurrences(of: ",", with: ".")

        let dotCount = unified.filter { $0 == "." }.count
        if dotCount > 1 {
            error.wrappedValue = true
            return
        }

        var correctedInput = unified
        if correctedInput.hasPrefix(".") {
            correctedInput = "0" + correctedInput
        }

        if let doubleValue = Double(correctedInput) {
            value.wrappedValue = doubleValue
            error.wrappedValue = false
        } else {
            error.wrappedValue = true
        }
    }
}
