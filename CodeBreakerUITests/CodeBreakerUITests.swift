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
        let firstPeg = guessCode.buttons["peg_0_green"]
        XCTAssertTrue(firstPeg.exists)
        
        // Change guess peg
        firstPeg.tap()
        
        // Verify the peg updated to the new state
        let updatedFirstPeg = guessCode.buttons["peg_0_blue"]
        XCTAssertTrue(updatedFirstPeg.waitForExistence(timeout: 10.0))
        XCTAssertFalse(firstPeg.exists)
    }

    func testAddPlayerAttemptOnGuessButtonTap() throws {
        let app = XCUIApplication()
        app.launch()

        // Verify guess button and code pegs are visible
        let guessButton = app.buttons["guess_button"]
        XCTAssertTrue(guessButton.exists)
        let guessCode = app.otherElements["guess_code"]
        let guessCodeFirstPeg = guessCode.buttons["peg_0_green"]
        XCTAssertTrue(guessCodeFirstPeg.exists)
        let guessCodeSecondPeg = guessCode.buttons["peg_1_red"]
        XCTAssertTrue(guessCodeSecondPeg.exists)
        let guessCodeThirdPeg = guessCode.buttons["peg_2_red"]
        XCTAssertTrue(guessCodeThirdPeg.exists)
        let guessCodeFourthPeg = guessCode.buttons["peg_3_yellow"]
        XCTAssertTrue(guessCodeFourthPeg.exists)
        
       // Verify attempt codes first row is not visible
        let attemptCodesFirstRow = app.otherElements["attempt_code_0"]
        XCTAssertFalse(attemptCodesFirstRow.exists)

        // Attempt guess
        guessButton.tap()
        
        // Verify attempt codes first row and guess code pegs match
        let attemptFirstPeg = attemptCodesFirstRow.buttons["peg_0_green"]
        XCTAssertTrue(attemptFirstPeg.waitForExistence(timeout: 10.0))
        let attemptSecondPeg = attemptCodesFirstRow.buttons["peg_1_red"]
        XCTAssertTrue(attemptSecondPeg.waitForExistence(timeout: 10.0))
        let attemptThirdPeg = attemptCodesFirstRow.buttons["peg_2_red"]
        XCTAssertTrue(attemptThirdPeg.waitForExistence(timeout: 10.0))
        let attemptFourthPeg = attemptCodesFirstRow.buttons["peg_3_yellow"]
        XCTAssertTrue(attemptFourthPeg.waitForExistence(timeout: 10.0))
    }
    
    func testShowAttemptExactMatchMarker() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify guess button is visible
        let guessButton = app.buttons["guess_button"]
        XCTAssertTrue(guessButton.exists)
        
        // Verify attempt codes first row is not visible
        let attemptCodesFirstRow = app.otherElements["attempt_code_0"]
        XCTAssertFalse(attemptCodesFirstRow.exists)
        
        // Attempt guess
        guessButton.tap()
        
        // Verify match marker pegs assocaited with the attempt code are exact matches
        let matchMarkerFirstPeg = attemptCodesFirstRow.otherElements["match_marker_peg_0_exact"]
        XCTAssertTrue(matchMarkerFirstPeg.waitForExistence(timeout: 10.0))
        let matchMarkerSecondPeg = attemptCodesFirstRow.otherElements["match_marker_peg_0_exact"]
        XCTAssertTrue(matchMarkerSecondPeg.waitForExistence(timeout: 10.0))
        let matchMarkerThirdPeg = attemptCodesFirstRow.otherElements["match_marker_peg_0_exact"]
        XCTAssertTrue(matchMarkerThirdPeg.waitForExistence(timeout: 10.0))
        let matchMarkerFourthPeg = attemptCodesFirstRow.otherElements["match_marker_peg_0_exact"]
        XCTAssertTrue(matchMarkerFourthPeg.waitForExistence(timeout: 10.0))
    }
    
}
