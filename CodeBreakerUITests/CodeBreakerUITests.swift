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

        // Target the first peg rectangle
        let firstPeg = app.buttons["guess_code_peg_0"]
        XCTAssertTrue(firstPeg.exists)

        // Read initial color (e.g., starting state is empty/blue)
        let initialColor = firstPeg.label
        XCTAssertEqual(initialColor, "green")

        // Change the peg color
        firstPeg.tap()

        // This dynamically waits up to 10 seconds for the label to update to "blue"
        let predicate = NSPredicate(format: "label == 'blue'")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: firstPeg)
        let result = XCTWaiter.wait(for: [expectation], timeout: 10.0)
        
        // Confirm the wait didn't time out
        XCTAssertEqual(result, .completed, "The peg label did not change to blue within 2 seconds.")

        // Assert the color string has changed to the next expected color
        let updatedColor = firstPeg.label
        XCTAssertNotEqual(initialColor, updatedColor)
        XCTAssertEqual(firstPeg.label, "blue")
    }

    func testAddPlayerAttemptOnGuessButtonTap() throws {
        let app = XCUIApplication()
        app.launch()

        // Locate the Guess button
        let guessButton = app.buttons["guessButton"]

        // Locate the Guess code pegs
        let guessFirstPeg = app.buttons["guess_code_peg_0"]
        let guessSecondPeg = app.buttons["guess_code_peg_1"]
        let guessThirdPeg = app.buttons["guess_code_peg_2"]
        let guessFourthPeg = app.buttons["guess_code_peg_3"]
        
        // Target the first attempt row container safely using otherElements
        let firstAttemptRow = app.scrollViews.otherElements["attempt_0"]

        // Verify initial game state
        XCTAssertTrue(guessButton.exists, "The Guess button should be visible.")
        XCTAssertTrue(guessFirstPeg.exists, "The first Guess code peg should be visible.")
        XCTAssertTrue(guessSecondPeg.exists, "The second Guess code peg should be visible.")
        XCTAssertTrue(guessThirdPeg.exists, "The third Guess code peg should be visible.")
        XCTAssertTrue(guessFourthPeg.exists, "The fourth Guess code peg should be visible.")
        XCTAssertFalse(firstAttemptRow.exists, "There should be no Attempt history pegs initially.")

        // Trigger the action
        guessButton.tap()
        
        // Verify the attempt history row is visible
        XCTAssertTrue(firstAttemptRow.waitForExistence(timeout: 10.0), "The attempt history row should appear after tapping Guess.")
        
        // Locate the first attempt rows pegs
        let attemptFirstPeg = firstAttemptRow.buttons["code_peg_0"]
        let attemptSecondPeg = firstAttemptRow.buttons["code_peg_1"]
        let attemptThirdPeg = firstAttemptRow.buttons["code_peg_2"]
        let attemptFourthPeg = firstAttemptRow.buttons["code_peg_3"]
        
        // Verify Attempt code pegs are visible
        XCTAssertTrue(attemptFirstPeg.waitForExistence(timeout: 10.0), "The first peg inside the attempt history row should be visible.")
        XCTAssertTrue(attemptSecondPeg.waitForExistence(timeout: 10.0), "The second peg inside the attempt history row should be visible.")
        XCTAssertTrue(attemptThirdPeg.waitForExistence(timeout: 10.0), "The third peg inside the attempt history row should be visible.")
        XCTAssertTrue(attemptFourthPeg.waitForExistence(timeout: 10.0), "The fourth peg inside the attempt history row should be visible.")
       
        // Verify Guess and Attempt pegs match
        XCTAssertEqual(guessFirstPeg.label, attemptFirstPeg.label)
        XCTAssertEqual(guessSecondPeg.label, attemptSecondPeg.label)
        XCTAssertEqual(guessThirdPeg.label, attemptThirdPeg.label)
        XCTAssertEqual(guessFourthPeg.label, attemptFourthPeg.label)
    }
    
    func testShowAttemptExactMatchMarker() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Locate the Guess button
        let guessButton = app.buttons["guessButton"]
        
        // Target the attempt row container safely using otherElements
        let container = app.scrollViews.otherElements["attempt_0"]
        
        // Verify initial game state (should not exist before clicking guess)
        XCTAssertFalse(container.exists, "There should be no Attempt history pegs initially.")
        
        // Trigger the guess
        guessButton.tap()
        
        // Verify the attempt container appears
        XCTAssertTrue(container.waitForExistence(timeout: 10.0), "The attempt history row should appear after tapping Guess.")
        
        // Query for the button trait directly within that specific container
        let attemptFirstPeg = container.buttons["code_peg_0"]
        
        // Verify Attempt code first peg is visible and accessible
        XCTAssertTrue(attemptFirstPeg.waitForExistence(timeout: 10.0), "The first peg inside the attempt history row should be visible.")
        
        // Locate first Match Marker peg that is associated with the Attempt code
        let matchMarkerFirstPeg = container.descendants(matching: .any)["match_marker_0"]
        
        // Verify Match Marker first peg assocaited with the Attempt code is visible
        XCTAssertTrue(matchMarkerFirstPeg.waitForExistence(timeout: 10.0), "The Match Marker first peg associated with the attempt history row should be visible.")
        
        // Verify Match Marker first peg assocaited with the Attempt code is an exact match
        let matchMarkerFirstPegValue = matchMarkerFirstPeg.value as? String
        XCTAssertEqual(matchMarkerFirstPegValue, "exact", "The accessibility value did not match 'exact'.")
    }
    
}
