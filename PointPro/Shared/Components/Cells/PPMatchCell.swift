//
//  PPMatchCell.swift
//  PointPro
//
//  Created by Carlos Suarez on 20/5/25.
//

import SwiftUI

enum cellType {
    case simple
    case menu
}

struct PPMatchCell: View {
    var matchData = MatchData()
    var cellType: cellType = .simple
    
    var body: some View {
        switch cellType {
        case .simple:
            HStack {
                Circle()
                    .fill(Color.ppBlue)
                    .frame(width: 6, height: 6)
                HStack {
                    Text(matchData.finalScore)
                        .bold(true)
                    Text(matchData.teammates ?? "-")
                }.font(.system(size: 16))
                Spacer()
                VStack(alignment: .trailing) {
                    Text(matchData.position == .left ? "left".localizedValue : "right".localizedValue)
                        .font(.system(size: 12))
                        .foregroundStyle(.ppBlue)
                    Text(matchData.isOpenSet ? "text.openning".localizedValue : "text.receiving".localizedValue
                    )
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                
            }
        case .menu:
            ZStack {
                Color.ppBlue
                    .cornerRadius(20)
                    .frame(height: 100)
                    .shadow(radius: 5)
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        if (matchData.teammates ?? "").isEmpty || (matchData.location ?? "").isEmpty {
                            Text("Añade informacion")
                                .font(.headline)
                                .foregroundColor(.orange)
                        } else {
                            Text("\(matchData.teammates ?? "")")
                                .font(.headline)
                                .foregroundColor(.ppGreenBall)
                        }
                        
                        Text("\(matchData.location ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing:10) {
                            Text("\(matchData.date.shortFormatted)")
                                .foregroundColor(.white)
                                .font(.caption)
                            HStack(spacing:2) {
                                Image(systemName: "figure.racquetball")
                                Text("\(matchData.position.localized)")
                            }.foregroundColor(.ppGreenBall)
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    if ((matchData.teammates ?? "").isEmpty ||
                        (matchData.location ?? "").isEmpty ) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width:10)
                            .opacity(0.8)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    }
                    VStack {
                        Text("\(matchData.finalScore)")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .bold()
                            .foregroundColor(.white)
                        Text("\(matchData.pointType.rawValue)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal)
            }
        }
        
    }
}

#Preview {
    PPMatchCell(matchData: MatchData(id: UUID(),
                                     teammates: "Glenda",
                                     date: Date(),
                                     location: "Las Torres",
                                     games: [(GameScore(team1: 6, team2: 0,order: 0)),
                                             (GameScore(team1: 2, team2: 6,order: 1)),
                                             (GameScore(team1: 6, team2: 5,order: 2))],
                                     pointType: .bo3,
                                     isOpenSet: false,
                                     position: .right),cellType: .menu)
    PPMatchCell(matchData: MatchData(id: UUID(),
                                     teammates: "Glenda",
                                     date: Date(),
                                     location: "Las Torres",
                                     games: [(GameScore(team1: 6, team2: 0,order: 0)),
                                             (GameScore(team1: 2, team2: 6,order: 1)),
                                             (GameScore(team1: 6, team2: 5,order: 2))],
                                     pointType: .bo3,
                                     isOpenSet: false,
                                     position: .right),cellType: .simple)
    .padding()
}
