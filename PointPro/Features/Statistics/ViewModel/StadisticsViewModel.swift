//
//  StadisticsViewModel.swift
//  PointPro
//
//  Created by Carlos Suarez on 17/6/25.
//


import SwiftUI
import Combine

final class StatisticsViewModel: ObservableObject {
    @Published var matches: [MatchData] = []
    
    var lastThreeMatches: [MatchData] {
        Array(matches.prefix(3))
    }
    
    var totalMatches: Int {
        matches.count
    }
    
    // Average sets per match
    var averageSetsPerMatch: Double {
        guard !matches.isEmpty else { return 0 }
        let totalSets = matches.reduce(0) { $0 + $1.games.count }
        return Double(totalSets) / Double(matches.count)
    }
    
    // Tie-break frequency (heuristic)
    var tieBreakMatchesCount: Int {
        matches.filter { match in
            match.games.contains { game in
                // heuristic: a tie-break-like game where both reached >=6 and possibly equal at entry
                (game.team1 >= 6 || game.team2 >= 6) && (abs(game.team1 - game.team2) <= 2)
            }
        }.count
    }
    
    var tieBreakFrequency: Double {
        guard !matches.isEmpty else { return 0 }
        return Double(tieBreakMatchesCount) / Double(matches.count)
    }
    
    // Current win streak (newest matches first)
    var currentWinStreak: Int {
        let sorted = matches.sorted { $0.date > $1.date }
        var streak = 0
        for m in sorted {
            if m.isWinner { streak += 1 } else { break }
        }
        return streak
    }
    
    var wonMatches: Int {
        matches.filter { $0.isWinner }.count
    }
    
    var lostMatches: Int {
        matches.filter { !$0.isWinner && $0.team1Wins != $0.team2Wins }.count
    }
    
    var drawMatches: Int {
        matches.filter { $0.team1Wins == $0.team2Wins }.count
    }
    
    var winPercentage: Double {
        guard totalMatches > 0 else { return 0 }
        return Double(wonMatches) / Double(totalMatches)
    }
    
    var leftMatchesWin: Int{
        matches.filter { $0.isWinner && $0.position == .left }.count
    }
    var leftMatchesLost: Int{
        matches.filter { !$0.isWinner && $0.position == .left }.count
    }
    
    var rightMatchesWin: Int{
        matches.filter { $0.isWinner && $0.position == .right }.count
    }
    var rightMatchesLost: Int{
        matches.filter { !$0.isWinner && $0.position == .right }.count
    }
    //Cuando abres el partido
    var wonMatchesWhenOpening: Int {
        matches.filter { $0.isWinner && $0.isOpenSet }.count
    }
    var totalMatchesWhenOpening: Int {
        matches.filter { $0.isOpenSet }.count
    }
    // Cuando recibes
    var wonMatchesWhenReceiving: Int {
        matches.filter { $0.isWinner && !$0.isOpenSet }.count
    }
    var totalMatchesWhenReceiving: Int {
        matches.filter { !$0.isOpenSet }.count
    }
    var sideStats: [PositionStat] {
        [
            .init(side: "left".localizedValue, result: "text.wins".localizedValue, count: leftMatchesWin),
            .init(side: "left".localizedValue, result: "text.losses".localizedValue, count: leftMatchesLost),
            .init(side: "right".localizedValue, result: "text.wins".localizedValue,  count: rightMatchesWin),
            .init(side: "right".localizedValue, result: "text.losses".localizedValue, count: rightMatchesLost),
        ]
    }
    
    init(matches: [MatchData] = []) {
        self.matches = matches
    }
    
    func updateMatches(with newMatches: [MatchData]) {
        self.matches = newMatches
    }
    
}
