import XCTest
@testable import TetrisEngine

final class TetrisEngineTests: XCTestCase {
    func testExample() throws {
        // Basic test to verify package builds
        let engine = TetrisEngine()
        XCTAssertEqual(engine.level, 0)
        XCTAssertEqual(engine.score, 0)
        XCTAssertFalse(engine.isGameOver)
    }
}
