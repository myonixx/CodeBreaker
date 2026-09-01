//
//  CodeBreakerUITests.swift
//  CodeBreakerUITests
//
//  Created by JD on 8/21/26.
//

import XCTest

/// Note: GitHub Actions virtual macOS runners have lower CPU performance than local machines, causing animations
/// to lag or stutter. Use a timeout of 10.0 seconds to prevent random timeout failures from slow runner loads
final class CodeBreakerUITests: XCTestCase {

    func testPegColorChangesOnTap() {
        let app = XCUIApplication()
        app.launch()

        // Locate guess code and verify the first peg exists
        let guessCode = app.otherElements["guess_code"]
        let firstPeg = guessCode.buttons["peg_0_clear"]
        XCTAssertTrue(firstPeg.exists)
        
        // Change guess peg
        firstPeg.tap()
        
        // Verify the peg updated to the new state
        let updatedFirstPeg = guessCode.buttons["peg_0_red"]
        XCTAssertTrue(updatedFirstPeg.waitForExistence(timeout: 10.0))
        XCTAssertFalse(firstPeg.exists)
    }
    
}
