import Foundation
import SwiftUI

protocol RepositoryValidate {
    func validateInput(text: String, value: Binding<Double?>, error: Binding<Bool>)
}
