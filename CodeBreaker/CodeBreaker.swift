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
    var masterCode = Code(kind: .master)
    
    /// The player's active guess attempt.
    var guess = Code(kind: .guess)
    
    /// A list of the player's previous guess codes.
    var attempts = [Code]()
    
    /// The list of peg colors available for player guesses.
    let pegChoices: [Peg]

    /// Sets up the available peg choices for the game and automatically
    /// generates a secret master code selected randomly from those choices.
    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow]) {
        self.pegChoices = pegChoices
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
}

/// A combination of pegs and its role in a code-breaker game.
struct Code {
    
    /// The functional role of the code within the game.
    var kind: Kind
    
    /// The ordered sequence of pegs making up the combination.
    var pegs: [Peg] = [.green, .red, .red, .yellow]
    
    /// A placeholder peg used to represent an empty or missing slot in a combination.
    static let missing: Peg = .clear
    
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
    
    /// Randomizes the current pegs using choices from the specified pool.
    /// If the pool is empty, assigns a missing placeholder peg.
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
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
