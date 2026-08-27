//
//  CodeMatchingTests.swift
//  CodeBreaker
//
//  Created by JD on 8/27/26.
//

import Testing
@testable import CodeBreaker

struct CodeMatchingTests {

    @Test("Returns an empty array if the Code is not an attempt")
    func testMatchesFromNonAttempt() {
        // Initial state
        let masterCode = Code(kind: .master)
        let guessCode = Code(kind: .guess)
        let unknownCode = Code(kind: .unknown)

        // Verify calling non-attempt Code's matches property returns empty array
        #expect(masterCode.matches == [])
        #expect(guessCode.matches == [])
        #expect(unknownCode.matches == [])
    }

    @Test("Returns the inner associated array when the Code is an attempt")
    func testMatchesFromAttempt() {
        // Initial state
        let attemptCode = Code(
            kind: .attempt([.exact, .inexact, .nomatch]),
            pegs: [.red, .blue, .green])

        // Verify calling attempt Code's matches property returns a Match array
        #expect(attemptCode.matches == [.exact, .inexact, .nomatch])
    }

    @Test("All pegs match exactly")
    func testPerfectMatch() {
        // Initial state
        let code1 = Code(kind: .master, pegs: [.red, .blue, .green, .yellow])
        let code2 = Code(kind: .master, pegs: [.red, .blue, .green, .yellow])

        // Match a code against another code
        let outcome = code1.match(against: code2)

        // Verify code matches exactly
        #expect(outcome == [.exact, .exact, .exact, .exact])
    }

    @Test("No pegs match at all")
    func testNoMatch() {
        // Initial state
        let code1 = Code(kind: .master, pegs: [.red, .red, .red, .red])
        let code2 = Code(kind: .master, pegs: [.blue, .blue, .blue, .blue])

        // Match a code against another code
        let outcome = code1.match(against: code2)

        // Verify code has no matches
        #expect(outcome == [.nomatch, .nomatch, .nomatch, .nomatch])
    }

    @Test("Mixed exact, inexact, and no matches")
    func testMixedMatches() {
        // Initial state
        let code1 = Code(kind: .master, pegs: [.red, .blue, .green, .green])
        let code2 = Code(kind: .master, pegs: [.red, .yellow, .blue, .yellow])

        // Match a code against another code
        let outcome = code1.match(against: code2)

        // Verify code has mixed matches
        #expect(outcome == [.exact, .inexact, .nomatch, .nomatch])
    }

    @Test("Duplicate pegs handle logic without double-counting")
    func testDuplicatePegHandling() {
        // Initial state
        let code1 = Code(kind: .master, pegs: [.red, .red, .green, .green])
        let code2 = Code(kind: .master, pegs: [.red, .blue, .yellow, .blue])

        // Match a code against another code
        let outcome = code1.match(against: code2)

        // Verify duplicate code pegs aren't counted twice
        #expect(outcome == [.exact, .nomatch, .nomatch, .nomatch])
    }

}
