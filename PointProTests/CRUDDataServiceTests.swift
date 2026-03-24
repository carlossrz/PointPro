import XCTest
import SwiftData
@testable import PointPro

final class CRUDDataServiceTests: XCTestCase {
    var container: ModelContainer!

    override func setUpWithError() throws {
        let schema = Schema([MatchData.self, GameScore.self])
        container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testSaveAndDeleteMatch() throws {
        let match = MatchData()
        match.teammates = "Test"
        match.location = "Test Location"

        // Configure service with in-memory context
        CRUDDataService.shared.configure(container.mainContext)

        // Save
        CRUDDataService.shared.saveMatch(match)

        // Fetch using Query: use a FetchDescriptor
        let fetch = try container.mainContext.fetch(FetchDescriptor<MatchData>())
        XCTAssertEqual(fetch.count, 1)
        XCTAssertEqual(fetch.first?.teammates, "Test")

        // Delete
        CRUDDataService.shared.deleteMatch(match)
        let fetchAfterDelete = try container.mainContext.fetch(FetchDescriptor<MatchData>())
        XCTAssertEqual(fetchAfterDelete.count, 0)
    }
}
