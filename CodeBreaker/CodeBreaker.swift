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
    let pegChoices: [Peg] = [.red, .green, .blue, .yellow]
    
    /// Submits the current guess and adds it to the attempts history.
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt
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
    enum Kind {
        
        /// The secret combination that the player is trying to guess.
        case master
        
        /// A current, unsubmitted guess made by the player.
        case guess
        
        /// A previously submitted guess that has been made.
        case attempt
        
        /// A placeholder state for an uninitialized or invalid code.
        case unknown
    }
}
