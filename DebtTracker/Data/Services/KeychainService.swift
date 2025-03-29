import Foundation
import Security

class KeychainService {
    // MARK: - Public Methods

    /// Сохраняет данные в Keychain
    static func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Загружает данные из Keychain
    static func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne as String
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }

    /// Удаляет данные из Keychain
    static func delete(key: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    /// Обновляет данные в Keychain
    static func update(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key
        ] as [String: Any]

        let attributes = [
            kSecValueData as String: data
        ] as [String: Any]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        return status == errSecSuccess
    }

    // MARK: - Convenience Methods

    /// Сохраняет строку в Keychain
    static func saveString(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }

    /// Загружает строку из Keychain
    static func loadString(key: String) -> String? {
        guard let data = load(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func hasPassword() -> Bool {
        if loadString(key: "com.debttracker.password") != nil {
            true
        } else {
            false
        }
    }

    static func verifyPassword(_ password: String) -> Bool {
        if let pass = loadString(key: "com.debttracker.password") {
            if password == pass {
                true
            } else {
                false
            }
        } else {
            false
        }
    }

    static func savePassword(_ password: String) -> Bool {
        if saveString(key: "com.debttracker.password", value: password) {
            true
        } else {
            false
        }
    }
}
