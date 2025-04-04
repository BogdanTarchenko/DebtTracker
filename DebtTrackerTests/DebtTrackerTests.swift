@testable import DebtTracker
import SwiftUI
import Testing

struct DebtTrackerTests {
    @Test func testHomeViewBasicElements() async throws {
        _ = await HomeView()

        let title = LocalizedKey.Home.homeTitle
        #expect(title.isEmpty == false)

        let creditsTitle = LocalizedKey.Home.credits
        let loansTitle = LocalizedKey.Home.givenLoans
        let totalDebtTitle = LocalizedKey.Home.totalDebt

        #expect(creditsTitle.isEmpty == false)
        #expect(loansTitle.isEmpty == false)
        #expect(totalDebtTitle.isEmpty == false)
    }
}
