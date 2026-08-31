//
//  GameInitializationTests.swift
//  CodeBreaker
//
//  Created by JD on 8/31/26.
//

import Testing
@testable import CodeBreaker

struct GameInitializationTests {
    
    @Test("Initializer sets the default peg choices when no argument is passed")
    func testInitWithDefaultPegChoices() {
        // Create game with default peg choices
        let game = CodeBreaker()
        
        // Verifies that the initializer sets the default peg choices when no argument is passed
        let expectedDefaults: [Peg] = [.red, .green, .blue, .yellow]
        #expect(game.pegChoices == expectedDefaults)
    }
    
    @Test("Initializer sets the custom peg choies when an argument is passed")
    func testInitWithCustomPegChoices() {
        // Create game with custom peg choices
        let customPegChoices: [Peg] = [.red, .blue, .blue, .yellow]
        let game = CodeBreaker(pegChoices: customPegChoices)
        
        // Verifies that passing custom peg choices successfully updates the property
        #expect(game.pegChoices == customPegChoices)
    }
    
    @Test("Initializer randomizes the master code using only the allowed peg choices")
    func testInitGeneratesRandomizedCodes() {
        // Set the allowed peg choices
        let choices: [Peg] = [.red, .green, .blue, .yellow]
        
        // Generate 5 separate game instances
        let games = (1...5).map { _ in CodeBreaker(pegChoices: choices) }
        
        // Extract the raw peg arrays
        let codes = games.map { $0.masterCode.pegs }
        
        // Convert the list of arrays into a Set to filter out duplicates
        let uniqueCodes = Set(codes)
        
        // Verify that it's truly random, they shouldn't all be identical
        #expect(uniqueCodes.count > 1, "The initializer generated the exact same code every time. Is it hardcoded?")
    }

}
