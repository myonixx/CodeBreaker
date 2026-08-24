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

        // Locate the Guess button and the first historical row identifier
        let guessButton = app.buttons["guessButton"]

        // Locate the Guess code pegs
        let guessFirstPeg = app.buttons["guess_code_peg_0"]
        let guessSecondPeg = app.buttons["guess_code_peg_1"]
        let guessThirdPeg = app.buttons["guess_code_peg_2"]
        let guessFourthPeg = app.buttons["guess_code_peg_3"]

        // Target the element type broadly to avoid layout wrapper mismatch issues
        let attemptFirstPeg = app.descendants(matching: .any)["attempt_code_peg_0"]
        let attemptSecondPeg = app.descendants(matching: .any)["attempt_code_peg_1"]
        let attemptThirdPeg = app.descendants(matching: .any)["attempt_code_peg_2"]
        let attemptFourthPeg = app.descendants(matching: .any)["attempt_code_peg_3"]

        // Verify initial game state
        XCTAssertTrue(guessButton.exists, "The Guess button should be visible.")
        XCTAssertTrue(guessFirstPeg.exists, "The first Guess code peg should be visible.")
        XCTAssertTrue(guessSecondPeg.exists, "The second Guess code peg should be visible.")
        XCTAssertTrue(guessThirdPeg.exists, "The third Guess code peg should be visible.")
        XCTAssertTrue(guessFourthPeg.exists, "The fourth Guess code peg should be visible.")
        XCTAssertFalse(attemptFirstPeg.exists, "There should be no Attempt history pegs initially.")
        XCTAssertFalse(attemptSecondPeg.exists, "There should be no Attempt history pegs initially.")
        XCTAssertFalse(attemptThirdPeg.exists, "There should be no Attempt history pegs initially.")
        XCTAssertFalse(attemptFourthPeg.exists, "There should be no Attempt history pegs initially.")

        // Trigger the action
        guessButton.tap()
       
        // Wait for the animated UI change to finish and assert the view appeared
        // GitHub Actions virtual macOS runners have lower CPU performance than
        // local machines, causing animations to lag or stutter. Use a timeout of
        // 10.0 seconds to prevent random timeout failures from slow runner loads
        XCTAssertTrue(attemptFirstPeg.waitForExistence(timeout: 10.0))
        XCTAssertTrue(attemptSecondPeg.waitForExistence(timeout: 10.0))
        XCTAssertTrue(attemptThirdPeg.waitForExistence(timeout: 10.0))
        XCTAssertTrue(attemptFourthPeg.waitForExistence(timeout: 10.0))
        
        // Verify Guess and Attempt pegs match
        XCTAssertEqual(guessFirstPeg.label, attemptFirstPeg.label)
        XCTAssertEqual(guessSecondPeg.label, attemptSecondPeg.label)
        XCTAssertEqual(guessThirdPeg.label, attemptThirdPeg.label)
        XCTAssertEqual(guessFourthPeg.label, attemptFourthPeg.label)
    }
}
