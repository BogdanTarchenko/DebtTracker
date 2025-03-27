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
}
