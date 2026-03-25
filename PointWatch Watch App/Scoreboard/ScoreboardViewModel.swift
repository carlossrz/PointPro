import Foundation
import os

class ScoreboardViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.pointpro.watch", category: "ScoreboardViewModel")

    @Published var team: Int = 1
    
    @Published var pointA: String = "0"
    @Published var pointB: String = "0"
    
    @Published var globalPointA: Int = 0
    @Published var globalPointB: Int = 0
    
    @Published var liveGameScores: [(team1: Int, team2: Int)] = [(0,0)]
    
    @Published var matchData = MatchData()
    @Published var shouldDismiss = false
    @Published var isTieBreak =  false
    
    let sessionManager = WatchSessionManager()
    
    let pointsMatch = ["0", "15", "30", "40", "ADV"]
    
    func sumPoint() {
        var currentPoints = (team == 1) ? pointA : pointB
        let opponentPoints = (team == 1) ? pointB : pointA
        
        var currentIndex = pointsMatch.firstIndex(of: currentPoints) ?? 0
        
        if currentPoints == "40" && opponentPoints == "40" {
            currentPoints = "ADV"
        } else if currentPoints == "40" {
            if opponentPoints == "ADV" {
                pointA = "40"
                pointB = "40"
                currentPoints = "40"
            } else if opponentPoints == "40" {
                currentPoints = "ADV"
            } else {
                resetPoints()
                globalSumPoint(team: team)
                return
            }
        } else if currentPoints == "ADV" {
            resetPoints()
            globalSumPoint(team: team)
            return
        } else {
            if currentIndex < pointsMatch.count - 1 {
                currentIndex += 1
            }
            currentPoints = pointsMatch[currentIndex]
        }
        
        if team == 1 {
            pointA = currentPoints
        } else {
            pointB = currentPoints
        }
    }
    
    func globalSumPoint(team: Int) {
        if team == 1 {
            globalPointA += 1
        } else {
            globalPointB += 1
        }

        liveGameScores.removeLast()
        liveGameScores.append((globalPointA, globalPointB))

        let difference = abs(globalPointA - globalPointB)
        let currentOrder = matchData.games.count

        if (globalPointA >= 6 || globalPointB >= 6) && difference >= 2 {
            let newGame = GameScore(team1: globalPointA, team2: globalPointB, order: currentOrder)
            matchData.games.append(newGame)
            clearData()

            if matchData.pointType.numberOfGames == matchData.games.count {
                logger.info("Partido finalizado")
                saveData()
                self.shouldDismiss = true
            }
        } else if (globalPointA == globalPointB) && (globalPointA >= 6) {
            let tieBreakGame = GameScore(team1: globalPointA, team2: globalPointB, order: currentOrder)
            matchData.games.append(tieBreakGame)

            clearData()
            isTieBreak = true
        }
    }

    func restPoint() {
        var currentPoints = (team == 1) ? pointA : pointB
        var currentIndex = pointsMatch.firstIndex(of: currentPoints) ?? 0
        
        if currentIndex > 0{
            currentIndex -= 1
            currentPoints = pointsMatch[currentIndex]
            if team == 1 {
                pointA = currentPoints
            } else {
                pointB = currentPoints
            }
        }
    }
    
    func clearData() {
        if !liveGameScores.isEmpty {
            liveGameScores.removeLast()
        }
        liveGameScores = [(0,0)]
        globalPointA = 0
        globalPointB = 0
        resetPoints()
        
    }
    func resetPoints() {
        pointA = "0"
        pointB = "0"
    }
    
    private func appendPartialGameIfNeeded() {
        // If there's an ongoing game with non-zero score, append it so partial results are saved
        let currentA = globalPointA
        let currentB = globalPointB
        guard currentA != 0 || currentB != 0 else { return }

        // If last game already matches current partial score, don't duplicate
        if let last = matchData.games.last {
            if last.team1 == currentA && last.team2 == currentB {
                return
            }
        }

        let newGame = GameScore(team1: currentA, team2: currentB, order: matchData.games.count)
        matchData.games.append(newGame)
    }

    func saveData() {
        // Ensure partial current game is recorded before sending
        appendPartialGameIfNeeded()

        #if targetEnvironment(simulator)
                    sessionManager.sendMessageMatchResult(match:matchData)
        #else
                    sessionManager.sendMatchResult(match:matchData)
        #endif
    }
}
