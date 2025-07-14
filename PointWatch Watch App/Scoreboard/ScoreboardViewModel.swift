import Foundation

class ScoreboardViewModel: ObservableObject {
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
        
        if (globalPointA >= 6 || globalPointB >= 6) && difference >= 2 {
            matchData.games.append(GameScore(team1: globalPointA, team2: globalPointB))
            clearData()
            if matchData.pointType.numberOfGames == matchData.games.count {
                print("Partido finalizado")
                saveData()
                self.shouldDismiss = true
            }
        } else if (globalPointA == globalPointB) && (globalPointA >= 6) {
            let tieBreakGame = GameScore(team1: globalPointA, team2: globalPointB)
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
        liveGameScores.removeLast()
        liveGameScores = [(0,0)]
        globalPointA = 0
        globalPointB = 0
        resetPoints()
        
    }
    func resetPoints() {
        pointA = "0"
        pointB = "0"
    }
    
    func saveData() {
        #if targetEnvironment(simulator)
                    sessionManager.sendMessageMatchResult(match:matchData)
        #else
                    sessionManager.sendMatchResult(match:matchData)
        #endif
    }
}
