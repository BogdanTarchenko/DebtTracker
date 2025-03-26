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
        static let homeViewControllerTitle = LocalizedKey(rawValue: "main_home_view_controller_title").localized
    }
}
