//
//  GuessAttemptBlankTests.swift
//  CodeBreaker
//
//  Created by JD on 9/1/26.
//

import Testing
import SwiftUI
@testable import CodeBreaker

struct GuessAttemptBlankTests {
    
    @Test("isGuessAttemptBlank returns false when one or more non-missing pegs are placed",
        arguments: [
            // Scenario 1: One non-missing peg at the start
            [.red, Code.missing, Code.missing, Code.missing],
            // Scenario 2: One non-missing peg in the middle
            [Code.missing, .green, Code.missing, Code.missing],
            // Scenario 3: One non-missing peg in the middle
            [Code.missing, Code.missing, .blue, Code.missing],
            // Scenario 4: One non-missing peg at the end
            [Code.missing, Code.missing, Code.missing, .yellow],
            // Scenario 5: All pegs are filled with active colors
            [Peg.red, .green, .blue, .yellow]
        ]
    )
    func test_isGuessAttemptBlank_returnsFalse_whenGuessHasActivePegs(pegs: [Peg]) {
        // Setup game state
        var game = CodeBreaker()
        game.guess.pegs = pegs
        
        // Verify guess attempt is not blank
        #expect(game.isGuessAttemptBlank() == false)
    }
    
    @Test("isGuessAttemptBlank returns true when all slots are explicitly missing")
    func test_isGuessAttemptBlank_returnsTrue_whenAllPegsAreMissing() {
        // Setup game state
        var game = CodeBreaker()
        game.guess.pegs = [Code.missing, Code.missing, Code.missing, Code.missing]
        
        // Verify guess attempt is blank
        #expect(game.isGuessAttemptBlank() == true)
    }
    
    @Test("isGuessAttemptBlank returns true on a freshly initialized game instance")
    func test_isGuessAttemptBlank_returnsTrue_uponInitialization() {
        // Setup game state
        let game = CodeBreaker()
        
        // Verify initial guess attempt is blank
        #expect(game.isGuessAttemptBlank() == true)
    }
    
    @Test("isGuessAttemptBlank returns true if the guess pegs array is completely empty")
    func test_isGuessAttemptBlank_returnsTrue_whenPegsArrayIsEmpty() {
        // Setup game state
        var sut = CodeBreaker(pegChoices: [.red, .green, .blue, .yellow])
        sut.guess.pegs = []
        
        // Verify guess attempt is blank
        #expect(sut.isGuessAttemptBlank() == true)
    }
    
}
