import Foundation
import SwiftData

@MainActor
final class CreditStorage {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init() {
        do {
            modelContainer = try ModelContainer(
                for: CreditModel.self, PaymentModel.self,
                configurations: ModelConfiguration()
            )
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func saveCredit(_ credit: CreditModel) {
        modelContext.insert(credit)
        do {
            try modelContext.save()
            print("Credit saved successfully: \(credit)")
        } catch {
            print("Error saving credit: \(error.localizedDescription)")
        }
    }

    func loadCredits() -> [CreditModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<CreditModel>())
        } catch {
            print("Error loading credits: \(error.localizedDescription)")
            return []
        }
    }
    
    func loadCredit(by id: String) -> CreditModel? {
        do {
            let descriptor = FetchDescriptor<CreditModel>(
                predicate: #Predicate { $0.id == id }
            )
            return try modelContext.fetch(descriptor).first
        } catch {
            print("Error loading credit by ID: \(error.localizedDescription)")
            return nil
        }
    }

    func clearAllCredits() {
        do {
            let credits = try modelContext.fetch(FetchDescriptor<CreditModel>())
            for credit in credits {
                modelContext.delete(credit)
            }
            try modelContext.save()
        } catch {
            print("Error clearing credits: \(error.localizedDescription)")
        }
    }

    func setValue(_ value: some Any, forKey key: String, in credit: CreditModel) {
        switch key {
        case "name":
            credit.name = value as? String ?? credit.name
        case "amount":
            credit.amount = value as? Double ?? credit.amount
        case "depositedAmount":
            credit.depositedAmount = value as? Double ?? credit.depositedAmount
        case "percentage":
            credit.percentage = value as? Double ?? credit.percentage
        case "period":
            credit.period = value as? Int ?? credit.period
        default:
            print("Invalid key")
            return
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving updated credit: \(error.localizedDescription)")
        }
    }

    func getValue<T>(forKey key: String, from credit: CreditModel) -> T? {
        switch key {
        case "name":
            return credit.name as? T
        case "amount":
            return credit.amount as? T
        case "depositedAmount":
            return credit.depositedAmount as? T
        case "percentage":
            return credit.percentage as? T
        case "period":
            return credit.period as? T
        default:
            print("Invalid key")
            return nil
        }
    }
}
