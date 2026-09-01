//
//  GuessAttemptBlankUITests.swift
//  CodeBreaker
//
//  Created by JD on 9/1/26.
//

import XCTest

final class GuessAttemptBlankUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Stop immediately when a failure occurs to save CI/CD time
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_guessButtonStatus_isInitiallyDisabled_andEnablesOnPegTap() throws {
        // Verify guess button should be disabled initially because the guess is blank
        let guessButton = app.buttons["guess_button"]
        XCTAssertFalse(guessButton.isEnabled)
        
        // Taps the first peg slot (initially clear/missing)
        let guessCode = app.otherElements["guess_code"]
        let guessCodeFirstPeg = guessCode.buttons["peg_0_clear"]
        guessCodeFirstPeg.tap()
        
        // Verify the guess is no longer blank, so the guess button should become enabled
        XCTAssertTrue(guessButton.isEnabled)
    }
    
    func test_enablingAndTappingGuessButton_addsAnAttemptCodeToHistory() throws {
        // Verify guess button should be disabled initially because the guess is blank
        let guessButton = app.buttons["guess_button"]
        XCTAssertFalse(guessButton.isEnabled)
        
        // Taps the first peg slot (initially clear/missing)
        let guessCode = app.otherElements["guess_code"]
        let guessCodeFirstPeg = guessCode.buttons["peg_0_clear"]
        guessCodeFirstPeg.tap()
        
        // Verify initial attempts state: no history attempts should exist yet
         let initialAttemptRow = app.otherElements["attempt_code_0"]
         XCTAssertFalse(initialAttemptRow.exists)
        
        // Attempt guess
        guessButton.tap()
        
        // Verify new attempt history row should appear in the hierarchy
        XCTAssertTrue(initialAttemptRow.waitForExistence(timeout: 10.0))
    }
    
}
