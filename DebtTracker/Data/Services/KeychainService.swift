import Foundation
import Security

class KeychainService {
    // MARK: - Constants

    private enum Constants {
        static let passwordKey = "com.debttracker.password"
    }

    // MARK: - Public Methods

    static func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func load(key: String) -> Data? {
        guard let kCFBooleanTrue else { return nil }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess ? dataTypeRef as? Data : nil
    }

    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }

    static func update(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }

    // MARK: - Convenience Methods

    static func saveString(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }

    static func loadString(key: String) -> String? {
        guard let data = load(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Password Methods

    static func hasPassword() -> Bool {
        loadString(key: Constants.passwordKey) != nil
    }

    static func verifyPassword(_ password: String) -> Bool {
        loadString(key: Constants.passwordKey) == password
    }

    static func savePassword(_ password: String) -> Bool {
        saveString(key: Constants.passwordKey, value: password)
    }

    static func getPassword() -> String {
        loadString(key: Constants.passwordKey) ?? "No pass in keychain"
    }

    static func disablePassword() -> Bool {
        delete(key: Constants.passwordKey)
    }
}
