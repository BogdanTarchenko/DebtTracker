import Foundation
import SwiftUI

class UsecaseValidateImpl {
    private let repository: RepositoryValidate

    init(repository: RepositoryValidate = RepositoryValidateImpl()) {
        self.repository = repository
    }

    func execute(text: String, value: Binding<Double?>, error: Binding<Bool>) {
        repository.validateInput(text: text, value: value, error: error)
    }
}
