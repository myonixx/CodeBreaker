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
}

/// A combination of pegs and its role in a code-breaker game.
struct Code {
    
    /// The functional role of the code within the game.
    var kind: Kind
    
    /// The ordered sequence of pegs making up the combination.
    var pegs: [Peg] = [.green, .red, .red, .yellow]
    
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
