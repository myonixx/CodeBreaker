//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by JD on 8/13/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker()

    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            Button("Guess") {
                withAnimation {
                    game.attemptGuess()
                }
            }
            .accessibilityIdentifier("guessButton")
        }
        .padding()
    }

    private func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
                    // Tell UI Tests this rectangle can be interacted with like a button
                    .accessibilityAddTraits(.isButton)
                    // Give each rectangle a unique name based on its index
                    .accessibilityIdentifier("\(code.kind)_code_peg_\(index)")
                    // Expose the current peg color to XCUITest (e.g., "red", "blue", etc.)
                    .accessibilityLabel("\(code.pegs[index].description)")
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    CodeBreakerView()
}
