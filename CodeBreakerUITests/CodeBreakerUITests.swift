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
        
        // Assert the color string has changed to the next expected color
        let updatedColor = firstPeg.label
        XCTAssertNotEqual(initialColor, updatedColor)
        XCTAssertEqual(firstPeg.label, "blue")
    }
}
