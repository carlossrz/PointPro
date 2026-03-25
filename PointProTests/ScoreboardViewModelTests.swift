import XCTest
@testable import PointPro

final class ScoreboardViewModelTests: XCTestCase {
    func testIncrementPointsAndGameFinish() {
        let vm = ScoreboardViewModel()
        vm.matchData = MatchData()
        // Simulate team 1 scoring enough to win a game 6-0
        vm.team = 1
        for _ in 0..<4 { vm.sumPoint() } // 0->15->30->40->win -> triggers globalSumPoint
        // after winning 4 points at 0-0, globalPointA should be 1
        XCTAssertEqual(vm.globalPointA, 1)
    }
}
