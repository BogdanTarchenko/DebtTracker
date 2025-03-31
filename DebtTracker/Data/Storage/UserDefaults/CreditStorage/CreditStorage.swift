import Foundation

class CreditStorage {
    private let userDefaults = UserDefaults.standard
    private let creditKey = "savedCredits"

    func saveCredit(_ credit: CreditDTO) {
        var credits = loadCredits()
        credits.append(credit)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(credits)
            UserDefaults.standard.set(encodedData, forKey: creditKey)
            UserDefaults.standard.synchronize()
            print("Success saving: \(credit)")
        } catch {}
    }

    func loadCredits() -> [CreditDTO] {
        guard let savedData = userDefaults.data(forKey: creditKey) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([CreditDTO].self, from: savedData)
        } catch {
            print("Error loading: \(error.localizedDescription)")
            return []
        }
    }

    func clearAllCredits() {
        userDefaults.removeObject(forKey: creditKey)
        userDefaults.synchronize()
    }
}
