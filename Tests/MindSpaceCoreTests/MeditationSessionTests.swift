import XCTest
@testable import MindSpaceCore

final class MeditationSessionTests: XCTestCase {
    func testCountdownCompletesAndRecordsStats() {
        var s = MeditationSession(minutes: 1)
        XCTAssertEqual(s.timeString, "01:00")
        XCTAssertFalse(s.tick()) // not running
        s.start()
        for _ in 0..<59 { XCTAssertFalse(s.tick()) }
        XCTAssertEqual(s.timeString, "00:01")
        XCTAssertEqual(s.progress, 59.0 / 60.0, accuracy: 1e-9)
        XCTAssertTrue(s.tick())
        XCTAssertFalse(s.isRunning)
        XCTAssertEqual(s.sessionsCompleted, 1)
        XCTAssertEqual(s.totalMinutes, 1)
        XCTAssertEqual(s.secondsRemaining, 60)
    }

    func testPauseResumeAndReset() {
        var s = MeditationSession(minutes: 3)
        s.start()
        s.tick(); s.tick()
        s.pause()
        s.tick()
        XCTAssertEqual(s.secondsRemaining, 178)
        s.start()
        s.tick()
        XCTAssertEqual(s.timeString, "02:57")
        s.reset()
        XCTAssertEqual(s.secondsRemaining, 180)
        XCTAssertFalse(s.isRunning)
    }

    func testSelectIsIgnoredWhileRunningOrInvalid() {
        var s = MeditationSession()
        XCTAssertEqual(s.selectedMinutes, 5)
        s.select(minutes: 7)
        XCTAssertEqual(s.selectedMinutes, 5)
        s.select(minutes: 10)
        XCTAssertEqual(s.secondsRemaining, 600)
        s.start()
        s.select(minutes: 1)
        XCTAssertEqual(s.selectedMinutes, 10)
        XCTAssertEqual(MeditationSession(minutes: 2).selectedMinutes, 5)
    }
}
