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
            restartButton
        }
        .padding()
    }
    
    private var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
        .accessibilityIdentifier("guess_button")
        .disabled(game.isGuessAttemptBlank() || game.isDuplicateAttempt())
    }
    
    private var restartButton: some View {
        Button("Restart") {
            withAnimation {
                game.restartGame()
            }
        }
    }

    private func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(getPegColor(code.pegs[index]))
                    .overlay {
                        getOverlay(for: code.pegs[index])
                    }
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
                    .overlay {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
            } else {
                MatchMarkers(matches: code.matches)
            }
        }
    }
    
    private func getPegColor(_ color: String) -> Color {
        switch color {
        case "red": .red
        case "green": .green
        case "blue": .blue
        case "yellow": .yellow
        default: .clear
        }
    }
    
    @ViewBuilder
    private func getOverlay(for peg: String) -> some View {
        if peg == Code.missing {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray)
        } else if game.isEmojis {
            Text(peg)
                .font(.system(size: 120))
                .minimumScaleFactor(9/120)
        }
    }
    
}

#Preview {
    CodeBreakerView()
}
