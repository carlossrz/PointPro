//
//  MatchDataEntity.swift
//  PointPro
//
//  Created by Carlos Suarez on 24/4/25.
//

import Foundation
import SwiftUI
import SwiftData

enum MatchFormat: String, CaseIterable, Identifiable, Codable {
    case bo1 = "Best of One"
    case bo3 = "Best of Three"
    case bo5 = "Best of Five"
    
    var id: String { self.rawValue }
    
    var numberOfGames: Int {
        switch self {
        case .bo1:
            return 1
        case .bo3:
            return 3
        case .bo5:
            return 5
        }
    }
}

enum PlayerSide: String, Codable {
    case left
    case right
    
    var localized: String {
        self.rawValue.localizedValue
    }
}

@Model
class MatchData {
    @Attribute(.unique) var id: UUID
    var teammates: String?
    var date: Date
    var location: String?
    var games: [GameScore]
    var pointType: MatchFormat
    var isOpenSet: Bool = false
    var position: PlayerSide
    
    
    var finalScore: String {
        "\(team1Wins)-\(team2Wins)"
    }
    var isWinner: Bool {
        team1Wins > team2Wins
    }
    
    var team1Wins: Int {
        games.filter { $0.team1 > $0.team2 }.count
    }
    var team2Wins: Int {
        games.filter { $0.team2 > $0.team1 }.count
    }
    
    init(id: UUID, teammates: String, date: Date, location: String, games: [GameScore], pointType: MatchFormat,isOpenSet:Bool, position: PlayerSide) {
        self.id = id
        self.teammates = teammates
        self.location = location
        self.date = date
        self.games = games
        self.pointType = pointType
        self.isOpenSet = isOpenSet
        self.position = position
    }
    
    init() {
        self.id = UUID()
        self.date = Date()
        self.games = []
        self.pointType = .bo1
        self.isOpenSet = false
        self.position = .right
    }
}

@Model
class GameScore: Hashable {
    @Attribute(.unique) var id: UUID
    var team1: Int
    var team2: Int
    var order: Int
    
    init(team1: Int, team2: Int, order: Int) {
        self.id = UUID()
        self.team1 = team1
        self.team2 = team2
        self.order = order
    }
}


struct MatchDataCodable: Codable {
    var id: String
    var teammates: String?
    var date: Date
    var location: String?
    var games: [GameScoreCodable]
    var pointType: String
    var isOpenSet: Bool
    var position: String
}

struct GameScoreCodable: Codable {
    var team1: Int
    var team2: Int
}


extension MatchData {
    func asCodable() -> MatchDataCodable {
        return MatchDataCodable(
            id: id.uuidString,
            teammates: teammates,
            date: date,
            location: location,
            games: games.map { GameScoreCodable(team1: $0.team1, team2: $0.team2) },
            pointType: "\(pointType)",
            isOpenSet: isOpenSet,
            position: "\(position)"
        )
    }
}

extension MatchDataCodable {
    func asMatchData() -> MatchData {
        return MatchData(
            id: UUID(uuidString: id)!,
            teammates: teammates ?? "",
            date: date,
            location: location ?? "",
            games: games.enumerated().map { index, game in
                GameScore(team1: game.team1, team2: game.team2, order: index)
            },
            pointType: MatchFormat(rawValue: pointType) ?? .bo1,
            isOpenSet: isOpenSet,
            position: PlayerSide(rawValue: position) ?? .right
        )
    }
}
