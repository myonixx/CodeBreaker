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
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("guess_code")
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                        .accessibilityElement(children: .contain)
                        .accessibilityIdentifier("attempt_code_\(index)")
                        
                }
            }
            Button("Guess") {
                withAnimation {
                    game.attemptGuess()
                }
            }
            .accessibilityIdentifier("guess_button")
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
                    .accessibilityAddTraits(.isButton)
                    .accessibilityIdentifier("peg_\(index)_\(code.pegs[index].description)")
            }
            if code.kind == .master || code.kind == .guess {
                MatchMarkers(matches: [.nomatch, .nomatch, .nomatch, .nomatch])
            } else {
                MatchMarkers(matches: code.matches)
            }
        }
    }
    
}

#Preview {
    CodeBreakerView()
}
