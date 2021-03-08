import XCTest
@testable import swift_ibc

final class swift_ibcTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_ibc().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
