//
//  CodeBreakerUITests.swift
//  CodeBreakerUITests
//
//  Created by JD on 8/21/26.
//

import XCTest

final class CodeBreakerUITests: XCTestCase {
    
    func testPegColorChangesOnTap() {
        let app = XCUIApplication()
        app.launch()
        
        // Target the first peg rectangle
        let firstPeg = app.buttons["guess_code_peg_0"]
        XCTAssertTrue(firstPeg.exists)

        // Read initial color (e.g., starting state is empty/blue)
        let initialColor = firstPeg.label
        XCTAssertEqual(initialColor, "green")

        // Change the peg color
        firstPeg.tap()

        // This dynamically waits up to 2 seconds for the label to update to "blue"
        let predicate = NSPredicate(format: "label == 'blue'")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: firstPeg)
        let result = XCTWaiter.wait(for: [expectation], timeout: 2.0)
    
        // Confirm the wait didn't time out
        XCTAssertEqual(result, .completed, "The peg label did not change to blue within 2 seconds.")
        
        // Assert the color string has changed to the next expected color
        let updatedColor = firstPeg.label
        XCTAssertNotEqual(initialColor, updatedColor)
        XCTAssertEqual(firstPeg.label, "blue")
    }
}
