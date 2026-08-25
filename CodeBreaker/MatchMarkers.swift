//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by JD on 8/13/26.
//

import SwiftUI

enum Match {
    case nomatch, exact, inexact
}

struct MatchMarkers: View {
    var matches: [Match]

    var body: some View {
        HStack {
            ForEach(Array(stride(from: 0, through: matches.count, by: 2)), id: \.self) { index in
                VStack {
                    matchMarker(peg: index)
                    matchMarker(peg: index + 1)
                }
            }
        }
    }

    private func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { match in match == .exact }
        let foundCount = matches.count { match in match != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 1)
            .aspectRatio(1, contentMode: .fit)
            .accessibilityIdentifier("match_marker_\(peg)")
            .accessibilityValue(exactCount > peg ? "exact" : foundCount > peg ? "inexact" : "nomatch")
    }
}

private struct MatchMarkersPreview: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { index in
                Circle().aspectRatio(1, contentMode: .fit)
            }
            MatchMarkers(matches: matches)
        }
        .padding()
    }
}

#Preview {
    VStack(alignment: .leading) {
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .nomatch, .nomatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .inexact])
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .exact])
        MatchMarkersPreview(matches: [.nomatch, .inexact, .exact, .nomatch])
        MatchMarkersPreview(matches: [.inexact, .exact, .nomatch, .exact, .nomatch, .exact])
        MatchMarkersPreview(matches: [.inexact, .inexact, .inexact, .exact, .exact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .exact, .inexact])
        MatchMarkersPreview(matches: [.inexact, .exact, .inexact, .nomatch, .nomatch])
    }
}
