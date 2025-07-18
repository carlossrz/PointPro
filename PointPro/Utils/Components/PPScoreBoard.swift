//
//  PPScoreBoard.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 30/4/25.
//

import SwiftUI

struct PPScoreBoard: View {
    var isOpenSet: Bool = false
    var globalPointsMatch: [GameScore] = []
    var liveGameScores: [(team1: Int, team2: Int)] = [(0,0)]
    
    var body: some View {
        HStack (spacing: 2){
            Text("🎾")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .padding(.top,isOpenSet ? -25 : 25)
            if !globalPointsMatch.isEmpty {
                HStack(spacing: 2) {
                    ForEach(globalPointsMatch.indices, id: \.self) { index in
                        let score = globalPointsMatch[index]
                        VStack(spacing:2){
                            Text("\(score.team1)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .frame(width: 25, height: 25)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .opacity(score.team2 > score.team1 ? 0.4 : 1)
                            Text("\(score.team2)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .frame(width: 25, height: 25)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .opacity(score.team1 > score.team2 ? 0.4 : 1)
                        }
                    }
                }
            }
            
            
            HStack(spacing: 2) {
                ForEach(liveGameScores.indices, id: \.self) { index in
                    let score = liveGameScores[index]
                    VStack(spacing:2){
                        Text("\(score.team1)")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .frame(width: 25, height: 25)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                        Text("\(score.team2)")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .frame(width: 25, height: 25)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
            }
        }
    }
}

#Preview {
    PPScoreBoard(
        isOpenSet: false ,
        globalPointsMatch: [GameScore(team1: 6, team2: 4, order: 0),GameScore(team1: 2, team2: 6, order: 1)],
        liveGameScores: [(1,0)])
}
