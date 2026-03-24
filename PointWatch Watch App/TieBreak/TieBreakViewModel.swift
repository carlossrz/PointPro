//
//  TieBreakViewModel.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 11/7/25.
//

import Foundation
import os

class TieBreakViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.pointpro.watch", category: "TieBreakViewModel")

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
        
        if matchData.games.isEmpty {
            logger.warning("No hay juego previo para actualizar el tie-break")
            return
        }
        
        if (tieBreakPointsA >= 7 || tieBreakPointsB >= 7) && diff >= 2 {
            // If there's an existing placeholder tie-break game (e.g., 6-6), update it; otherwise append the final result
            if let last = matchData.games.last {
                if last.team1 == last.team2 && last.team1 >= 6 {
                    // Update the existing game in-place (GameScore is a class-model)
                    last.team1 = tieBreakPointsA
                    last.team2 = tieBreakPointsB
                    logger.debug("Updated existing tie-break game to \(self.tieBreakPointsA)-\(self.tieBreakPointsB)")
                } else {
                    // No placeholder, append as a new game
                    let finalGame = GameScore(team1: tieBreakPointsA, team2: tieBreakPointsB, order: matchData.games.count)
                    matchData.games.append(finalGame)
                    logger.debug("Appended final tie-break game \(self.tieBreakPointsA)-\(self.tieBreakPointsB)")
                }
            } else {
                // Fallback: append
                let finalGame = GameScore(team1: tieBreakPointsA, team2: tieBreakPointsB, order: matchData.games.count)
                matchData.games.append(finalGame)
                logger.debug("Appended final tie-break game (fallback) \(self.tieBreakPointsA)-\(self.tieBreakPointsB)")
            }
            
            shouldDismiss = true
        }
    }
}
