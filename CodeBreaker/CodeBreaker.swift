//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by JD on 8/19/26.
//

import SwiftUI

/// A single peg in the game, represented by its color.
typealias Peg = Color

/// Manages the state and logic for an active code-breaking match.
struct CodeBreaker {
    
    /// The secret code the player has to guess.
    var masterCode: Code
    
    /// The player's active guess attempt.
    var guess: Code
    
    /// A list of the player's previous guess codes.
    var attempts = [Code]()
    
    /// The list of peg colors available for player guesses.
    let pegChoices: [Peg]

    /// Initializes a new game with the specified peg choices, code length, and randomized master code.
    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow], numberOfPegs: Int = 4) {
        self.pegChoices = pegChoices
        Code.setNumberOfPegs(to: numberOfPegs)
        masterCode = Code(kind: .master)
        guess = Code(kind: .guess)
        masterCode.randomize(from: pegChoices)
    }
    
    /// Resets the game state to begin a new match.
    mutating func restartGame() {
        Code.setNumberOfPegs(to: Int.random(in: 3...6))
        masterCode = Code(kind: .master)
        guess = Code(kind: .guess)
        attempts = [Code]()
        masterCode.randomize(from: pegChoices)
    }
    
    /// Submits the current guess and adds it to the attempts history.
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    /// Cycles or updates the peg at the specified position within the current pending guess.
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let pegIndex = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(pegIndex + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    /// Returns true if the guess attempt has no pegs chosen; otherwise, false.
    func isGuessAttemptBlank() -> Bool {
        guess.pegs.filter { $0 != Code.missing }.count < 1
    }
    
    /// Returns true if an identical peg configuration exists in attempts; otherwise, false.
    func isDuplicateAttempt() -> Bool {
        attempts.contains { $0.pegs == guess.pegs }
    }
}

/// A combination of pegs and its role in a code-breaker game.
struct Code {
    
    /// The functional role of the code within the game.
    var kind: Kind
    
    /// The ordered sequence of pegs making up the combination.
    /// Initial pegs are empty or missing.
    var pegs: [Peg] = Array(repeating: Code.missing, count: Code.numberOfPegs)
    
    /// A placeholder peg used to represent an empty or missing slot in a combination.
    static let missing: Peg = .clear
    
    /// The length of the code
    private static var numberOfPegs: Int = 4
    
    /// The functional role or purpose of a peg combination.
    enum Kind: Equatable {
        
        /// The secret combination that the player is trying to guess.
        case master
        
        /// A current, unsubmitted guess made by the player.
        case guess
        
        /// A previously submitted guess that has been made.
        case attempt([Match])
        
        /// A placeholder state for an uninitialized or invalid code.
        case unknown
    }
    
    /// Sets the length of the code, if the value falls within the valid range.
    static func setNumberOfPegs(to numberOfPegs: Int) {
        if numberOfPegs > 2 && numberOfPegs < 7 {
            Self.numberOfPegs = numberOfPegs
        }
    }
    
    /// Randomizes the current pegs using choices from the specified pool.
    /// If the pool is empty, assigns a missing placeholder peg.
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    /// Return the active matches for an `.attempt`; return empty otherwise.
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }

    /// Matches against another Code and returns an Array of Match that lineup with the various pegs.
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}
