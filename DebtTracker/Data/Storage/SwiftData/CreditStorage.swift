import Foundation
import SwiftData

@MainActor
final class CreditStorage: ObservableObject {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private var needsUpdate: Bool = true

    @Published var credits: [CreditModel] = []

    init() {
        do {
            modelContainer = try ModelContainer(
                for: CreditModel.self, PaymentModel.self,
                configurations: ModelConfiguration()
            )
            modelContext = modelContainer.mainContext

            Task { await updateCredits() }
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func saveCredit(_ credit: CreditModel) {
        modelContext.insert(credit)
        do {
            try modelContext.save()

            needsUpdate = true
            Task { await updateCredits() }

            NotificationCenter.default.post(name: .creditAdded, object: nil)
            print("Credit saved successfully: \(credit)")
        } catch {
            print("Error saving credit: \(error.localizedDescription)")
        }
    }

    func loadCredits() -> [CreditModel] {
        do {
            let descriptor = FetchDescriptor<CreditModel>(
                sortBy: [SortDescriptor(\.startDate, order: .reverse)]
            )
            let loadedCredits = try modelContext.fetch(descriptor)

            if needsUpdate {
                Task { await updateCredits() }
            }

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

            if let index = credits.firstIndex(where: { $0.id == creditId }) {
                credits[index] = credit
            }

            needsUpdate = true
            if needsUpdate {
                Task { await updateCredits() }
            }

            NotificationCenter.default.post(name: .creditAdded, object: nil)

            print("Payment added successfully to credit: \(credit.name)")
        } catch {
            print("Error adding payment: \(error.localizedDescription)")
        }
    }

    func deleteCredit(for id: String) {
        do {
            let descriptor = FetchDescriptor<CreditModel>(
                predicate: #Predicate { $0.id == id }
            )

            guard let credit = try modelContext.fetch(descriptor).first else {
                print("Credit with id \(id) not found")
                return
            }

            modelContext.delete(credit)
            try modelContext.save()

            credits.removeAll { $0.id == id }

            let descriptorAfter = FetchDescriptor<CreditModel>(
                sortBy: [SortDescriptor(\.startDate, order: .reverse)]
            )
            credits = try modelContext.fetch(descriptorAfter)

            NotificationCenter.default.post(name: .creditAdded, object: nil)
            print("Credit deleted successfully: \(credit.name)")
        } catch {
            print("Error deleting credit: \(error.localizedDescription)")
        }
    }

    func clearAllCredits() {
        do {
            for credit in credits {
                modelContext.delete(credit)
            }
            try modelContext.save()
            credits.removeAll()
            print("clear")
        } catch {
            print("Error clearing credits: \(error.localizedDescription)")
        }
    }

    func updateCredits() async {
        do {
            let descriptor = FetchDescriptor<CreditModel>(
                sortBy: [SortDescriptor(\.startDate, order: .reverse)]
            )
            credits = try modelContext.fetch(descriptor)
            needsUpdate = false
        } catch {
            print("Error updating credits: \(error.localizedDescription)")
            credits = []
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
