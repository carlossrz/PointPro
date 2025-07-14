//
//  TieBreakViewModel.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 11/7/25.
//

import Foundation

class TieBreakViewModel: ObservableObject {
    @Published var team: Int = 1
    
    @Published var tieBreakPointsA: Int = 0
    @Published var tieBreakPointsB: Int = 0
    
    @Published var shouldDismiss = false
    @Published var isTieBreak = false
    
    var matchData: MatchData
    
    init(matchData: MatchData) {
        self.matchData = matchData
    }
    
    func sumPoint(team: Int) {
        if team == 1 {
            tieBreakPointsA += 1
        } else {
            tieBreakPointsB += 1
        }
        
        checkTieBreakWinner()
    }
    
    private func checkTieBreakWinner() {
        let diff = abs(tieBreakPointsA - tieBreakPointsB)
        
        if tieBreakPointsA >= 7 && diff >= 2 {
            endTieBreak(winner: 1)
        } else if tieBreakPointsB >= 7 && diff >= 2 {
            endTieBreak(winner: 2)
        }
    }
    
    private func endTieBreak(winner: Int) {
        guard let lastGame = matchData.games.last else {
            print("❌ No hay juego previo para actualizar el tie-break")
            return
        }
        
        if winner == 1 {
            lastGame.team1 += 1
        } else {
            lastGame.team2 += 1
        }

        tieBreakPointsA = 0
        tieBreakPointsB = 0
        isTieBreak = false
        shouldDismiss = true
        
    }
    
}

