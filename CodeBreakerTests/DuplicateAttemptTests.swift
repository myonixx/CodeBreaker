//
//  DuplicateAttemptTests.swift
//  CodeBreaker
//
//  Created by JD on 9/1/26.
//

import Testing
import SwiftUI
@testable import CodeBreaker

struct DuplicateAttemptTests {
    
    @Test("Returns false when there are no past attempts")
    func testNoPastAttempts() {
        // Setup game state
        var game = CodeBreaker()
        game.guess.pegs = [.red, .blue, .green, .yellow]
        
        // Verify there are no duplicate attempts
        #expect(game.isDuplicateAttempt() == false)
    }
    
    @Test("Returns true when the current guess exactly matches a previous attempt")
    func testMatchingPastAttempt() {
        // Setup game state
        var game = CodeBreaker()
        let pegs = [Color.red, .blue, .green, .yellow]
        game.guess.pegs = pegs
        
        // Add a matching Code to history (matching the pegs sequence)
        var pastAttempt = Code(kind: .attempt([]))
        pastAttempt.pegs = pegs
        game.attempts = [pastAttempt]
        
        // Verify duplicate attempt exists
        #expect(game.isDuplicateAttempt() == true)
    }
    
    @Test("Returns false when past attempts exist but none have matching pegs")
    func testNonMatchingPastAttempts() {
        // Setup game state
        var game = CodeBreaker()
        let guessAttemptPegs = [
            [Color.red, .blue, .green, .yellow],
            [.yellow, .yellow, .yellow, .yellow],
            [.yellow, .green, .blue, .red]
        ]
        
        // Attempt multiple guesses
        for pegs in guessAttemptPegs {
            // Set guess attempt
            game.guess.pegs = pegs
            // Attempt guess
            game.attemptGuess()
        }
        
        // Clear/reset current guess attempt
        game.guess.pegs = []
        
        // Verify there are no duplicate attempts
        #expect(game.isDuplicateAttempt() == false)
    }
    
    @Test("Returns true when a guess is submitted, cleared, and then re-entered")
    func testDuplicateAfterLifecycle() {
        // Setup game state
        var game = CodeBreaker()
        game.guess.pegs = [.red, .red, .green, .green]
        
        // Attempt guess
        game.attemptGuess()
        
        // Reset or change the active guess back to the same pattern
        game.guess.pegs = [.red, .red, .green, .green]
        
        // Verify duplicate attempt exists
        #expect(game.isDuplicateAttempt() == true)
    }
}
