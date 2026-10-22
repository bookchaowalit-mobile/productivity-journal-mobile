import XCTest
@testable import MindSpaceCore

/// Mood metadata and the persisted JSON shape of entries. `JournalStore` saves
/// `[JournalEntry]` with a default `JSONEncoder` into UserDefaults, so these
/// tests pin the stored format: changing it would drop users' saved entries.
final class MoodAndEntryTests: XCTestCase {
    func testMoodScoresAreOrderedFiveToOne() {
        XCTAssertEqual(Mood.allCases.map(\.score), [5, 4, 3, 2, 1])
    }

    func testEveryMoodHasADistinctEmoji() {
        let emojis = Mood.allCases.map(\.emoji)
        XCTAssertEqual(Set(emojis).count, Mood.allCases.count)
        XCTAssertFalse(emojis.contains(""))
    }

    func testMoodEncodesAsItsRawValue() throws {
        let data = try JSONEncoder().encode([Mood.low])
        XCTAssertEqual(String(decoding: data, as: UTF8.self), #"["Low"]"#)
        XCTAssertThrowsError(try JSONDecoder().decode([Mood].self, from: Data(#"["Meh"]"#.utf8)))
    }

    func testDecodesTheStoredEntryFormat() throws {
        let json = #"""
        [{"id":"8A1F2B9C-3D4E-4F50-8A6B-7C8D9E0F1A2B","title":"Morning","content":"Slept well",
          "mood":"Great","date":0,"tags":["sleep","home"]}]
        """#
        let entries = try JSONDecoder().decode([JournalEntry].self, from: Data(json.utf8))
        XCTAssertEqual(entries.count, 1)
        let e = try XCTUnwrap(entries.first)
        XCTAssertEqual(e.id, UUID(uuidString: "8A1F2B9C-3D4E-4F50-8A6B-7C8D9E0F1A2B"))
        XCTAssertEqual(e.title, "Morning")
        XCTAssertEqual(e.mood, .great)
        XCTAssertEqual(e.date, Date(timeIntervalSinceReferenceDate: 0))
        XCTAssertEqual(e.tags, ["sleep", "home"])
    }

    func testParseTagsHandlesHashWithSpaceAndCase() {
        XCTAssertEqual(JournalStats.parseTags("# Work, WORK,#,  , Gym "), ["work", "gym"])
    }

    func testSearchMatchesContentAndKeepsNewestFirst() {
        let old = JournalEntry(title: "A", content: "Ran 5k", mood: .good, date: Date(timeIntervalSince1970: 10))
        let new = JournalEntry(title: "B", content: "rest day", mood: .okay, date: Date(timeIntervalSince1970: 20))
        let other = JournalEntry(title: "C", content: "Reading", mood: .low, date: Date(timeIntervalSince1970: 30))
        XCTAssertEqual(JournalStats.search([old, other, new], "R").map(\.title), ["C", "B", "A"])
        XCTAssertEqual(JournalStats.search([old, other, new], "5K").map(\.title), ["A"])
        XCTAssertEqual(JournalStats.search([old, other, new], "swim"), [])
    }
}
