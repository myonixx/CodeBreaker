//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by JD on 8/13/26.
//

import SwiftUI

struct CodeBreakerView: View {
    let game = CodeBreaker()
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            view(for: game.guess)
        }
        .padding()
    }
    
    private func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    CodeBreakerView()
}
