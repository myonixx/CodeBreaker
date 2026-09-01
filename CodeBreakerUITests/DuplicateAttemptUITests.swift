//
//  DuplicateAttemptUITests.swift
//  CodeBreaker
//
//  Created by JD on 9/1/26.
//

import XCTest

final class DuplicateAttemptUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_GuessButton_DuplicateCombinationEntered_IsDisabled() throws {
        // Verify guess button should be disabled initially because the guess is blank
        let guessButton = app.buttons["guess_button"]
        XCTAssertFalse(guessButton.isEnabled)
        
        // Verify tapping the guess code first slot updates peg from clear to red
        let guessCode = app.otherElements["guess_code"]
        var guessCodeFirstPeg = guessCode.buttons["peg_0_clear"]
        guessCodeFirstPeg.tap()
        guessCodeFirstPeg = guessCode.buttons["peg_0_red"]
        XCTAssertTrue(guessCodeFirstPeg.waitForExistence(timeout: 10.0))
        
        // Attempt guess
        guessButton.tap()
        
        // Verify new attempt history row with updated code peg should appear in the hierarchy
        let initialAttemptRow = app.otherElements["attempt_code_0"]
        let initialAttemptCodeFirstPeg = initialAttemptRow.buttons["peg_0_red"]
        XCTAssertTrue(initialAttemptCodeFirstPeg.waitForExistence(timeout: 10.0))
        
        // Verify the guess button is now disabled because the current guess code (which was not
        // cleared or reset) is a duplicate of a previous attempt in the history hierarchy.
        XCTAssertFalse(guessButton.isEnabled)
    }
    
}

