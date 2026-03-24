import XCTest
@testable import PointPro

final class TieBreakViewModelTests: XCTestCase {
    func testTieBreakFinalizationUpdatesExistingPlaceholder() {
        let match = MatchData()
        // create games to reach 6-6
        match.games = [GameScore(team1: 6, team2: 6, order: 0)]
        let vm = TieBreakViewModel(matchData: match)
        // simulate points to reach 8-6
        vm.tieBreakPointsA = 7
        vm.tieBreakPointsB = 6
        vm.sumPoint(team: 1) // A scores -> 8-6 and should finish
        XCTAssertTrue(vm.shouldDismiss)
        XCTAssertEqual(match.games.last?.team1, 8)
        XCTAssertEqual(match.games.last?.team2, 6)
    }
}
