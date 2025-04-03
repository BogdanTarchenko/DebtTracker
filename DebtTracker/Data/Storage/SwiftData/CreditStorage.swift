import Foundation
import SwiftData

@MainActor
final class CreditStorage: ObservableObject {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @Published private(set) var credits: [CreditModel] = []

    init() {
        do {
            modelContainer = try ModelContainer(
                for: CreditModel.self, PaymentModel.self,
                configurations: ModelConfiguration()
            )
            modelContext = modelContainer.mainContext
            _ = loadCredits()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func saveCredit(_ credit: CreditModel) {
        modelContext.insert(credit)
        do {
            try modelContext.save()
            DispatchQueue.main.async { _ = self.loadCredits() }
            print("Credit saved successfully: \(credit)")
        } catch {
            print("Error saving credit: \(error.localizedDescription)")
        }
    }

    func loadCredits() -> [CreditModel] {
        do {
            let loadedCredits = try modelContext.fetch(FetchDescriptor<CreditModel>())
            DispatchQueue.main.async { self.credits = loadedCredits }
            return loadedCredits
        } catch {
            print("Error loading credits: \(error.localizedDescription)")
            credits = []
            return []
        }
    }

    func loadCredit(by id: String) -> CreditModel? {
        credits.first { $0.id == id }
    }

    func addPayment(for creditId: String, with payment: PaymentModel) {
        do {
            let descriptor = FetchDescriptor<CreditModel>(
                predicate: #Predicate { $0.id == creditId }
            )

            guard let credit = try modelContext.fetch(descriptor).first else {
                print("Credit with id \(creditId) not found")
                return
            }

            credit.payments.append(payment)
            credit.depositedAmount += payment.amount

            try modelContext.save()
            DispatchQueue.main.async { _ = self.loadCredits() }

            print("Payment added successfully to credit: \(credit.name)")
        } catch {
            print("Error adding payment: \(error.localizedDescription)")
        }
    }

    func clearAllCredits() {
        do {
            for credit in credits {
                modelContext.delete(credit)
            }
            try modelContext.save()
            DispatchQueue.main.async { self.credits.removeAll() }
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
            DispatchQueue.main.async { _ = self.loadCredits() }
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
