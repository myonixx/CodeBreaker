//
//  CodeBreakerTests.swift
//  CodeBreakerTests
//
//  Created by JD on 8/27/26.
//

import Testing
@testable import CodeBreaker

struct CodeBreakerTests {
    
    @Test("Changing a guess peg at an index updates its value to the next color")
    func testChangeGuessPeg() async throws {
        // Initial game state
        var game = CodeBreaker()
        
        // Change the guess peg at index 0
        game.changeGuessPeg(at: 0)
        
        // Verify it changed to the expected next color
        #expect(game.guess.pegs[0] == .blue)
    }
    
    @Test("Attempting a guess stores the code pegs, calculates the matches, and updates the history")
    func testAttemptGuess() {
        // Initial game state
        var game = CodeBreaker()
        
        // Ensure starting attempt history is empty
        #expect(game.attempts.isEmpty)

        // attempt a guess
        game.attemptGuess()

        // Verify that exactly one attempt was added to the history
        #expect(game.attempts.count == 1)
        
        // Grab the recorded attempt to inspect its internal properties
        let firstAttempt = game.attempts[0]
        
        // Verify attempt code pegs are correct
        #expect(firstAttempt.pegs == [.green, .red, .red, .yellow])
        
        // Verify attempt code matches are correct
        #expect(firstAttempt.matches == [.exact, .exact, .exact, .exact])
    }
    
}
