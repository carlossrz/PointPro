//
//  PPResultsCardView.swift
//  PointPro
//
//  Created by Carlos Suarez on 4/6/25.
//

import SwiftUI

struct PPResultsCardView: View {
    var match: MatchData

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 90))
    ]

    var body: some View {
        // Ordenar los juegos por su campo `order`
        let sortedGames = match.games.sorted { $0.order < $1.order }

        LazyVGrid(columns: adaptiveColumns, spacing: 0) {
            ForEach(Array(sortedGames.enumerated()), id: \.offset) { index, game in
                PPResult(pTeam1: game.team1,
                         pTeam2: game.team2,
                         number: index)
            }
        }
    }
}


#Preview {
    PPResultsCardView(match: MatchData(id: UUID(),
                                       teammates: "",
                                       date: Date(),
                                       location: "",
                                       games: [(GameScore(team1: 6, team2: 0,order: 0)),
                                               (GameScore(team1: 2, team2: 6,order: 1)),
                                               (GameScore(team1: 6, team2: 5,order: 2)),
                                               (GameScore(team1: 6, team2: 5,order: 3)),
                                               (GameScore(team1: 6, team2: 5, order: 4))],
                                       pointType: .bo3,
                                       isOpenSet: false,
                                       position: .right))
}
